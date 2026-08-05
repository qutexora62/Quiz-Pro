export const demo = {
  classes: [{ id: 'c10', name: 'Class 10' }, { id: 'c12', name: 'Class 12' }],
  subjects: [
    { id: 'math10', class_id: 'c10', name: 'Mathematics' }, { id: 'sci10', class_id: 'c10', name: 'Science' },
    { id: 'phy12', class_id: 'c12', name: 'Physics' }, { id: 'chem12', class_id: 'c12', name: 'Chemistry' }
  ],
  topics: [
    { id: 'alg', subject_id: 'math10', name: 'Algebra' }, { id: 'light', subject_id: 'sci10', name: 'Light' },
    { id: 'kin', subject_id: 'phy12', name: 'Kinematics' }, { id: 'org', subject_id: 'chem12', name: 'Organic Basics' }
  ],
  quizzes: [
    { id: 'q1', topic_id: 'alg', title: 'Linear Equations Sprint', duration_seconds: 300 },
    { id: 'q2', topic_id: 'light', title: 'Reflection & Refraction', duration_seconds: 420 },
    { id: 'q3', topic_id: 'kin', title: 'Motion Graphs Mastery', duration_seconds: 360 }
  ],
  questions: [
    { id: 'a', quiz_id: 'q1', body: 'If 2x + 3 = 11, x equals?', options: ['3', '4', '5', '7'], correct_option: 1, explanation: 'Subtract 3, then divide 8 by 2.' },
    { id: 'b', quiz_id: 'q1', body: 'The slope of y = 5x - 2 is:', options: ['-2', '2', '5', '0'], correct_option: 2, explanation: 'Slope-intercept form y = mx + b has slope m.' },
    { id: 'c', quiz_id: 'q2', body: 'Angle of incidence is equal to angle of:', options: ['Refraction', 'Reflection', 'Dispersion', 'Deviation'], correct_option: 1, explanation: 'This is the law of reflection.' },
    { id: 'd', quiz_id: 'q3', body: 'Area under a velocity-time graph gives:', options: ['Acceleration', 'Displacement', 'Force', 'Power'], correct_option: 1, explanation: 'Velocity integrated over time is displacement.' }
  ],
  pyqs: [
    { id: 'p1', class_id: 'c10', subject_id: 'math10', title: 'Math Board PYQ Set', year: 2025, file_path: 'class10/math-2025.pdf', downloads: 128 },
    { id: 'p2', class_id: 'c12', subject_id: 'phy12', title: 'Physics PYQ Numericals', year: 2024, file_path: 'class12/physics-2024.pdf', downloads: 95 }
  ],
  notes: [
    { id: 'n1', class_id: 'c10', subject_id: 'math10', topic_id: 'alg', title: 'Algebra Handwritten Formula Sheet', file_path: 'class10/algebra.pdf', downloads: 211 },
    { id: 'n2', class_id: 'c12', subject_id: 'phy12', topic_id: 'kin', title: 'Kinematics Graph Notes', file_path: 'class12/kinematics.pdf', downloads: 173 }
  ]
};
