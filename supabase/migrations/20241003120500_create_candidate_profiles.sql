-- Create candidate_profiles table
create table if not exists candidate_profiles (
  id uuid primary key default gen_random_uuid(),
  org_id uuid references organizations(id) on delete cascade,
  cv_id uuid references cvs(id) on delete cascade,
  name text,
  email text,
  phone text,
  skills text[],
  experience_years int,
  education text,
  summary text,
  created_at timestamp with time zone default now()
);