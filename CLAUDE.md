# TempTracker Pro - Claude Code Project Context

## Development Workflow Rules

**ALWAYS follow these rules when working on this project:**

1. First think through the problem, read the codebase for relevant files, and write a plan to tasks/todo.md.
2. The plan should have a list of todo items that you can check off as you complete them
3. Before you begin working, check in with me and I will verify the plan.
4. Then, begin working on the todo items, marking them as complete as you go.
5. Please every step of the way just give me a high level explanation of what changes you made
6. Make every task and code change you do as simple as possible. We want to avoid making any massive or complex changes. Every change should impact as little code as possible. Everything is about simplicity.
7. Finally, add a review section to the [todo.md] file with a summary of the changes you made and any other relevant information.


## Essential Reference Documents

**READ these files before making any significant changes:**

- **`DATABASE_SETUP.md`** - Supabase database setup and configuration instructions
- **`SUPABASE_MIGRATION.md`** - Complete migration documentation from SharePoint to Supabase
- **`ARCHITECTURE_DECISION_RECORD.md`** - Architectural decisions and rationale
- **`CRITICAL_LEARNING.md`** - Important development lessons and debugging patterns
- **`admin-permissions-plan.md`** - Admin system implementation roadmap
- **`docs/todo.md`** - Task history and development progress tracking
- **`docs/SESSION_CONTEXT_REVIEW.md`** - Context establishment and architecture decisions

## Project Overview

TempTracker Pro is a Progressive Web Application (PWA) for restaurant temperature monitoring with Supabase backend integration. The main application file is `working.html` - a standalone HTML file containing the complete application with embedded CSS, JavaScript, and Supabase integration.

**Current Version:** 1.10.50

## Key Project Files

- **Main App:** `working.html` - Complete standalone PWA application with embedded CSS/JavaScript
- **Database Schema:** `database/` folder contains SQL files for Supabase setup
- **Documentation:** `docs/` folder contains implementation guides and development history
- **Current Deployment:** Local development, ready for hosting on any static web server

## Architecture & Technical Details

### Authentication
- **Supabase Auth** with email/password authentication
- **Password Reset:** Complete forgot-password workflow with email links
- **User Profiles:** Comprehensive user management with store associations
- **Multi-Store Access:** Users can belong to multiple store locations
- **Critical:** Never break working authentication - user has emphasized this multiple times

### Database Tables (Supabase PostgreSQL)
- **user_profiles:** User information and preferences
- **user_store_access:** Multi-store permission management
- **stores:** Store locations and details
- **equipment:** Temperature monitoring equipment
- **temperature_logs:** All temperature readings with user tracking
- **global_permissions:** Admin permission system for advanced features

### Data Synchronization
- **Real-time Updates:** Supabase real-time subscriptions for cross-device sync
- **Offline Support:** PWA functionality with local storage fallback
- **Cross-Device Notifications:** Immediate updates when data changes on other devices

## Version Management

**🚨 CRITICAL - EXTREMELY IMPORTANT:** Always increment version in ALL locations when making changes:
- HTML title tag (`<title>TempTracker Pro v1.X.X | Cristy's Pizza</title>`)
- Console log message (`console.log('🌡️ TempTracker Pro v1.X.X loaded successfully!')`)
- Header version display in working.html
- Any version references in comments or documentation

**Current Version Pattern:** 1.X.X (Supabase-based architecture)

**⚠️ WARNING:** Failing to update ALL version locations will cause confusion about which version is running!

## Development Conventions

### Code Style
- **No comments** unless explicitly requested
- **Global functions** using `window.functionName` pattern for onclick handlers
- **Async/await** for all Supabase database operations
- **Error handling** with try/catch and user notifications
- **Console logging** with emojis for better debugging

### Supabase Integration
- Always check for authenticated user before database operations
- Provide fallback notifications for database failures
- Use proper Supabase client methods with error handling
- Handle both online and offline scenarios gracefully

### Image Handling
- Use authenticated Supabase storage for equipment images
- Cache images as blob URLs to avoid repeated API calls
- Implement proper image upload and deletion workflows

### UI Updates
- Always call `updateUI()` after data changes
- Show appropriate notifications with emojis (🔗 for database sync, 📱 for cross-device updates)
- Use consistent color coding (green for success, yellow for warnings, red for errors)

## Common Tasks

### Development
- **Local Testing:** Open `working.html` in browser with live server
- **Database Testing:** Use Supabase dashboard for data verification
- **Authentication Testing:** Use browser dev tools to inspect auth state

### Deployment
1. Update version in all locations
2. Deploy `working.html` to any static web hosting service
3. Configure Supabase environment variables if needed
4. Test in private browser window to verify changes

## Known Issues & Patterns

### Browser Caching
- Browsers may cache HTML file
- Hard refresh (Ctrl+F5) may be needed to see updates
- Version changes help users identify current version

### Function Scoping
- All onclick handler functions must be globally accessible (`window.functionName`)
- Async functions in onclick handlers require proper error handling

### Supabase Sync Patterns
- Individual temperature logging: Direct Supabase insert operations
- Bulk temperature logging: Sequential database operations with error handling
- Equipment updates: CRUD operations through Supabase client
- Image handling: Supabase storage integration

### Cross-Device Synchronization
- Real-time subscriptions for immediate updates
- Supabase real-time capabilities handle cross-device sync
- Shows notifications for data changes from other devices

## User Preferences

- **Responsiveness Priority:** User values near real-time updates across devices
- **Reliability:** Prefers reliable functionality over complex features
- **Simplicity:** Wants minimal code changes and simple implementations
- **Authentication Stability:** Never break working authentication (mentioned multiple times)

## Recent Development History

- v1.10.50: Current stable Supabase-based version with UI enhancements (edit/delete icons standardization, horizontal button alignment, profile settings implementation plan, Claude Code hook fixes)
- v1.10.5: UI Inspector bug fixes (color picker event listeners, comprehensive logging, toggle functionality, real-time color updates)
- v1.10.4: Critical bug fixes (infinite loop fix, permission validation, context menu reliability)
- v1.10.3: Supabase-based version with debugging improvements (comprehensive logging for UI Inspector context menu troubleshooting)
- v1.10.2: Supabase-based version with full feature set (bug fix: UI Inspector permission auto-creation and debugging)
- v1.10.1: Supabase-based version with full feature set (bug fix: restored Admin Settings button)
  - Complete authentication with password reset functionality
  - Multi-store management with user access control
  - Equipment management with image support and reordering
  - Temperature logging with validation and status indicators
  - PDF and Excel export functionality for compliance reporting
  - Dark mode support with persistent user preference
  - Admin settings panel for permission management
  - Real-time cross-device synchronization
- v1.7.8-v1.7.9: Export functionality and UI improvements
  - Added jsPDF and SheetJS libraries for document generation
  - Implemented comprehensive PDF export with statistics
  - Added Excel export with formatted data sheets
  - Fixed z-index issues with dropdown menus
- v1.6.x: Authentication system implementation and user management
- Migration: Successfully transitioned from SharePoint to modern Supabase architecture

## Notes

- User frequently tests on both mobile and desktop for cross-device functionality
- Temperature monitoring is critical for food safety compliance
- Application serves restaurant environments with multiple staff members
- Performance and battery efficiency considerations for mobile devices
- Single HTML file architecture maintained per user preference
- Export functionality essential for regulatory compliance and record-keeping
- Dark mode support for different lighting conditions in restaurant environments