-- Initialize required extensions
-- gen_random_uuid() is built-in to PostgreSQL 13+, no extension needed
-- Only keep pgcrypto if you need specific crypto functions
create extension if not exists "pgcrypto";
