# Claude Code Auto-Commit Hook Script
# Automatically commits and pushes successful code changes to GitHub

# Read the JSON input from Claude Code
$input = [Console]::In.ReadToEnd() | ConvertFrom-Json

# Check if the tool execution was successful (no errors)
if ($null -eq $input.result.error) {
    Write-Host "✅ Code change successful - preparing to commit..." -ForegroundColor Green
    
    # Stage all changes
    git add -A
    
    # Get the tool name and file path for commit message
    $toolName = $input.tool
    $fileName = if ($input.params.file_path) { 
        Split-Path -Leaf $input.params.file_path 
    } else { 
        "files" 
    }
    
    # Create descriptive commit message
    $commitMessage = "Auto-commit: $toolName on $fileName via Claude Code"
    
    # Commit the changes
    git commit -m $commitMessage
    
    # Push to GitHub
    Write-Host "📤 Pushing to GitHub..." -ForegroundColor Yellow
    git push origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Changes successfully pushed to GitHub!" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Push failed - changes committed locally" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ Skipping commit - tool execution had errors" -ForegroundColor Red
    Write-Host "Error: $($input.result.error)" -ForegroundColor Red
}