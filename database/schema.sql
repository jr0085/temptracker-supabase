-- Enable Row Level Security
ALTER DATABASE postgres SET "app.jwt_secret" TO 'your-jwt-secret';

-- Stores table (generic for all Cristy's Pizza apps)
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

-- Employees table (generic for all Cristy's Pizza apps)
CREATE TABLE IF NOT EXISTS employees (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    store_id UUID REFERENCES stores(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    role VARCHAR(100) NOT NULL DEFAULT 'employee',
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Equipment table (TempTracker specific)
CREATE TABLE IF NOT EXISTS equipment (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    store_id UUID REFERENCES stores(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(100) NOT NULL, -- 'freezer', 'cooler', 'oven', etc.
    min_temp DECIMAL(5,2) NOT NULL,
    max_temp DECIMAL(5,2) NOT NULL,
    location VARCHAR(255),
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Temperature logs table (TempTracker specific)
CREATE TABLE IF NOT EXISTS temperature_logs (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    equipment_id UUID REFERENCES equipment(id) ON DELETE CASCADE,
    employee_id UUID REFERENCES employees(id) ON DELETE CASCADE,
    temperature DECIMAL(5,2) NOT NULL,
    logged_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_employees_store_id ON employees(store_id);
CREATE INDEX IF NOT EXISTS idx_equipment_store_id ON equipment(store_id);
CREATE INDEX IF NOT EXISTS idx_temperature_logs_equipment_id ON temperature_logs(equipment_id);
CREATE INDEX IF NOT EXISTS idx_temperature_logs_employee_id ON temperature_logs(employee_id);
CREATE INDEX IF NOT EXISTS idx_temperature_logs_logged_at ON temperature_logs(logged_at);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers to auto-update updated_at
CREATE TRIGGER update_stores_updated_at BEFORE UPDATE ON stores
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_employees_updated_at BEFORE UPDATE ON employees
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_equipment_updated_at BEFORE UPDATE ON equipment
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Enable Row Level Security
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE equipment ENABLE ROW LEVEL SECURITY;
ALTER TABLE temperature_logs ENABLE ROW LEVEL SECURITY;

-- Create policies (allowing all operations for now, can be restricted later)
CREATE POLICY "Allow all operations on stores" ON stores FOR ALL USING (true);
CREATE POLICY "Allow all operations on employees" ON employees FOR ALL USING (true);
CREATE POLICY "Allow all operations on equipment" ON equipment FOR ALL USING (true);
CREATE POLICY "Allow all operations on temperature_logs" ON temperature_logs FOR ALL USING (true);

-- Insert sample data
INSERT INTO stores (name, address, phone, manager) VALUES
('Cristy''s Pizza - Main Street', '123 Main Street, Anytown, ST 12345', '(555) 123-4567', 'John Smith'),
('Cristy''s Pizza - Oak Avenue', '456 Oak Avenue, Somewhere, ST 12346', '(555) 234-5678', 'Jane Doe'),
('Cristy''s Pizza - Pine Road', '789 Pine Road, Elsewhere, ST 12347', '(555) 345-6789', 'Bob Johnson'),
('Cristy''s Pizza - Elm Street', '321 Elm Street, Anyplace, ST 12348', '(555) 456-7890', 'Sarah Wilson'),
('Cristy''s Pizza - Cedar Lane', '654 Cedar Lane, Nowhere, ST 12349', '(555) 567-8901', 'Mike Davis'),
('Cristy''s Pizza - Maple Drive', '987 Maple Drive, Anywhere, ST 12350', '(555) 678-9012', 'Lisa Brown'),
('Cristy''s Pizza - Birch Court', '147 Birch Court, Somewhere Else, ST 12351', '(555) 789-0123', 'Tom Garcia')
ON CONFLICT DO NOTHING;