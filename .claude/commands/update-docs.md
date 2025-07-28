---
description: Automatically update all README, CLAUDE.md, and documentation files based on current codebase changes
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Auto-Update Documentation Command

Analyze the current codebase and automatically update all documentation files to reflect recent changes, including:

1. **CLAUDE.md** - Update project context, version numbers, recent changes, and development workflow
2. **README.md** - Update project description, setup instructions, and feature list  
3. **PROJECT_CONTENTS.md** - Update file structure and project overview
4. **All docs/*.md files** - Update technical documentation, architecture decisions, and guides

## Process:

1. First, scan the entire codebase to understand current state:
   - Check git status and recent commits
   - Analyze main application files and structure
   - Review package.json and dependencies
   - Check for new features or significant changes

2. For each documentation file:
   - Read current content
   - Identify sections that need updates based on code analysis
   - Update outdated information
   - Add new sections for recent features/changes
   - Maintain existing formatting and structure

3. Specific updates to make:
   - **Version numbers**: Ensure all version references are current and consistent
   - **File paths**: Update any changed file locations or structure
   - **Features**: Document new functionality found in code
   - **Dependencies**: Update technology stack and library versions
   - **Setup instructions**: Verify and update installation/deployment steps
   - **Architecture**: Update technical details and data flow descriptions

4. Maintain the user's preferred documentation style:
   - Keep technical accuracy high
   - Use clear, concise language
   - Include relevant code examples where helpful
   - Preserve existing organization and hierarchy

Generate comprehensive updates that ensure all documentation accurately reflects the current state of the codebase.