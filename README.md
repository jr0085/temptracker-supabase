# TempTracker Pro - Supabase Version

A Professional Progressive Web Application (PWA) for restaurant temperature monitoring with modern Supabase backend integration.

## Current Version
**v1.10.51** - Production Ready Supabase-based Architecture with Enhanced Mobile Responsiveness

## Project Overview

TempTracker Pro is a comprehensive temperature monitoring solution designed specifically for restaurant environments. This application helps ensure food safety compliance by tracking equipment temperatures with user accountability, real-time alerts, and comprehensive reporting capabilities.

## Main Application
- **`working.html`** - Complete standalone PWA application with embedded CSS, JavaScript, and Supabase integration
- **Single File Architecture** - Self-contained for easy deployment and maintenance
- **No Build Process Required** - Direct deployment to any static web hosting service

## Key Features

### 🔐 Authentication & User Management
- Complete user signup/login system with email verification
- Password reset functionality with secure email workflow and hash fragment support
- Multi-user support with role-based permissions
- User profiles with store association management
- Persistent login sessions with secure token management

### 🏢 Multi-Store Management
- Support for multiple restaurant locations
- User-specific store access control
- Seamless store switching interface with dropdown menu
- Store-specific equipment and temperature data
- Default store selection during user registration

### 🔧 Equipment Management
- Full CRUD operations for temperature monitoring equipment
- Equipment categorization (freezers, coolers, ovens, etc.)
- Image support with cropping functionality
- Drag-and-drop reordering capabilities
- Custom temperature range settings per equipment
- Active/inactive status management

### 🌡️ Temperature Tracking
- Individual temperature logging with validation
- Bulk temperature logging for multiple equipment
- Temperature status indicators (Good/Warning/Critical)
- User accountability - tracks who logged each temperature
- Time-stamped entries for audit compliance
- Edit and delete capabilities with confirmation dialogs
- Visual feedback for temperature status (color-coded)

### 📊 Reporting & Analytics
- Temperature history viewing with date range filtering
- Edit/delete capabilities for temperature logs
- PDF export for compliance documentation with formatted tables
- Excel export for data analysis with multiple sheets
- Summary statistics (total logs, status breakdowns)
- Equipment-specific temperature history
- User activity tracking

### 📱 Progressive Web Application
- Mobile-optimized responsive design with enhanced touch targets (44px minimum)
- Comprehensive mobile UI improvements for restaurant staff using tablets/phones
- Offline capability with local storage fallback
- Install prompts for native app-like experience
- Touch-friendly interface with improved mobile button sizing and spacing
- Battery-efficient performance optimized for mobile devices
- Fast loading with CDN-hosted dependencies

### 🔄 Real-Time Synchronization
- Cross-device data synchronization
- Real-time updates using Supabase subscriptions
- Automatic conflict resolution
- Visual notifications for remote data changes (🔗 sync, 📱 cross-device)
- Immediate UI updates across all connected devices

### ⚙️ Admin Controls
- Admin permission system for advanced users
- Global permissions management (store add/edit/delete)
- User management and access control
- System configuration options
- Location management capabilities
- Permission-based UI visibility

### 🎨 User Interface
- Modern glassmorphism design with backdrop blur effects
- Dark mode support with persistent preference
- Responsive grid layouts for all screen sizes
- Smooth animations and transitions
- Professional color scheme with accessibility considerations
- Emoji indicators for better visual communication

## Technology Stack

### Frontend
- **HTML5** with modern responsive design
- **Tailwind CSS** (v3.x via CDN) for professional styling with glassmorphism effects
- **Vanilla JavaScript** with modern ES6+ features and async/await patterns
- **PWA Technologies** for offline support and app-like experience

### Backend
- **Supabase** (v2.39.3) - PostgreSQL database with real-time capabilities
- **Supabase Auth** - Secure authentication and user management
- **Row Level Security** - Database-level access control (currently disabled for development)
- **Real-time Subscriptions** - Live data synchronization

### Libraries & Tools
- **jsPDF** (v2.5.1) - PDF generation for temperature reports
- **jsPDF-AutoTable** (v3.5.31) - Table formatting for PDF exports
- **SheetJS/xlsx** (v0.18.5) - Excel file generation for data exports

### Architecture
- **Single HTML File** - Self-contained application for easy deployment
- **Embedded Resources** - CSS and JavaScript included in main file
- **Static Hosting Compatible** - No server-side requirements beyond Supabase
- **CDN Dependencies** - All libraries loaded via CDN for simplicity

## Quick Setup

### 1. Database Setup
```bash
# See DATABASE_SETUP.md for detailed instructions
1. Create Supabase account at https://supabase.com
2. Create new project
3. Run SQL scripts from database/ folder
4. Copy project URL and API keys
```

### 2. Configuration
```javascript
// Update Supabase credentials in working.html
const supabaseUrl = 'https://your-project.supabase.co';
const supabaseKey = 'your-anon-key-here';
```

### 3. Deployment
```bash
# Deploy working.html to any static hosting service:
- Netlify (drag and drop)
- Vercel
- GitHub Pages (currently used for production deployment)
- Any web server
```

## File Structure
```
temptracker-supabase/
├── working.html              # Main application file (v1.10.51)
├── database/                 # SQL setup scripts
│   ├── schema.sql           # Core database schema
│   ├── enable-rls.sql       # Security policies
│   ├── updated-schema.sql   # Latest schema updates
│   ├── schema-fixed.sql     # Fixed schema with corrections
│   └── debug-rls.sql        # RLS debugging utilities
├── docs/                    # Documentation
│   ├── todo.md                        # Development history
│   ├── CRITICAL_LEARNING.md           # Important lessons
│   ├── admin-permissions-plan.md      # Admin features roadmap
│   ├── SUPABASE_MIGRATION.md          # Migration documentation
│   ├── ARCHITECTURE_DECISION_RECORD.md # Architecture decisions
│   └── SESSION_CONTEXT_REVIEW.md      # Context review notes
├── README.md               # This file
├── CLAUDE.md              # Development guidelines
├── DATABASE_SETUP.md      # Setup instructions
└── PROJECT_CONTENTS.md    # Project overview
```

## For Developers

### Development Workflow
1. Read `CLAUDE.md` for complete development guidelines
2. Follow established patterns for code organization
3. Always update version numbers when making changes
4. Test thoroughly on both mobile and desktop devices

### Key Principles
- **Authentication Stability** - Never break working login system
- **Simple Changes** - Prefer minimal code modifications
- **Version Management** - Update version in all locations
- **Professional Quality** - Modern UI with reliable functionality

### Database Schema
- **user_profiles** - User information and preferences
- **user_store_access** - Multi-store permission management
- **stores** - Restaurant location data
- **equipment** - Temperature monitoring equipment
- **temperature_logs** - All temperature readings with full audit trail
- **global_permissions** - Admin permission settings for advanced features

## Production Ready Features

- ✅ Complete authentication system with password recovery
- ✅ Multi-store/multi-user support with permissions
- ✅ Full equipment lifecycle management with image support
- ✅ Comprehensive temperature tracking and reporting
- ✅ PDF/Excel export for compliance documentation
- ✅ Real-time cross-device synchronization
- ✅ Mobile-optimized PWA with offline support
- ✅ Admin controls and user management
- ✅ Professional UI with glassmorphism design
- ✅ Dark mode support with user preference persistence
- ✅ Comprehensive error handling and user notifications
- ✅ Food safety compliance features (temperature validation, audit trails)

## Support & Documentation

- **Setup Guide:** `DATABASE_SETUP.md`
- **Development Guidelines:** `CLAUDE.md`
- **Migration Documentation:** `SUPABASE_MIGRATION.md`
- **Architecture Decisions:** `ARCHITECTURE_DECISION_RECORD.md`
- **Development History:** `docs/todo.md`

## License

Private project for restaurant temperature monitoring compliance.