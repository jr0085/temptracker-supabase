-- TempTracker Pro - Enable Row Level Security with Proper Policies
-- Version: 1.6.8+
-- This script enables RLS with timing-aware policies

-- First, ensure all tables have RLS enabled
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_store_access ENABLE ROW LEVEL SECURITY;
ALTER TABLE equipment ENABLE ROW LEVEL SECURITY;
ALTER TABLE temperature_logs ENABLE ROW LEVEL SECURITY;

-- Drop any existing policies to start fresh
DROP POLICY IF EXISTS "Allow all operations on stores" ON stores;
DROP POLICY IF EXISTS "Allow all operations on user_profiles" ON user_profiles;
DROP POLICY IF EXISTS "Allow all operations on user_store_access" ON user_store_access;
DROP POLICY IF EXISTS "Allow all operations on equipment" ON equipment;
DROP POLICY IF EXISTS "Allow all operations on temperature_logs" ON temperature_logs;

-- =============================================================================
-- STORES POLICIES
-- =============================================================================

-- Users can view stores they have access to
CREATE POLICY "Users can view accessible stores" 
ON stores FOR SELECT 
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM user_store_access usa 
        WHERE usa.store_id = stores.id 
        AND usa.user_id = auth.uid() 
        AND usa.active = true
    )
);

-- =============================================================================
-- USER_PROFILES POLICIES  
-- =============================================================================

-- Users can view their own profile
CREATE POLICY "Users can view own profile" 
ON user_profiles FOR SELECT 
TO authenticated
USING (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "Users can update own profile" 
ON user_profiles FOR UPDATE 
TO authenticated
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- Allow system/trigger to insert profiles (SECURITY DEFINER function)
CREATE POLICY "System can insert user profiles" 
ON user_profiles FOR INSERT 
TO authenticated
WITH CHECK (auth.uid() = id);

-- =============================================================================
-- USER_STORE_ACCESS POLICIES
-- =============================================================================

-- Users can view their own store access records
CREATE POLICY "Users can view own store access" 
ON user_store_access FOR SELECT 
TO authenticated
USING (user_id = auth.uid());

-- Users can insert their own store access (during signup)
CREATE POLICY "Users can create own store access" 
ON user_store_access FOR INSERT 
TO authenticated
WITH CHECK (user_id = auth.uid());

-- Users can update their own store access (for preference changes)
CREATE POLICY "Users can update own store access" 
ON user_store_access FOR UPDATE 
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- =============================================================================
-- EQUIPMENT POLICIES
-- =============================================================================

-- Users can view equipment for stores they have access to
CREATE POLICY "Users can view accessible equipment" 
ON equipment FOR SELECT 
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM user_store_access usa 
        WHERE usa.store_id = equipment.store_id 
        AND usa.user_id = auth.uid() 
        AND usa.active = true
    )
);

-- Users can modify equipment for stores they have access to
CREATE POLICY "Users can modify accessible equipment" 
ON equipment FOR ALL 
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM user_store_access usa 
        WHERE usa.store_id = equipment.store_id 
        AND usa.user_id = auth.uid() 
        AND usa.active = true
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1 FROM user_store_access usa 
        WHERE usa.store_id = equipment.store_id 
        AND usa.user_id = auth.uid() 
        AND usa.active = true
    )
);

-- =============================================================================
-- TEMPERATURE_LOGS POLICIES
-- =============================================================================

-- Users can view temperature logs for stores they have access to
CREATE POLICY "Users can view accessible temperature logs" 
ON temperature_logs FOR SELECT 
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM user_store_access usa 
        WHERE usa.store_id = temperature_logs.store_id 
        AND usa.user_id = auth.uid() 
        AND usa.active = true
    )
);

-- Users can create temperature logs for accessible stores (must be logged by them)
CREATE POLICY "Users can create temperature logs for accessible stores" 
ON temperature_logs FOR INSERT 
TO authenticated
WITH CHECK (
    logged_by_user_id = auth.uid() AND
    EXISTS (
        SELECT 1 FROM user_store_access usa 
        WHERE usa.store_id = temperature_logs.store_id 
        AND usa.user_id = auth.uid() 
        AND usa.active = true
    )
);

-- Users can update temperature logs they created (for corrections)
CREATE POLICY "Users can update own temperature logs" 
ON temperature_logs FOR UPDATE 
TO authenticated
USING (
    logged_by_user_id = auth.uid() AND
    EXISTS (
        SELECT 1 FROM user_store_access usa 
        WHERE usa.store_id = temperature_logs.store_id 
        AND usa.user_id = auth.uid() 
        AND usa.active = true
    )
)
WITH CHECK (
    logged_by_user_id = auth.uid() AND
    EXISTS (
        SELECT 1 FROM user_store_access usa 
        WHERE usa.store_id = temperature_logs.store_id 
        AND usa.user_id = auth.uid() 
        AND usa.active = true
    )
);

-- Users can delete temperature logs they created (for error corrections)
CREATE POLICY "Users can delete own temperature logs" 
ON temperature_logs FOR DELETE 
TO authenticated
USING (
    logged_by_user_id = auth.uid() AND
    EXISTS (
        SELECT 1 FROM user_store_access usa 
        WHERE usa.store_id = temperature_logs.store_id 
        AND usa.user_id = auth.uid() 
        AND usa.active = true
    )
);

-- =============================================================================
-- VERIFICATION QUERIES
-- =============================================================================

-- Run these queries to verify RLS is working correctly:

/* 
-- Test queries (run as authenticated user):

-- Should show only stores user has access to
SELECT * FROM stores;

-- Should show only user's own profile
SELECT * FROM user_profiles;

-- Should show only user's store access records  
SELECT * FROM user_store_access;

-- Should show only equipment from accessible stores
SELECT * FROM equipment;

-- Should show only temperature logs from accessible stores
SELECT * FROM temperature_logs;
*/