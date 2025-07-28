# TempTracker Pro Supabase - Project Contents

## Current Project Structure

### Root Directory Files:
- **`working.html`** - Main application file (v1.10.50) - Complete PWA with embedded CSS/JavaScript
  - 4000+ lines of self-contained HTML/CSS/JavaScript
  - Includes all application logic, UI components, and Supabase integration
  - CDN dependencies: Tailwind CSS, Supabase JS, jsPDF, SheetJS
- **`CLAUDE.md`** - Development workflow rules and project context guidelines
  - Essential development conventions and patterns
  - Version management requirements
  - User preferences and project history
- **`DATABASE_SETUP.md`** - Supabase database setup and configuration instructions
  - Step-by-step Supabase project creation
  - Database schema deployment instructions
  - Application configuration steps
- **`README.md`** - Comprehensive project overview and feature documentation
  - Complete feature list with descriptions
  - Technology stack details
  - Quick setup guide
- **`PROJECT_CONTENTS.md`** - This file - project structure overview

### docs/ Directory:
- **`ARCHITECTURE_DECISION_RECORD.md`** - Single HTML vs Next.js architecture decision documentation
- **`CRITICAL_LEARNING.md`** - Important development lessons and z-index debugging patterns
- **`SESSION_CONTEXT_REVIEW.md`** - Context establishment session documentation
- **`SUPABASE_MIGRATION.md`** - Complete migration documentation from SharePoint to Supabase
- **`admin-permissions-plan.md`** - Admin permissions system implementation roadmap
- **`todo.md`** - Development task history and implementation progress tracking

### database/ Directory:
- **`debug-rls.sql`** - Row Level Security debugging utilities
- **`enable-rls.sql`** - Security policy definitions and RLS setup
- **`schema-fixed.sql`** - Fixed database schema with corrections
- **`schema.sql`** - Core database schema for Supabase setup
- **`updated-schema.sql`** - Latest schema updates and modifications

## Project Status

### Current Version: **v1.10.50**
- **Status**: Production-ready Supabase-based architecture
- **Migration**: ✅ Complete - Successfully migrated from SharePoint to Supabase
- **Architecture**: Single HTML file with embedded resources (per user preference)
- **Backend**: Supabase PostgreSQL with real-time capabilities

### Key Features Implemented:
- ✅ Complete authentication system with password recovery
  - Email/password login with secure token management
  - Password reset workflow with email verification
  - User profile management
- ✅ Multi-store management with user access control
  - Store selection dropdown with seamless switching
  - User-specific store permissions
  - Default store assignment during registration
- ✅ Full equipment lifecycle management with image support
  - CRUD operations for all equipment types
  - Drag-and-drop reordering
  - Image upload with cropping
  - Temperature range configuration
- ✅ Comprehensive temperature tracking and logging
  - Individual and bulk logging modes
  - Temperature validation with status indicators
  - Edit/delete capabilities with confirmations
  - Full audit trail with user tracking
- ✅ PDF and Excel export functionality
  - Formatted PDF reports with statistics
  - Excel exports with multiple data sheets
  - Date range filtering for reports
- ✅ Real-time cross-device synchronization
  - Supabase real-time subscriptions
  - Instant updates across devices
  - Visual notifications for sync events
- ✅ PWA features with offline support
  - Local storage fallback
  - Mobile-optimized responsive design
  - Touch-friendly interface
- ✅ Admin permissions and user management
  - Global permissions system
  - Admin settings panel
  - Role-based access control
- ✅ Professional UI with glassmorphism design
  - Modern backdrop blur effects
  - Dark mode with persistent preference
  - Consistent color scheme and typography
  - Emoji indicators for visual communication

## Technology Stack

### Frontend Architecture:
- **Single HTML File**: `working.html` contains complete application
- **Styling**: Tailwind CSS (v3.x via CDN) with custom glassmorphism effects
  - Dark mode support with CSS variables
  - Responsive grid layouts
  - Custom animations and transitions
- **JavaScript**: Modern ES6+ with async/await patterns
  - Global function pattern for event handlers
  - Comprehensive error handling
  - Real-time data synchronization
- **PWA**: Progressive Web App capabilities
  - Offline support with local storage
  - Mobile-optimized interface
  - App installation prompts

### Backend Infrastructure:
- **Database**: Supabase PostgreSQL with Row Level Security (currently disabled)
- **Authentication**: Supabase Auth with email/password
  - Password reset via email links
  - Persistent sessions
  - Multi-device support
- **Real-time**: Supabase subscriptions for live updates
  - Cross-device synchronization
  - Instant UI updates
- **Storage**: Supabase storage for equipment images
  - Authenticated access
  - Image caching for performance

### External Libraries (via CDN):
- **Supabase JS** (v2.39.3) - Database and auth client
- **jsPDF** (v2.5.1) - PDF generation
- **jsPDF-AutoTable** (v3.5.31) - PDF table formatting
- **SheetJS/xlsx** (v0.18.5) - Excel file generation

### Deployment:
- **Static Hosting Compatible**: No server-side requirements
- **Current Setup**: Local development environment
- **Production Ready**: Can deploy to any static web hosting service
- **Environment**: Requires Supabase project URL and anon key

## File Dependencies

### Core Application:
- `working.html` is completely self-contained
- No external dependencies beyond Supabase CDN
- Embedded CSS and JavaScript for portability

### Database Setup:
- Run SQL files in `database/` folder in order:
  1. `schema.sql` or `updated-schema.sql` (latest)
  2. `enable-rls.sql` for security policies
  3. `debug-rls.sql` if troubleshooting needed

### Documentation:
- All `.md` files provide context and setup instructions
- `CLAUDE.md` contains critical development workflow rules
- `docs/` folder contains detailed implementation history

## Git Repository Status

The project is initialized as a Git repository:
- **Current Branch**: main
- **Main Branch**: main (for PRs)
- **Recent Commit**: Initial commit - TempTracker Pro Supabase v1.10.50
- **Modified Files**: Documentation updates in progress
- **Untracked Files**: .claude/ directory (local Claude workspace)

## Development Environment

### Prerequisites:
- Modern web browser with JavaScript enabled
- Supabase account and project setup
- Local web server for development (optional but recommended)

### Getting Started:
1. Set up Supabase database using `DATABASE_SETUP.md`
   - Create Supabase project
   - Run SQL scripts from `database/` folder
   - Copy project URL and API keys
2. Update Supabase credentials in `working.html`
   ```javascript
   const supabaseUrl = 'https://your-project.supabase.co';
   const supabaseKey = 'your-anon-key-here';
   ```
3. Open `working.html` in browser (preferably with live server)
4. Follow development guidelines in `CLAUDE.md`
5. Create initial admin user and configure store access

## Project Workflow

### Development Process:
1. **Plan**: Write tasks to `docs/todo.md` before implementation
2. **Approve**: Get user approval for significant changes
3. **Implement**: Make minimal, incremental changes
4. **Version**: Update version numbers in all locations
5. **Review**: Document changes and add summary to todo.md

### Key Principles:
- **Authentication Stability**: Never break working login system
- **Single File Architecture**: Maintain user-preferred structure
- **Simple Changes**: Prefer minimal modifications over complex refactoring
- **Professional Quality**: Modern UI with comprehensive error handling

## Support Documentation

- **Setup Guide**: `DATABASE_SETUP.md`
- **Development Rules**: `CLAUDE.md`
- **Migration History**: `SUPABASE_MIGRATION.md`
- **Architecture Decisions**: `ARCHITECTURE_DECISION_RECORD.md`
- **Learning Notes**: `CRITICAL_LEARNING.md`
- **Task History**: `docs/todo.md`

## Recent Updates (v1.10.50)

### Latest Session Accomplishments:
- Standardized edit/delete icons in Log Details Actions (replaced emoji with SVG icons)
- Horizontally aligned Export PDF and Export Excel buttons with refresh button
- Moved Refresh button back to right of To Date field while maintaining alignment
- Created comprehensive profile settings implementation plan
- Fixed Claude Code hook configuration issue (auto-commit.bat execution)

## Previous Updates (v1.10.5)

### Completed Features:
- Export functionality with PDF and Excel generation
- Dark mode support with user preference persistence
- Admin settings panel for permission management
- Z-index fixes for dropdown menus
- Enhanced error handling and user notifications
- Comprehensive documentation updates

### Architecture Decision:
- Confirmed single HTML file approach over Next.js migration
- Documented in `ARCHITECTURE_DECISION_RECORD.md`
- Maintains user's preference for simplicity and portability

This project represents a complete, production-ready temperature monitoring solution with modern architecture and professional quality suitable for restaurant food safety compliance.