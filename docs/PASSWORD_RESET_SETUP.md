# Password Reset Setup Guide

## Overview
This guide explains how to configure Supabase to use custom password reset URLs that redirect users back to your TempTracker Pro application instead of Supabase's default reset page.

## Current Implementation

### 1. Custom Reset Page
- **File**: `reset-password.html`
- **Purpose**: Landing page for password reset links from email
- **Function**: Validates tokens and redirects to main app

### 2. In-App Reset Modal
- **Location**: `working.html` - Password Reset Page modal
- **Purpose**: Allows users to set new password within the app
- **Features**: Password validation, confirmation, and secure update

### 3. JavaScript Functions
- `resetPassword()`: Initiates password reset with custom redirect URL
- `checkPasswordResetToken()`: Checks for reset tokens on app load
- `handlePasswordReset()`: Processes password update
- `showPasswordResetPage()` / `closePasswordResetPage()`: Modal management

## Supabase Configuration Required

### Step 1: Configure Site URL
1. Go to your Supabase Dashboard
2. Navigate to **Authentication** → **Settings**
3. Under **Site URL**, set your application URL:
   ```
   https://yourdomain.com
   ```

### Step 2: Configure Redirect URLs
1. In **Authentication** → **Settings**
2. Under **Redirect URLs**, add:
   ```
   https://yourdomain.com/reset-password
   https://yourdomain.com/
   ```

### Step 3: Update Email Templates (Optional)
1. Go to **Authentication** → **Email Templates**
2. Select **Reset Password** template
3. Customize the email content if desired
4. The reset link will automatically use your configured redirect URL

## How It Works

### 1. User Requests Password Reset
- User clicks "Reset Password" in Profile Settings
- `resetPassword()` function calls Supabase with custom redirect URL
- Supabase sends email with reset link pointing to `/reset-password`

### 2. User Clicks Email Link
- User clicks link in email
- Browser opens `reset-password.html`
- Page validates tokens and redirects to main app with tokens

### 3. App Processes Reset
- Main app loads and `checkPasswordResetToken()` runs
- If valid tokens found, password reset modal opens
- User enters new password and submits
- `handlePasswordReset()` updates password via Supabase

## Testing

### Local Development
For local testing, use:
```
http://localhost:3000/reset-password
http://localhost:3000/
```

### Production
For production, use your actual domain:
```
https://yourdomain.com/reset-password
https://yourdomain.com/
```

## Security Considerations

1. **Token Validation**: The reset page validates tokens before redirecting
2. **HTTPS Required**: Production must use HTTPS for security
3. **Token Expiration**: Supabase tokens expire automatically
4. **Password Requirements**: Minimum 6 characters enforced
5. **Session Management**: Proper session handling after password update

## Troubleshooting

### Common Issues

1. **Redirect URL Not Working**
   - Ensure URL is added to Supabase redirect URLs
   - Check for typos in domain/port
   - Verify HTTPS in production

2. **Tokens Not Found**
   - Check email link format
   - Verify token expiration
   - Ensure proper URL parameters

3. **Modal Not Opening**
   - Check browser console for errors
   - Verify `checkPasswordResetToken()` is called
   - Ensure modal HTML is present

### Debug Steps

1. Check browser console for errors
2. Verify Supabase configuration
3. Test with fresh reset request
4. Check network tab for API calls

## Files Modified

- `working.html`: Added password reset modal and functions
- `reset-password.html`: Created landing page for reset links
- `docs/PASSWORD_RESET_SETUP.md`: This documentation

## Next Steps

1. Configure Supabase redirect URLs
2. Test password reset flow
3. Deploy `reset-password.html` to your server
4. Update Supabase site URL for production 