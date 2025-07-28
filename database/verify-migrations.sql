-- Database Verification Queries
-- Run these in Supabase SQL Editor to check current state

-- 1. Check if new columns exist in user_profiles table
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'user_profiles' 
  AND column_name IN ('profile_picture_url', 'email_notifications', 'preferred_language', 'dark_mode_preference')
ORDER BY column_name;

-- 2. Check if profile picture index exists
SELECT indexname, indexdef 
FROM pg_indexes 
WHERE tablename = 'user_profiles' 
  AND indexname = 'idx_user_profiles_picture_url';

-- 3. Check if profile-pictures storage bucket exists
SELECT id, name, public, file_size_limit, allowed_mime_types
FROM storage.buckets 
WHERE id = 'profile-pictures';

-- 4. Check storage policies for profile-pictures bucket
SELECT policyname, cmd, qual, with_check 
FROM pg_policies 
WHERE schemaname = 'storage' 
  AND tablename = 'objects' 
  AND policyname LIKE '%profile pictures%';

-- 5. Show current user_profiles table structure
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'user_profiles'
ORDER BY ordinal_position;