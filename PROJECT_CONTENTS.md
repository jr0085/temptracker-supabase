# TempTracker Supabase Clean Project Contents

## Root Directory Files:
- `working.html` - Main application (v1.9.1)
- `CLAUDE.md` - Development rules and project context
- `DATABASE_SETUP.md` - Database setup instructions
- `README.md` - Project overview
- `.gitignore` - Git ignore configuration

## docs/ Directory:
- `CRITICAL_LEARNING.md` - Important project learnings and patterns
- `SUPABASE_MIGRATION.md` - Migration from SharePoint to Supabase
- `admin-permissions-plan.md` - Admin permissions system documentation
- `todo.md` - Task tracking and implementation notes

## database/ Directory:
- SQL files for Supabase database setup
- Schema definitions
- RLS (Row Level Security) policies

## To sync with GitHub:

1. Navigate to this directory:
   ```
   cd C:\Developer\TempTracker-Supabase-Clean
   ```

2. Initialize git and commit:
   ```
   git init
   git add .
   git commit -m "Initial commit - TempTracker Pro Supabase v1.9.1"
   ```

3. Create GitHub repository and push:
   ```
   git remote add origin https://github.com/YOUR_USERNAME/temptracker-supabase.git
   git branch -M main
   git push -u origin main
   ```