-- Create jobs table
create table if not exists jobs (
  id uuid primary key default gen_random_uuid(),
  org_id uuid references organizations(id) on delete cascade,
  title text not null,
  description text,
  created_by uuid references users(id),
  created_at timestamp with time zone default now()
);