# TempTracker Pro - Database Setup Instructions

## Supabase Account Setup

### 1. Create Supabase Account
1. Go to [supabase.com](https://supabase.com) and create a new account
2. Create a new project (choose a region close to your users)
3. Wait for project initialization to complete

### 2. Get Project Credentials
1. Go to Settings > API in your Supabase dashboard
2. Copy the following values:
   - **Project URL** (e.g., `https://abcdefghijklmnop.supabase.co`)
   - **Anon public key** (starts with `eyJhbGciOiJIUzI1NiIs...`)
   - **Service role key** (for admin operations - keep secure)

## Database Schema Setup

### 1. Run Schema Creation
1. In Supabase dashboard, go to **SQL Editor**
2. Create a new query
3. Copy and paste the contents of `database/updated-schema.sql`
4. Click **Run** to execute the schema

### 2. Enable Row Level Security (Optional)
1. After schema creation, run `database/enable-rls.sql`
2. This sets up security policies for multi-user access
3. Skip this step for development/testing environments

### 3. Verify Database Creation
After running the schema, you should see these tables in the **Table Editor**:
- `stores` - Restaurant locations
- `user_profiles` - User account information  
- `user_store_access` - User permissions for stores
- `equipment` - Temperature monitoring equipment
- `temperature_logs` - All temperature readings
- `global_permissions` - Admin permission settings

## Application Configuration

### 1. Update Supabase Credentials
Edit `working.html` and update these lines:

```javascript
// Initialize Supabase
const supabaseUrl = 'https://your-project.supabase.co';
const supabaseKey = 'your-anon-key-here';
const supabase = window.supabase.createClient(supabaseUrl, supabaseKey);
```

Replace with your actual Supabase project URL and anon key.

### 2. Test Connection
1. Open `working.html` in a web browser
2. Open browser developer tools (F12)
3. Look for console message: "🌡️ TempTracker Pro v1.10.50 loaded successfully!"
4. Try creating a user account to test database connectivity

### 3. Configure Storage (for Equipment Images)
1. In Supabase dashboard, go to **Storage**
2. Create a new bucket called `equipment-images`
3. Set bucket to **Private** for authenticated access only
4. Images will be automatically managed by the application

## Database Schema Details

### Core Tables

#### stores
- **Purpose**: Restaurant location information
- **Key Fields**: `id`, `name`, `address`, `phone`, `manager`
- **Usage**: Multi-location restaurant support

#### user_profiles  
- **Purpose**: User account information and preferences
- **Key Fields**: `id`, `email`, `full_name`, `default_store_id`
- **Usage**: Links Supabase auth users to application data

#### user_store_access
- **Purpose**: Multi-store user permissions
- **Key Fields**: `user_id`, `store_id`, `access_level`
- **Usage**: Controls which stores each user can access

#### equipment
- **Purpose**: Temperature monitoring equipment
- **Key Fields**: `id`, `store_id`, `name`, `type`, `target_temp_min`, `target_temp_max`
- **Usage**: Equipment management and temperature range validation

#### temperature_logs
- **Purpose**: All temperature readings with full audit trail
- **Key Fields**: `id`, `equipment_id`, `temperature`, `logged_at`, `logged_by_user_id`
- **Usage**: Temperature tracking and compliance reporting

#### global_permissions
- **Purpose**: System-wide admin permission settings
- **Key Fields**: `id`, `user_id`, `permission_name`, `enabled`
- **Usage**: Controls admin features like store management

### Sample Data

The schema includes sample data for testing:
- Multiple store locations (Main St, Downtown, Westside)
- Various equipment types (freezers, coolers, ovens, etc.)
- Temperature ranges appropriate for food safety
- Pre-configured equipment with proper temperature thresholds

## Authentication Setup

### Supabase Auth Configuration
1. In Supabase dashboard, go to **Authentication > Settings**
2. Configure email settings:
   - **Enable email confirmations** (recommended for production)
   - **Set up SMTP** for password reset emails (optional for development)
3. Configure password requirements as needed

### User Registration
- Users can sign up directly through the application
- First user should be designated as admin for system management
- All users are automatically assigned employee-level access initially

## Security Considerations

### Row Level Security (RLS)
- RLS policies ensure users only see data from their assigned stores
- Admin users can access all stores and user management features
- Policies are defined in `database/enable-rls.sql`
- **Note**: RLS is currently disabled for development - enable for production

### API Security
- **Anon key**: Safe to use in frontend code, has limited permissions
- **Service role key**: Keep secure, has full database access
- All database operations require user authentication

### Best Practices
- Enable email confirmation for production deployments
- Set up proper SMTP for password reset functionality
- Regularly backup your database through Supabase dashboard
- Monitor usage through Supabase analytics

## Troubleshooting

### Connection Issues
- Verify project URL and API key are correct
- Check browser console for specific error messages
- Ensure Supabase project is not paused

### Schema Issues
- Check SQL Editor for error messages
- Verify all tables were created successfully
- Run `database/debug-rls.sql` for RLS debugging

### Authentication Issues
- Check Authentication > Users in Supabase dashboard
- Verify email confirmation settings
- Review browser console for auth errors

## Production Deployment

### Before Going Live
1. Enable email confirmations in Supabase Auth settings
2. Set up proper SMTP configuration for emails
3. Review and enable RLS policies for security
4. Set up regular database backups
5. Configure appropriate user roles and permissions
6. Update Supabase project settings:
   - Set appropriate rate limits
   - Configure CORS if needed
   - Enable proper logging
7. Test all critical workflows:
   - User registration and login
   - Password reset flow
   - Temperature logging
   - Export functionality

### Monitoring
- Use Supabase dashboard to monitor:
  - Database usage and performance
  - Authentication events
  - API usage statistics
  - Error logs and debugging information

This setup provides a complete, secure, and scalable backend for TempTracker Pro with proper user management, multi-store support, and comprehensive temperature tracking capabilities.