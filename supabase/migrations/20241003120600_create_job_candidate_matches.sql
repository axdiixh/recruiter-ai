-- Create job_candidate_matches table
create table if not exists job_candidate_matches (
  id uuid primary key default gen_random_uuid(),
  org_id uuid references organizations(id) on delete cascade,
  job_id uuid references jobs(id) on delete cascade,
  candidate_id uuid references candidate_profiles(id) on delete cascade,
  match_score numeric(5,2),
  ai_summary text,
  created_at timestamp with time zone default now(),
  unique (job_id, candidate_id)
);