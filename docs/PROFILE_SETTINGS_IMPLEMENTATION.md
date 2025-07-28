# Profile Settings Implementation Guide

## Overview
This guide covers the complete implementation of the profile settings feature for TempTracker Pro, including database setup, UI components, and functionality.

## Database Setup

### 1. Run Profile Settings Migration
Execute the database migration to add new profile fields:

```sql
-- Run this in your Supabase SQL editor
-- File: database/profile-settings-migration.sql

-- Add profile picture URL
ALTER TABLE user_profiles ADD COLUMN IF NOT EXISTS profile_picture_url TEXT;

-- Add email notifications preference
ALTER TABLE user_profiles ADD COLUMN IF NOT EXISTS email_notifications BOOLEAN DEFAULT true;

-- Add preferred language
ALTER TABLE user_profiles ADD COLUMN IF NOT EXISTS preferred_language VARCHAR(5) DEFAULT 'en';

-- Add dark mode preference
ALTER TABLE user_profiles ADD COLUMN IF NOT EXISTS dark_mode_preference VARCHAR(10) DEFAULT 'system';

-- Create index for profile picture URL lookups
CREATE INDEX IF NOT EXISTS idx_user_profiles_picture_url ON user_profiles(profile_picture_url) WHERE profile_picture_url IS NOT NULL;
```

### 2. Setup Supabase Storage
Create the storage bucket for profile pictures:

```sql
-- Run this in your Supabase SQL editor
-- File: database/setup-storage.sql

-- Create storage bucket for profile pictures
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'profile-pictures',
    'profile-pictures',
    true,
    5242880, -- 5MB limit
    ARRAY['image/jpeg', 'image/png', 'image/gif', 'image/webp']
) ON CONFLICT (id) DO NOTHING;

-- Create storage policies (see setup-storage.sql for complete policies)
```

## Features Implemented

### 1. Personal Information
- **Display Name**: Editable full name field
- **Email**: Read-only display (managed via Supabase Auth)
- **Profile Picture**: Upload with preview and initials fallback
- **Initials**: Auto-generated from display name for avatar

### 2. Application Preferences
- **Dark Mode**: Three options (system, light, dark) with immediate application
- **Default Store**: Dropdown selection from user's accessible stores
- **Email Notifications**: Toggle for critical temperature alerts
- **Language**: Future internationalization support (enabled in database)

### 3. Security Settings
- **Password Reset**: Integration with Supabase Auth password reset
- **Active Sessions**: Placeholder for future session management

### 4. Store Access Management
- **Current Store Access**: Display list of stores user can access
- **Store Roles**: Show permissions for each store
- **Request Access**: Placeholder for future access request workflow

## UI Components

### Modal Structure
- **Header**: Title with close button
- **Profile Picture Section**: Avatar with upload button
- **Tab Navigation**: Four tabs (Personal Info, Preferences, Security, Store Access)
- **Tab Content**: Form fields and information displays
- **Action Buttons**: Cancel and Save buttons

### Tabbed Interface
1. **Personal Info Tab**: Name and email fields
2. **Preferences Tab**: Dark mode, default store, notifications
3. **Security Tab**: Password reset and session management
4. **Store Access Tab**: Current access and request forms

## JavaScript Functions

### Core Functions
- `showProfile()`: Opens the profile settings modal
- `closeProfileModal()`: Closes the modal
- `loadProfileData()`: Loads user data into form fields
- `saveProfileSettings()`: Saves changes to database
- `switchProfileTab()`: Handles tab navigation

### Profile Picture Functions
- `handleProfilePictureUpload()`: Uploads image to Supabase storage
- `updateProfileAvatar()`: Updates avatar display
- `getInitials()`: Generates initials from name

### Utility Functions
- `applyDarkModePreference()`: Applies dark mode setting
- `resetPassword()`: Initiates password reset
- `loadProfileStoreAccess()`: Loads user's store access

## User Experience Features

### Auto-Save vs Manual Save
- **Manual Save**: Users must click "Save Changes" to persist changes
- **Validation**: Required field validation before saving
- **Feedback**: Success/error notifications for all actions

### Dark Mode Integration
- **Immediate Application**: Dark mode changes apply instantly
- **Persistent Storage**: Preferences saved to database and localStorage
- **System Preference**: Respects user's system preference when set to "system"

### Profile Picture Management
- **File Validation**: Type and size validation (5MB limit)
- **Preview**: Immediate visual feedback
- **Fallback**: Initials display when no picture is uploaded
- **Storage**: Secure upload to Supabase storage with user-specific folders

## Database Schema

### Updated user_profiles Table
```sql
CREATE TABLE user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email VARCHAR(255) NOT NULL UNIQUE,
    full_name VARCHAR(255) NOT NULL,
    default_store_id UUID REFERENCES stores(id) ON DELETE SET NULL,
    profile_picture_url TEXT,
    email_notifications BOOLEAN DEFAULT true,
    preferred_language VARCHAR(5) DEFAULT 'en',
    dark_mode_preference VARCHAR(10) DEFAULT 'system',
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);
```

## Security Considerations

### Row Level Security
- Users can only view and update their own profile
- Profile picture uploads restricted to user's own folder
- Public read access to profile pictures for display

### Data Validation
- File type and size validation for uploads
- Required field validation
- SQL injection prevention through Supabase client

## Future Enhancements

### Phase 2 Features
- Session management and device tracking
- Store access request workflow
- Bulk notification settings
- Custom temperature alert thresholds

### Phase 3 Features
- Two-factor authentication
- Account deletion workflow
- Data export functionality
- Advanced privacy settings

## Testing Checklist

### Database Setup
- [ ] Profile settings migration executed
- [ ] Storage bucket created
- [ ] Storage policies configured
- [ ] RLS policies working correctly

### UI Functionality
- [ ] Modal opens and closes properly
- [ ] Tab navigation works
- [ ] Form fields populate correctly
- [ ] Validation works as expected
- [ ] Save functionality works
- [ ] Dark mode applies immediately

### Profile Picture
- [ ] Upload functionality works
- [ ] File validation works
- [ ] Preview displays correctly
- [ ] Initials fallback works
- [ ] Storage permissions work

### Integration
- [ ] Profile loads on login
- [ ] Dark mode preference persists
- [ ] Default store selection works
- [ ] Password reset sends email
- [ ] Store access displays correctly

## Troubleshooting

### Common Issues
1. **Storage Upload Fails**: Check storage bucket exists and policies are correct
2. **Dark Mode Not Working**: Verify localStorage and database preferences
3. **Profile Not Loading**: Check RLS policies and user authentication
4. **Form Validation Errors**: Ensure all required fields are filled

### Debug Functions
- Use browser console to check for errors
- Verify Supabase connection and authentication
- Check network tab for failed requests
- Use `debugAuth()` function for detailed user info 