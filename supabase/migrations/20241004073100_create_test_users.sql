-- Create test data to support RLS testing
-- Note: You'll need to create actual auth users via Supabase Auth API first
-- This migration prepares sample data for when users exist

-- Add sample jobs for both organizations to test RLS
INSERT INTO jobs (org_id, title, description, created_by)
SELECT 
  o.id, 
  'Senior React Developer', 
  'We are looking for a Senior React Developer with 5+ years experience in modern React, TypeScript, and Redux.',
  null
FROM organizations o 
WHERE o.name = 'TechRecruit Ltd'
ON CONFLICT DO NOTHING;

INSERT INTO jobs (org_id, title, description, created_by)
SELECT 
  o.id, 
  'DevOps Engineer', 
  'Seeking a DevOps Engineer experienced with AWS, Kubernetes, and CI/CD pipelines.',
  null
FROM organizations o 
WHERE o.name = 'HireGenius Inc'
ON CONFLICT DO NOTHING;

-- Add sample CVs for testing
INSERT INTO cvs (org_id, uploaded_by, file_url, original_filename)
SELECT 
  o.id,
  null,
  'https://example.com/cv1.pdf',
  'john_doe_cv.pdf'
FROM organizations o 
WHERE o.name = 'TechRecruit Ltd'
ON CONFLICT DO NOTHING;

INSERT INTO cvs (org_id, uploaded_by, file_url, original_filename)
SELECT 
  o.id,
  null,
  'https://example.com/cv2.pdf',
  'jane_smith_cv.pdf'
FROM organizations o 
WHERE o.name = 'HireGenius Inc'
ON CONFLICT DO NOTHING;

-- Add sample candidate profiles
INSERT INTO candidate_profiles (org_id, cv_id, name, email, phone, skills, experience_years, education, summary)
SELECT 
  o.id,
  c.id,
  'John Doe',
  'john.doe@email.com',
  '+1234567890',
  ARRAY['React', 'TypeScript', 'Node.js', 'PostgreSQL'],
  5,
  'Computer Science, University of Technology',
  'Experienced full-stack developer with strong React and Node.js skills.'
FROM organizations o 
CROSS JOIN cvs c
WHERE o.name = 'TechRecruit Ltd' AND c.original_filename = 'john_doe_cv.pdf'
ON CONFLICT DO NOTHING;

INSERT INTO candidate_profiles (org_id, cv_id, name, email, phone, skills, experience_years, education, summary)
SELECT 
  o.id,
  c.id,
  'Jane Smith',
  'jane.smith@email.com',
  '+1987654321',
  ARRAY['AWS', 'Kubernetes', 'Docker', 'Python', 'Terraform'],
  7,
  'DevOps Engineering, Tech Institute',
  'Senior DevOps engineer with extensive cloud infrastructure experience.'
FROM organizations o 
CROSS JOIN cvs c
WHERE o.name = 'HireGenius Inc' AND c.original_filename = 'jane_smith_cv.pdf'
ON CONFLICT DO NOTHING;
