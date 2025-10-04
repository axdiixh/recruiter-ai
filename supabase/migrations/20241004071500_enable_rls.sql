-- Enable Row Level Security on all tables
ALTER TABLE organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE cvs ENABLE ROW LEVEL SECURITY;
ALTER TABLE candidate_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE job_candidate_matches ENABLE ROW LEVEL SECURITY;

-- Organizations policies
CREATE POLICY "Users can view their own organization"
ON organizations FOR SELECT
USING (
  id IN (
    SELECT org_id FROM users 
    WHERE auth_user_id = auth.uid()
  )
);

CREATE POLICY "Admins can update their organization"
ON organizations FOR UPDATE
USING (
  id IN (
    SELECT org_id FROM users 
    WHERE auth_user_id = auth.uid() AND role = 'admin'
  )
);

-- Users policies
CREATE POLICY "Users can view users in their organization"
ON users FOR SELECT
USING (
  org_id IN (
    SELECT org_id FROM users 
    WHERE auth_user_id = auth.uid()
  )
);

CREATE POLICY "Users can update their own profile"
ON users FOR UPDATE
USING (auth_user_id = auth.uid());

CREATE POLICY "Admins can manage users in their organization"
ON users FOR ALL
USING (
  org_id IN (
    SELECT org_id FROM users 
    WHERE auth_user_id = auth.uid() AND role = 'admin'
  )
);

-- Jobs policies
CREATE POLICY "Users can view jobs in their organization"
ON jobs FOR SELECT
USING (
  org_id IN (
    SELECT org_id FROM users 
    WHERE auth_user_id = auth.uid()
  )
);

CREATE POLICY "Users can create jobs in their organization"
ON jobs FOR INSERT
WITH CHECK (
  org_id IN (
    SELECT org_id FROM users 
    WHERE auth_user_id = auth.uid()
  )
);

CREATE POLICY "Users can update jobs they created or admins can update any job in their org"
ON jobs FOR UPDATE
USING (
  (created_by IN (SELECT id FROM users WHERE auth_user_id = auth.uid()))
  OR 
  (org_id IN (
    SELECT org_id FROM users 
    WHERE auth_user_id = auth.uid() AND role = 'admin'
  ))
);

CREATE POLICY "Users can delete jobs they created or admins can delete any job in their org"
ON jobs FOR DELETE
USING (
  (created_by IN (SELECT id FROM users WHERE auth_user_id = auth.uid()))
  OR 
  (org_id IN (
    SELECT org_id FROM users 
    WHERE auth_user_id = auth.uid() AND role = 'admin'
  ))
);

-- CVs policies
CREATE POLICY "Users can view CVs in their organization"
ON cvs FOR SELECT
USING (
  org_id IN (
    SELECT org_id FROM users 
    WHERE auth_user_id = auth.uid()
  )
);

CREATE POLICY "Users can upload CVs to their organization"
ON cvs FOR INSERT
WITH CHECK (
  org_id IN (
    SELECT org_id FROM users 
    WHERE auth_user_id = auth.uid()
  )
);

CREATE POLICY "Users can update CVs they uploaded or admins can update any CV in their org"
ON cvs FOR UPDATE
USING (
  (uploaded_by IN (SELECT id FROM users WHERE auth_user_id = auth.uid()))
  OR 
  (org_id IN (
    SELECT org_id FROM users 
    WHERE auth_user_id = auth.uid() AND role = 'admin'
  ))
);

CREATE POLICY "Users can delete CVs they uploaded or admins can delete any CV in their org"
ON cvs FOR DELETE
USING (
  (uploaded_by IN (SELECT id FROM users WHERE auth_user_id = auth.uid()))
  OR 
  (org_id IN (
    SELECT org_id FROM users 
    WHERE auth_user_id = auth.uid() AND role = 'admin'
  ))
);

-- Candidate profiles policies
CREATE POLICY "Users can view candidate profiles in their organization"
ON candidate_profiles FOR SELECT
USING (
  org_id IN (
    SELECT org_id FROM users 
    WHERE auth_user_id = auth.uid()
  )
);

CREATE POLICY "Users can create candidate profiles in their organization"
ON candidate_profiles FOR INSERT
WITH CHECK (
  org_id IN (
    SELECT org_id FROM users 
    WHERE auth_user_id = auth.uid()
  )
);

CREATE POLICY "Users can update candidate profiles in their organization"
ON candidate_profiles FOR UPDATE
USING (
  org_id IN (
    SELECT org_id FROM users 
    WHERE auth_user_id = auth.uid()
  )
);

CREATE POLICY "Admins can delete candidate profiles in their organization"
ON candidate_profiles FOR DELETE
USING (
  org_id IN (
    SELECT org_id FROM users 
    WHERE auth_user_id = auth.uid() AND role = 'admin'
  )
);

-- Job candidate matches policies
CREATE POLICY "Users can view matches in their organization"
ON job_candidate_matches FOR SELECT
USING (
  org_id IN (
    SELECT org_id FROM users 
    WHERE auth_user_id = auth.uid()
  )
);

CREATE POLICY "Users can create matches in their organization"
ON job_candidate_matches FOR INSERT
WITH CHECK (
  org_id IN (
    SELECT org_id FROM users 
    WHERE auth_user_id = auth.uid()
  )
);

CREATE POLICY "Users can update matches in their organization"
ON job_candidate_matches FOR UPDATE
USING (
  org_id IN (
    SELECT org_id FROM users 
    WHERE auth_user_id = auth.uid()
  )
);

CREATE POLICY "Admins can delete matches in their organization"
ON job_candidate_matches FOR DELETE
USING (
  org_id IN (
    SELECT org_id FROM users 
    WHERE auth_user_id = auth.uid() AND role = 'admin'
  )
);