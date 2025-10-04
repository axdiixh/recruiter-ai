-- Create users table
create table if not exists users (
  id uuid primary key default gen_random_uuid(),
  auth_user_id uuid references auth.users(id) on delete cascade,
  org_id uuid references organizations(id) on delete cascade,
  role text check (role in ('admin','recruiter')) default 'recruiter',
  created_at timestamp with time zone default now()
);