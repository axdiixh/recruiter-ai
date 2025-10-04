-- Seed data for recruiter-ai-saas database

-- Insert organizations
insert into organizations (name) values 
  ('TechRecruit Ltd'), 
  ('HireGenius Inc');

-- Insert sample users (this will need auth.users to exist first)
-- Note: In a real setup, you'd create auth users first via the auth API
-- This is commented out as it depends on auth.users existing
-- 
-- To test RLS policies, you can:
-- 1. Use the Supabase Dashboard to create a user via Auth
-- 2. Or run the add_test_user.sql script to create a test user
-- 3. Or use the Supabase Auth API in your application
--
-- Example for testing (uncomment after creating auth user):
-- insert into users (auth_user_id, org_id, role)
-- select au.id, o.id, 'admin'
-- from auth.users au, organizations o
-- where au.email = 'admin@techrecruit.com'
-- limit 1;

-- Insert sample jobs
insert into jobs (org_id, title, description, created_by)
select 
  o.id, 
  'Software Engineer', 
  'Looking for a Node.js developer with React experience. Must have 3+ years experience.' ,
  null
from organizations o 
where o.name = 'TechRecruit Ltd'
limit 1;

insert into jobs (org_id, title, description, created_by)
select 
  o.id, 
  'Senior Frontend Developer', 
  'Seeking experienced React/Vue.js developer for complex web applications.',
  null
from organizations o 
where o.name = 'HireGenius Inc'
limit 1;