-- Create cvs table
create table if not exists cvs (
  id uuid primary key default gen_random_uuid(),
  org_id uuid references organizations(id) on delete cascade,
  uploaded_by uuid references users(id),
  file_url text not null,
  original_filename text,
  created_at timestamp with time zone default now()
);