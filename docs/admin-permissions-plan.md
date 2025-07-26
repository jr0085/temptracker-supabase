# Admin Permissions System - Implementation Plan

## Overview
Create a comprehensive admin screen that allows administrators to control permissions for store management, equipment management, and system features. Admin can control permissions for themselves and all other users.

## Current System Analysis
- **Database Tables**: `user_profiles`, `user_store_access` 
- **Current Access Levels**: `employee` (basic level found in signup)
- **Missing**: Admin role system, granular permissions, admin interface

## Database Schema Changes Needed

### 1. Add Admin Role to user_profiles
```sql
-- Add admin flag and role to user_profiles
ALTER TABLE user_profiles ADD COLUMN is_admin BOOLEAN DEFAULT false;
ALTER TABLE user_profiles ADD COLUMN role VARCHAR(20) DEFAULT 'employee';
-- Values: 'admin', 'manager', 'employee'
```

### 2. Create Global Permissions Table
```sql
-- Global system permissions that admin can control
CREATE TABLE global_permissions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    permission_name VARCHAR(50) NOT NULL UNIQUE,
    display_name VARCHAR(100) NOT NULL,
    description TEXT,
    enabled_for_admin BOOLEAN DEFAULT true,
    enabled_for_users BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Insert default permissions
INSERT INTO global_permissions (permission_name, display_name, description) VALUES
('store_add', 'Add New Stores', 'Allow creating new store locations'),
('store_edit', 'Edit Stores', 'Allow modifying existing store details'),
('store_delete', 'Delete Stores', 'Allow removing stores from system'),
('store_reorder', 'Reorder Stores', 'Allow drag-and-drop reordering of stores'),
('equipment_add', 'Add Equipment', 'Allow creating new equipment items'),
('equipment_edit', 'Edit Equipment', 'Allow modifying equipment details'),
('equipment_delete', 'Delete Equipment', 'Allow removing equipment from system'),
('equipment_reorder', 'Reorder Equipment', 'Allow drag-and-drop reordering of equipment');
```

### 3. User-Specific Permission Overrides (Optional)
```sql
-- Allow per-user permission overrides if needed later
CREATE TABLE user_permission_overrides (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id),
    permission_name VARCHAR(50) REFERENCES global_permissions(permission_name),
    enabled BOOLEAN NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id, permission_name)
);
```

## Implementation Plan

### Phase 1: Database Setup ✅
1. Run SQL to add admin columns to user_profiles
2. Create global_permissions table with default permissions
3. Create user_permission_overrides table for future use
4. Update first user to be admin for testing

### Phase 2: Permission Helper Functions 📝
1. Create `checkPermission(permissionName)` function
2. Create `isCurrentUserAdmin()` function  
3. Create `getUserPermissions()` function
4. Create `updateGlobalPermission()` function

### Phase 3: Admin Interface UI 📝
1. Create admin screen modal/page
2. Add permission toggle switches for each feature
3. Add separate controls for "Admin" vs "All Users"
4. Add admin menu access (gear icon in header)

### Phase 4: Update Existing UI 📝
1. Conditionally show/hide Add Store button based on `store_add` permission
2. Conditionally show/hide Edit Store buttons based on `store_edit` permission  
3. Conditionally show/hide Delete Store buttons based on `store_delete` permission
4. Conditionally show/hide store drag handles based on `store_reorder` permission
5. Conditionally show/hide Add Equipment button based on `equipment_add` permission
6. Conditionally show/hide Edit Equipment buttons based on `equipment_edit` permission
7. Conditionally show/hide Delete Equipment buttons based on `equipment_delete` permission
8. Conditionally show/hide equipment drag handles based on `equipment_reorder` permission

### Phase 5: Testing & Polish 📝
1. Test all permission combinations
2. Test admin controls work correctly
3. Verify non-admin users cannot access admin screen
4. Test permission changes take effect immediately

## UI Changes Required

### Admin Screen Layout
```
┌─────────────────────────────────────────┐
│ 🔧 Admin Settings                       │
├─────────────────────────────────────────┤
│ Store Management Permissions            │
│ ├─ Add New Stores                       │
│ │  Admin: [✓] All Users: [✓]           │
│ ├─ Edit Stores                          │
│ │  Admin: [✓] All Users: [✓]           │
│ ├─ Delete Stores                        │
│ │  Admin: [✓] All Users: [ ]           │
│ └─ Reorder Stores                       │
│    Admin: [✓] All Users: [✓]           │
├─────────────────────────────────────────┤
│ Equipment Management Permissions        │
│ ├─ Add Equipment                        │
│ │  Admin: [✓] All Users: [✓]           │
│ ├─ Edit Equipment                       │
│ │  Admin: [✓] All Users: [✓]           │
│ ├─ Delete Equipment                     │
│ │  Admin: [✓] All Users: [ ]           │
│ └─ Reorder Equipment                    │
│    Admin: [✓] All Users: [✓]           │
├─────────────────────────────────────────┤
│          [Save Changes]                 │
└─────────────────────────────────────────┘
```

### Header Admin Access
- Add gear icon (⚙️) next to user profile for admins only
- Clicking opens admin settings modal

### Conditional UI Elements
```javascript
// Example: Store Add Button
if (checkPermission('store_add')) {
    showAddStoreButton();
} else {
    hideAddStoreButton();
}

// Example: Equipment Delete Button  
if (checkPermission('equipment_delete')) {
    showDeleteButtons();
} else {
    hideDeleteButtons();
}
```

## Functions to Implement

### 1. Permission Checking
```javascript
// Check if current user has permission
async function checkPermission(permissionName) {
    // If user is admin, check admin permission
    // If user is not admin, check user permission
    // Return boolean
}

// Check if current user is admin
function isCurrentUserAdmin() {
    return userProfile?.is_admin === true;
}

// Load all permissions for current user
async function loadUserPermissions() {
    // Load global permissions
    // Apply user-specific overrides if any
    // Store in global permissions object
}
```

### 2. Admin Controls
```javascript
// Update global permission setting
async function updateGlobalPermission(permissionName, enabledForAdmin, enabledForUsers) {
    // Update database
    // Refresh permissions
    // Update UI immediately
}

// Open admin settings modal
function openAdminSettings() {
    // Only allow if user is admin
    // Load current permission states
    // Show modal with toggle controls
}
```

### 3. UI Updates
```javascript
// Refresh all UI elements based on permissions
function refreshUIPermissions() {
    // Check each permission and show/hide corresponding buttons
    updateStoreManagementUI();
    updateEquipmentManagementUI();
}

// Update store-related UI elements
function updateStoreManagementUI() {
    toggleElement('add-store-button', checkPermission('store_add'));
    toggleElement('edit-store-buttons', checkPermission('store_edit'));
    toggleElement('delete-store-buttons', checkPermission('store_delete'));
    toggleElement('store-drag-handles', checkPermission('store_reorder'));
}
```

## Security Considerations

### 1. Database Security
- Only admins can modify global_permissions table
- Add RLS policies to protect admin functions
- Validate admin status server-side

### 2. Frontend Security  
- Hide UI elements but don't rely on it for security
- Always validate permissions server-side for database operations
- Admin status stored in secure user profile

### 3. Permission Inheritance
- Admins always have permissions (can't disable for themselves completely)
- Global permissions apply to all non-admin users
- Individual overrides can be added later if needed

## Testing Checklist

### Admin User Tests
- [ ] Can access admin settings screen
- [ ] Can toggle all permissions on/off
- [ ] Changes save to database correctly
- [ ] Changes take effect immediately in UI
- [ ] Can still perform all actions when admin permissions enabled

### Regular User Tests  
- [ ] Cannot access admin settings screen
- [ ] Respects permission settings set by admin
- [ ] UI buttons hidden/shown correctly based on permissions
- [ ] Server-side operations blocked if permissions disabled

### Permission Combinations
- [ ] All permissions enabled - all buttons visible
- [ ] All permissions disabled - no management buttons visible  
- [ ] Mixed permissions - only allowed buttons visible
- [ ] Admin vs user permission differences work correctly

## Files to Modify

1. **working.html** - Main application file
   - Add admin interface modal
   - Add permission checking functions
   - Update existing UI conditionals
   - Add admin menu access

2. **Database** - Supabase schema updates
   - Add admin columns to user_profiles
   - Create global_permissions table
   - Create user_permission_overrides table
   - Set initial admin user

## Version Management
- Update from v1.8.4 to v1.9.0 (major feature addition)
- Update version in title, console log, and display

## Risk Mitigation
- Keep admin permissions enabled by default during development
- Test thoroughly with different user types before deployment
- Provide rollback plan if permissions break existing functionality
- Ensure at least one admin user always exists

## Success Criteria
✅ Admin can control all specified permissions for themselves and others
✅ UI elements properly hidden/shown based on permissions  
✅ Non-admin users cannot access admin settings
✅ Permission changes take effect immediately without page reload
✅ All existing functionality preserved when permissions enabled
✅ No database operations possible when permissions disabled