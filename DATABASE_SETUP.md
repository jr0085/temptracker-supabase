# Database Setup Instructions

## Supabase Setup

1. Go to [supabase.com](https://supabase.com) and create a new account
2. Create a new project
3. Copy your project URL and anon key from Settings > API

## Environment Variables

1. Copy `.env.local.example` to `.env.local`
2. Fill in your Supabase credentials:
   ```
   NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
   NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key_here
   ```

## Database Schema

1. Go to your Supabase dashboard
2. Click on "SQL Editor" in the sidebar
3. Copy and paste the contents of `database/schema.sql`
4. Click "Run" to execute the schema

## Verify Setup

After running the schema, you should see:
- 4 tables: `stores`, `employees`, `equipment`, `temperature_logs`
- 7 sample stores already populated
- All tables have Row Level Security enabled
- Indexes and triggers are set up for performance

## Table Structure

### stores (generic - used by all Cristy's Pizza apps)
- Stores location information
- Sample data includes all 7 Cristy's Pizza locations

### employees (generic - used by all Cristy's Pizza apps)
- Employee information linked to stores
- Roles: manager, shift_leader, employee, admin

### equipment (TempTracker specific)
- Restaurant equipment that needs temperature monitoring
- Types: freezer, cooler, oven, prep_cooler, walk_in, etc.
- Min/max temperature ranges for compliance

### temperature_logs (TempTracker specific)
- Individual temperature readings
- Links equipment + employee + timestamp
- Optional notes field for additional context