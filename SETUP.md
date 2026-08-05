# ExamPrep Setup Guide

## 1. Create a Supabase project
1. Go to Supabase, create a new project, and wait for provisioning to finish.
2. Open **SQL Editor** and paste the complete SQL from `supabase/schema.sql`.

## 2. Exact SQL to paste
Paste everything in `supabase/schema.sql`. It creates `classes`, `subjects`, `topics`, `quizzes`, `questions`, `pyqs`, `notes`, `profiles`, and `quiz_attempts`, enables Row Level Security on each table, and adds policies where public content is readable, admin writes are restricted, profiles are self/admin scoped, and attempts are self/admin scoped.

## 3. Storage buckets
The SQL creates private `pyqs` and `notes` buckets. If creating manually, open **Storage → New bucket**, create `pyqs`, keep **Public bucket** off, then repeat for `notes`.

## 4. Enable email auth
Open **Authentication → Providers → Email**. Enable email provider and magic links. Configure your production site URL after Vercel deploy.

## 5. Environment variables
Open **Project Settings → API** and copy the Project URL and anon public key. Create `.env` from `.env.example` and paste:

```bash
VITE_SUPABASE_URL=https://your-project-ref.supabase.co
VITE_SUPABASE_ANON_KEY=your-public-anon-key
```

The only Supabase config file is `src/lib/supabaseClient.ts`.

## 6. Promote the first admin
After signing in once, run this in Supabase SQL Editor, replacing the email:

```sql
update public.profiles
set role = 'admin'
where id = (select id from auth.users where email = 'owner@example.com');
```

## 7. Deploy to Vercel
1. Push this repo to GitHub.
2. Import the project in Vercel.
3. Set Framework Preset to **Vite**.
4. Add `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` in **Settings → Environment Variables**.
5. Deploy. Vercel will auto-deploy every push to the connected branch.

## Security notes
- Resource downloads are gated by Supabase Auth and generated as short-lived signed URLs from private buckets.
- PWA install is never gated by login.
- Typing `@dmin` is only a UI trigger. The app re-checks `profiles.role = 'admin'`, and RLS/server policies protect real admin data/actions.
