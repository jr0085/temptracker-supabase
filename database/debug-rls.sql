-- Debug RLS Issues
-- Run these queries as an authenticated user to diagnose the problem

-- 1. Check if auth.uid() is working
SELECT auth.uid() as current_user_id;

-- 2. Check user profile
SELECT * FROM user_profiles WHERE id = auth.uid();

-- 3. Check user store access
SELECT * FROM user_store_access WHERE user_id = auth.uid();

-- 4. Check what stores the user should have access to
SELECT 
    s.*,
    usa.access_level,
    usa.active as access_active
FROM stores s
LEFT JOIN user_store_access usa ON s.id = usa.store_id AND usa.user_id = auth.uid();

-- 5. Check equipment access (should show which equipment user can see)
SELECT 
    e.*,
    s.name as store_name,
    usa.access_level
FROM equipment e
JOIN stores s ON e.store_id = s.id
LEFT JOIN user_store_access usa ON s.id = usa.store_id AND usa.user_id = auth.uid()
WHERE usa.active = true;

-- 6. Test the exact policy condition that's failing
SELECT 
    equipment.id,
    equipment.name,
    equipment.store_id,
    auth.uid() as user_id,
    EXISTS (
        SELECT 1 FROM user_store_access usa 
        WHERE usa.store_id = equipment.store_id 
        AND usa.user_id = auth.uid() 
        AND usa.active = true
    ) as has_access
FROM equipment
LIMIT 5;

-- TEMPORARY FIX: If the above shows auth.uid() is null or user has no store access,
-- temporarily disable RLS on equipment table:
-- ALTER TABLE equipment DISABLE ROW LEVEL SECURITY;