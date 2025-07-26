-- TempTracker Pro - Updated Database Schema with Proper RLS
-- Version: 1.6.7+
-- Updated: Based on current application requirements

-- Enable Row Level Security and required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Stores table (core locations)
CREATE TABLE IF NOT EXISTS stores (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    phone VARCHAR(20),
    manager VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    active BOOLEAN DEFAULT true
);

-- User profiles table (replaces employees - matches current app)
CREATE TABLE IF NOT EXISTS user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email VARCHAR(255) NOT NULL UNIQUE,
    full_name VARCHAR(255) NOT NULL,
    default_store_id UUID REFERENCES stores(id) ON DELETE SET NULL,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- User store access table (many-to-many relationship)
CREATE TABLE IF NOT EXISTS user_store_access (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    store_id UUID REFERENCES stores(id) ON DELETE CASCADE,
    access_level VARCHAR(50) NOT NULL DEFAULT 'employee', -- 'admin', 'manager', 'employee'
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    UNIQUE(user_id, store_id)
);

-- Equipment table (temperature monitoring devices)
CREATE TABLE IF NOT EXISTS equipment (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    store_id UUID REFERENCES stores(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(100) NOT NULL, -- 'freezer', 'cooler', 'oven', etc.
    location VARCHAR(255),
    target_temp_min DECIMAL(5,2),
    target_temp_max DECIMAL(5,2),
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Temperature logs table (actual temperature readings)
CREATE TABLE IF NOT EXISTS temperature_logs (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    equipment_id UUID REFERENCES equipment(id) ON DELETE CASCADE,
    store_id UUID REFERENCES stores(id) ON DELETE CASCADE,
    temperature DECIMAL(5,2) NOT NULL,
    logged_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    logged_by_user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_user_profiles_email ON user_profiles(email);
CREATE INDEX IF NOT EXISTS idx_user_store_access_user_id ON user_store_access(user_id);
CREATE INDEX IF NOT EXISTS idx_user_store_access_store_id ON user_store_access(store_id);
CREATE INDEX IF NOT EXISTS idx_equipment_store_id ON equipment(store_id);
CREATE INDEX IF NOT EXISTS idx_temperature_logs_equipment_id ON temperature_logs(equipment_id);
CREATE INDEX IF NOT EXISTS idx_temperature_logs_store_id ON temperature_logs(store_id);
CREATE INDEX IF NOT EXISTS idx_temperature_logs_logged_at ON temperature_logs(logged_at);
CREATE INDEX IF NOT EXISTS idx_temperature_logs_user_id ON temperature_logs(logged_by_user_id);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers to auto-update updated_at
DROP TRIGGER IF EXISTS update_stores_updated_at ON stores;
CREATE TRIGGER update_stores_updated_at BEFORE UPDATE ON stores
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_user_profiles_updated_at ON user_profiles;
CREATE TRIGGER update_user_profiles_updated_at BEFORE UPDATE ON user_profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_equipment_updated_at ON equipment;
CREATE TRIGGER update_equipment_updated_at BEFORE UPDATE ON equipment
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to create user profile automatically after signup
CREATE OR REPLACE FUNCTION create_user_profile()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO user_profiles (
        id, 
        email, 
        full_name,
        active
    ) VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'full_name', 'User'),
        true
    );
    RETURN NEW;
END;
$$ language 'plpgsql' SECURITY DEFINER;

-- Create trigger to auto-create profile when user signs up
DROP TRIGGER IF EXISTS create_user_profile_trigger ON auth.users;
CREATE TRIGGER create_user_profile_trigger
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION create_user_profile();

-- DISABLE RLS temporarily while we test (will re-enable with proper policies)
ALTER TABLE stores DISABLE ROW LEVEL SECURITY;
ALTER TABLE user_profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE user_store_access DISABLE ROW LEVEL SECURITY;
ALTER TABLE equipment DISABLE ROW LEVEL SECURITY;
ALTER TABLE temperature_logs DISABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Allow all operations on stores" ON stores;
DROP POLICY IF EXISTS "Allow all operations on user_profiles" ON user_profiles;
DROP POLICY IF EXISTS "Allow all operations on user_store_access" ON user_store_access;
DROP POLICY IF EXISTS "Allow all operations on equipment" ON equipment;
DROP POLICY IF EXISTS "Allow all operations on temperature_logs" ON temperature_logs;

-- PROPER RLS POLICIES (commented out until we test basic functionality)
/*
-- Enable Row Level Security
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_store_access ENABLE ROW LEVEL SECURITY;
ALTER TABLE equipment ENABLE ROW LEVEL SECURITY;
ALTER TABLE temperature_logs ENABLE ROW LEVEL SECURITY;

-- Stores: Users can only see stores they have access to
CREATE POLICY "Users can view accessible stores" ON stores FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM user_store_access usa 
            WHERE usa.store_id = stores.id 
            AND usa.user_id = auth.uid() 
            AND usa.active = true
        )
    );

-- User profiles: Users can only see and edit their own profile
CREATE POLICY "Users can view own profile" ON user_profiles FOR SELECT
    USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON user_profiles FOR UPDATE
    USING (auth.uid() = id);

-- User store access: Users can view their own access, admins can view all
CREATE POLICY "Users can view own store access" ON user_store_access FOR SELECT
    USING (user_id = auth.uid());

-- Equipment: Users can see equipment for stores they have access to
CREATE POLICY "Users can view accessible equipment" ON equipment FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM user_store_access usa 
            WHERE usa.store_id = equipment.store_id 
            AND usa.user_id = auth.uid() 
            AND usa.active = true
        )
    );

CREATE POLICY "Users can modify accessible equipment" ON equipment FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM user_store_access usa 
            WHERE usa.store_id = equipment.store_id 
            AND usa.user_id = auth.uid() 
            AND usa.active = true
        )
    );

-- Temperature logs: Users can see logs for stores they have access to
CREATE POLICY "Users can view accessible temperature logs" ON temperature_logs FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM user_store_access usa 
            WHERE usa.store_id = temperature_logs.store_id 
            AND usa.user_id = auth.uid() 
            AND usa.active = true
        )
    );

CREATE POLICY "Users can create temperature logs for accessible stores" ON temperature_logs FOR INSERT
    WITH CHECK (
        logged_by_user_id = auth.uid() AND
        EXISTS (
            SELECT 1 FROM user_store_access usa 
            WHERE usa.store_id = temperature_logs.store_id 
            AND usa.user_id = auth.uid() 
            AND usa.active = true
        )
    );
*/

-- Sample data (same as before)
INSERT INTO stores (name, address, phone, manager) VALUES
('Cristy''s Pizza - Main Street', '123 Main Street, Anytown, ST 12345', '(555) 123-4567', 'John Smith'),
('Cristy''s Pizza - Oak Avenue', '456 Oak Avenue, Somewhere, ST 12346', '(555) 234-5678', 'Jane Doe'),
('Cristy''s Pizza - Pine Road', '789 Pine Road, Elsewhere, ST 12347', '(555) 345-6789', 'Bob Johnson'),
('Cristy''s Pizza - Elm Street', '321 Elm Street, Anyplace, ST 12348', '(555) 456-7890', 'Sarah Wilson'),
('Cristy''s Pizza - Cedar Lane', '654 Cedar Lane, Nowhere, ST 12349', '(555) 567-8901', 'Mike Davis'),
('Cristy''s Pizza - Maple Drive', '987 Maple Drive, Anywhere, ST 12350', '(555) 678-9012', 'Lisa Brown'),
('Cristy''s Pizza - Birch Court', '147 Birch Court, Somewhere Else, ST 12351', '(555) 789-0123', 'Tom Garcia')
ON CONFLICT DO NOTHING;

-- Sample equipment for Main Street store
INSERT INTO equipment (store_id, name, type, location, target_temp_min, target_temp_max) 
SELECT 
    s.id,
    equipment_name,
    equipment_type,
    equipment_location,
    min_temp,
    max_temp
FROM stores s,
(VALUES 
    ('Walk-in Freezer', 'freezer', 'Back Kitchen', -10.0, 0.0),
    ('Walk-in Cooler', 'cooler', 'Back Kitchen', 35.0, 40.0),
    ('Pizza Prep Cooler', 'cooler', 'Prep Area', 35.0, 40.0),
    ('Salad Bar', 'cooler', 'Front Counter', 35.0, 40.0)
) AS sample_equipment(equipment_name, equipment_type, equipment_location, min_temp, max_temp)
WHERE s.name = 'Cristy''s Pizza - Main Street'
ON CONFLICT DO NOTHING;