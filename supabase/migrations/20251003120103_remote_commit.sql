-- RLS and multi-tenant policies for recruiter-ai-saas
-- Assumptions:
-- - Each table has `org_id` to scope tenant access (except `organizations`)
-- - `users.auth_user_id` maps to `auth.users.id`
-- - Roles in `users.role`: 'admin', 'recruiter'

-- Helper: function to get current org_id for the logged in auth user
create or replace function public.current_user_org_id()
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select u.org_id
  from public.users u
  where u.auth_user_id = auth.uid()
  limit 1;
$$;

-- Helper: check if current user is org admin
create or replace function public.is_org_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce((
    select u.role = 'admin'
    from public.users u
    where u.auth_user_id = auth.uid()
    limit 1
  ), false);
$$;

-- Enable RLS on all domain tables
alter table public.organizations enable row level security;
alter table public.users enable row level security;
alter table public.cvs enable row level security;
alter table public.jobs enable row level security;
alter table public.candidate_profiles enable row level security;
alter table public.job_candidate_matches enable row level security;

-- Organizations: members can see only their org; admins can manage their org
drop policy if exists orgs_select on public.organizations;
create policy orgs_select on public.organizations
  for select
  using (id = current_user_org_id());

drop policy if exists orgs_update on public.organizations;
create policy orgs_update on public.organizations
  for update
  using (id = current_user_org_id() and is_org_admin())
  with check (id = current_user_org_id());

-- Users: visible within same org; updates restricted
drop policy if exists users_select on public.users;
create policy users_select on public.users
  for select
  using (org_id = current_user_org_id());

drop policy if exists users_insert on public.users;
create policy users_insert on public.users
  for insert
  with check (
    org_id = current_user_org_id() and is_org_admin()
  );

drop policy if exists users_update on public.users;
create policy users_update on public.users
  for update
  using (org_id = current_user_org_id() and (is_org_admin() or auth.uid() = auth_user_id))
  with check (org_id = current_user_org_id());

drop policy if exists users_delete on public.users;
create policy users_delete on public.users
  for delete
  using (org_id = current_user_org_id() and is_org_admin());

-- Generic helper macro (conceptually) applied per table with org_id
-- cvs
drop policy if exists cvs_select on public.cvs;
create policy cvs_select on public.cvs for select using (org_id = current_user_org_id());

drop policy if exists cvs_insert on public.cvs;
create policy cvs_insert on public.cvs for insert with check (org_id = current_user_org_id());

drop policy if exists cvs_update on public.cvs;
create policy cvs_update on public.cvs for update using (org_id = current_user_org_id()) with check (org_id = current_user_org_id());

drop policy if exists cvs_delete on public.cvs;
create policy cvs_delete on public.cvs for delete using (org_id = current_user_org_id() and is_org_admin());

-- jobs
drop policy if exists jobs_select on public.jobs;
create policy jobs_select on public.jobs for select using (org_id = current_user_org_id());

drop policy if exists jobs_insert on public.jobs;
create policy jobs_insert on public.jobs for insert with check (org_id = current_user_org_id());

drop policy if exists jobs_update on public.jobs;
create policy jobs_update on public.jobs for update using (org_id = current_user_org_id()) with check (org_id = current_user_org_id());

drop policy if exists jobs_delete on public.jobs;
create policy jobs_delete on public.jobs for delete using (org_id = current_user_org_id() and is_org_admin());

-- candidate_profiles
drop policy if exists candidate_profiles_select on public.candidate_profiles;
create policy candidate_profiles_select on public.candidate_profiles for select using (org_id = current_user_org_id());

drop policy if exists candidate_profiles_insert on public.candidate_profiles;
create policy candidate_profiles_insert on public.candidate_profiles for insert with check (org_id = current_user_org_id());

drop policy if exists candidate_profiles_update on public.candidate_profiles;
create policy candidate_profiles_update on public.candidate_profiles for update using (org_id = current_user_org_id()) with check (org_id = current_user_org_id());

drop policy if exists candidate_profiles_delete on public.candidate_profiles;
create policy candidate_profiles_delete on public.candidate_profiles for delete using (org_id = current_user_org_id() and is_org_admin());

-- job_candidate_matches
drop policy if exists job_candidate_matches_select on public.job_candidate_matches;
create policy job_candidate_matches_select on public.job_candidate_matches for select using (org_id = current_user_org_id());

drop policy if exists job_candidate_matches_insert on public.job_candidate_matches;
create policy job_candidate_matches_insert on public.job_candidate_matches for insert with check (org_id = current_user_org_id());

drop policy if exists job_candidate_matches_update on public.job_candidate_matches;
create policy job_candidate_matches_update on public.job_candidate_matches for update using (org_id = current_user_org_id()) with check (org_id = current_user_org_id());

drop policy if exists job_candidate_matches_delete on public.job_candidate_matches;
create policy job_candidate_matches_delete on public.job_candidate_matches for delete using (org_id = current_user_org_id() and is_org_admin());

-- Optional: block access when there is no mapped user/org (auth-only access)
-- This pattern requires that current_user_org_id() returns null for unmapped users;
-- the policies above will deny access since comparisons with null are false.

