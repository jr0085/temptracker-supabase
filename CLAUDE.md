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

- **`SHAREPOINT_PWA_IMPLEMENTATION_GUIDE.md`** - Complete setup and development approach with proven patterns
- **`SHAREPOINT_PWA_QUICK_REFERENCE.md`** - Fast setup checklist and condensed reference
- **`SHAREPOINT_PWA_TROUBLESHOOTING.md`** - Common issues and solutions from real-world experience
- **`SharePointListSetup.md`** - SharePoint list creation and configuration details
- **`ENTRA_ID_SETUP.md`** - Azure/Entra ID app registration and permission setup
- **`DEPLOYMENT.md`** - Production deployment procedures and considerations

## Project Overview

TempTracker Pro is a Progressive Web Application (PWA) for restaurant temperature monitoring with SharePoint integration. The main application file is located at `netlify-real-app/index.html` - a standalone HTML file containing the complete React-like application.

**Current Version:** 2.5.913

## Key Project Files

- **Main App:** `netlify-real-app/index.html` - Complete standalone PWA application
- **Service Worker:** `netlify-real-app/sw.js` - Offline functionality and caching
- **Deployment:** Files are deployed to Netlify at https://sensational-caramel-e44989.netlify.app/
- **SharePoint Integration:** Uses SharePoint Online REST API with MSAL 3.5.0 authentication

## Architecture & Technical Details

### Authentication
- **MSAL 3.5.0** with Authorization Code Flow + PKCE
- **Scope:** `https://cristyspizza.sharepoint.com/.default`
- **Login Methods:** Both popup and redirect supported
- **Critical:** Never break working authentication - user has emphasized this multiple times

### SharePoint Lists
- **Stores:** `TempTracker_Stores`
- **Equipment:** `TempTracker_Equipment`
- **Temperature Logs:** `TempTracker_TemperatureLogs`
- **Images:** `TempTracker_EquipmentImages`

### Data Synchronization
- **Enhanced Polling:** Every 45 seconds with change tracking
- **Page Visibility API:** Immediate refresh when tab becomes visible
- **Manual Refresh:** Available in hamburger menu
- **Change Detection:** Uses SharePoint `Modified` field with OData filters

## Version Management

**🚨 CRITICAL - EXTREMELY IMPORTANT:** Always increment version in ALL locations when making changes:
- HTML title tag (`<title>TempTracker Pro v2.5.XXX</title>`)
- Main heading (h1) (`<h1>TempTracker Pro v2.5.XXX</h1>`)
- Console log message (`console.log('🌡️ TempTracker Pro v2.5.XXX loaded successfully!')`)
- Flyout menu version display (`v2.5.XXX - TempTracker Pro`)
- Manifest link (`href="./manifest.json?v=2.5.XXX"`)
- Service worker registration (`navigator.serviceWorker.register('./sw.js?v=2.5.XXX')`)
- Service worker cache names (all 3 in sw.js file):
  - `CACHE_NAME = 'temptracker-pro-v2.5.XXX'`
  - `STATIC_CACHE_NAME = 'temptracker-static-v2.5.XXX'`
  - `DYNAMIC_CACHE_NAME = 'temptracker-dynamic-v2.5.XXX'`

**⚠️ WARNING:** Failing to update ALL version locations will cause caching issues and prevent users from seeing updates!

## Development Conventions

### Code Style
- **No comments** unless explicitly requested
- **Global functions** using `window.functionName` pattern for onclick handlers
- **Async/await** for all SharePoint operations
- **Error handling** with try/catch and user notifications
- **Console logging** with emojis for better debugging

### SharePoint Integration
- Always check for `accessToken && sharePointService` before SharePoint operations
- Provide fallback notifications for SharePoint failures
- Use proper SharePoint REST API endpoints with authentication headers
- Handle both online and offline scenarios gracefully

### Image Handling
- Use authenticated SharePoint REST API endpoints (not direct URLs)
- Cache images as blob URLs to avoid repeated API calls
- Handle CORS restrictions by using `/_api/web/lists/.../Files('filename')/$value`

### UI Updates
- Always call `saveData()` and `updateUI()` after data changes
- Show appropriate notifications with emojis (🔗 for SharePoint sync, 📱 for cross-device updates)
- Use consistent color coding (green for success, yellow for warnings, red for errors)

## Common Tasks

### Build/Test Commands
- **Lint:** `npm run lint` (if available)
- **Type Check:** `npm run typecheck` (if available)
- **Test:** Check for test scripts in package.json

### Deployment
1. Update version in all locations
2. Deploy to Netlify
3. Clear browser cache/service worker if needed
4. Test in private browser window

## Known Issues & Patterns

### Service Worker Caching
- Browsers aggressively cache service workers
- Version changes in cache names should force updates
- Users may need to clear browser cache for immediate updates

### Function Scoping
- All onclick handler functions must be globally accessible (`window.functionName`)
- Async functions in onclick handlers require proper error handling

### SharePoint Sync Patterns
- Individual temperature logging: Uses `sharePointService.createTemperatureLog()`
- Bulk temperature logging: Loops through each entry with SharePoint sync
- Equipment updates: Uses `sharePointService.updateEquipment()`
- Image handling: Upload, then delete old if different

### Cross-Device Synchronization
- Enhanced polling checks for changes every 45 seconds
- Only performs full sync when changes detected
- Page visibility API provides immediate updates on tab focus
- Shows subtle notifications for cross-device updates

## User Preferences

- **Responsiveness Priority:** User values near real-time updates across devices
- **Reliability:** Prefers reliable functionality over complex features
- **Simplicity:** Wants minimal code changes and simple implementations
- **Authentication Stability:** Never break working authentication (mentioned multiple times)

## Recent Development History

- v2.5.913: Enhanced cross-device synchronization with change tracking
- v2.5.912: SharePoint temperature log editing/deletion, image removal fixes
- v2.5.911: Individual temperature logging SharePoint sync fixes
- v2.5.910: Periodic refresh, bulk logging SharePoint sync

## Notes

- User frequently tests on both mobile and desktop for cross-device functionality
- Temperature monitoring is critical for food safety compliance
- Application serves restaurant environments with multiple staff members
- Performance and battery efficiency considerations for mobile devices