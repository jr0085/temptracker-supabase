-- Profile Settings Migration
-- Add new columns to user_profiles table for enhanced profile management

-- Add profile picture URL
ALTER TABLE user_profiles ADD COLUMN IF NOT EXISTS profile_picture_url TEXT;

-- Add email notifications preference
ALTER TABLE user_profiles ADD COLUMN IF NOT EXISTS email_notifications BOOLEAN DEFAULT true;

-- Add preferred language
ALTER TABLE user_profiles ADD COLUMN IF NOT EXISTS preferred_language VARCHAR(5) DEFAULT 'en';

-- Add dark mode preference
ALTER TABLE user_profiles ADD COLUMN IF NOT EXISTS dark_mode_preference VARCHAR(10) DEFAULT 'system'; -- 'light', 'dark', 'system'

-- Create index for profile picture URL lookups
CREATE INDEX IF NOT EXISTS idx_user_profiles_picture_url ON user_profiles(profile_picture_url) WHERE profile_picture_url IS NOT NULL; 