create extension if not exists pgcrypto;

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  role text not null default 'student' check (role in ('student','admin')),
  last_active_at timestamptz default now(),
  created_at timestamptz not null default now()
);
create table public.classes (id uuid primary key default gen_random_uuid(), name text not null, sort_order int default 0, created_at timestamptz default now());
create table public.subjects (id uuid primary key default gen_random_uuid(), class_id uuid not null references public.classes(id) on delete cascade, name text not null, sort_order int default 0, created_at timestamptz default now());
create table public.topics (id uuid primary key default gen_random_uuid(), subject_id uuid not null references public.subjects(id) on delete cascade, name text not null, sort_order int default 0, created_at timestamptz default now());
create table public.quizzes (id uuid primary key default gen_random_uuid(), topic_id uuid not null references public.topics(id) on delete cascade, title text not null, duration_seconds int, is_published boolean default true, created_at timestamptz default now());
create table public.questions (id uuid primary key default gen_random_uuid(), quiz_id uuid not null references public.quizzes(id) on delete cascade, body text not null, options jsonb not null, correct_option int not null, explanation text, sort_order int default 0, created_at timestamptz default now());
create table public.pyqs (id uuid primary key default gen_random_uuid(), class_id uuid not null references public.classes(id) on delete cascade, subject_id uuid not null references public.subjects(id) on delete cascade, title text not null, year int not null, file_path text not null, download_count int default 0, created_at timestamptz default now());
create table public.notes (id uuid primary key default gen_random_uuid(), class_id uuid not null references public.classes(id) on delete cascade, subject_id uuid not null references public.subjects(id) on delete cascade, topic_id uuid references public.topics(id) on delete set null, title text not null, file_path text not null, download_count int default 0, created_at timestamptz default now());
create table public.quiz_attempts (id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade, quiz_id uuid not null references public.quizzes(id) on delete cascade, score int not null, total int not null, answers jsonb not null, created_at timestamptz default now());

create or replace function public.is_admin() returns boolean language sql stable security definer set search_path = public as $$ select exists (select 1 from public.profiles where id = auth.uid() and role = 'admin'); $$;
create or replace function public.handle_new_user() returns trigger language plpgsql security definer set search_path = public as $$ begin insert into public.profiles (id, full_name) values (new.id, coalesce(new.raw_user_meta_data->>'full_name', split_part(new.email,'@',1))); return new; end; $$;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();

alter table public.profiles enable row level security; alter table public.classes enable row level security; alter table public.subjects enable row level security; alter table public.topics enable row level security; alter table public.quizzes enable row level security; alter table public.questions enable row level security; alter table public.pyqs enable row level security; alter table public.notes enable row level security; alter table public.quiz_attempts enable row level security;

create policy "profiles own select or admin" on public.profiles for select using (auth.uid() = id or public.is_admin());
create policy "profiles own update or admin" on public.profiles for update using (auth.uid() = id or public.is_admin()) with check (auth.uid() = id or public.is_admin());

create policy "public read classes" on public.classes for select using (true); create policy "admin write classes" on public.classes for all using (public.is_admin()) with check (public.is_admin());
create policy "public read subjects" on public.subjects for select using (true); create policy "admin write subjects" on public.subjects for all using (public.is_admin()) with check (public.is_admin());
create policy "public read topics" on public.topics for select using (true); create policy "admin write topics" on public.topics for all using (public.is_admin()) with check (public.is_admin());
create policy "public read quizzes" on public.quizzes for select using (true); create policy "admin write quizzes" on public.quizzes for all using (public.is_admin()) with check (public.is_admin());
create policy "public read questions" on public.questions for select using (true); create policy "admin write questions" on public.questions for all using (public.is_admin()) with check (public.is_admin());
create policy "public read pyqs" on public.pyqs for select using (true); create policy "admin write pyqs" on public.pyqs for all using (public.is_admin()) with check (public.is_admin());
create policy "public read notes" on public.notes for select using (true); create policy "admin write notes" on public.notes for all using (public.is_admin()) with check (public.is_admin());

create policy "attempts own insert" on public.quiz_attempts for insert with check (auth.uid() = user_id);
create policy "attempts own select or admin" on public.quiz_attempts for select using (auth.uid() = user_id or public.is_admin());

insert into storage.buckets (id, name, public) values ('pyqs','pyqs',false), ('notes','notes',false) on conflict (id) do update set public = false;
