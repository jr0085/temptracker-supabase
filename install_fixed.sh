#!/bin/bash
# Voice Mode Universal Installer
# Usage: curl -sSf https://getvoicemode.com/install.sh | sh

set -e

# Reattach stdin to terminal for interactive prompts when run via curl | bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Global variables
OS=""
ARCH=""
HOMEBREW_INSTALLED=false
XCODE_TOOLS_INSTALLED=false
IS_WSL=false

print_step() {
  echo -e "${BLUE}🔧 $1${NC}"
}

print_success() {
  echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
  echo -e "${RED}❌ $1${NC}"
  exit 1
}

detect_os() {
  print_step "Detecting operating system..."

  # Check if running in WSL
  if [[ -n "$WSL_DISTRO_NAME" ]] || grep -qi microsoft /proc/version 2>/dev/null; then
    IS_WSL=true
    print_warning "Running in WSL2 - additional audio setup may be required"
  fi

  if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    ARCH=$(uname -m)
    local macos_version=$(sw_vers -productVersion)
    print_success "Detected macOS $macos_version on $ARCH"
  elif [[ -f /etc/fedora-release ]]; then
    OS="fedora"
    ARCH=$(uname -m)
    local fedora_version=$(cat /etc/fedora-release | grep -oP '\d+' | head -1)
    print_success "Detected Fedora $fedora_version on $ARCH${IS_WSL:+ (WSL2)}"
  elif [[ -f /etc/os-release ]]; then
    source /etc/os-release
    if [[ "$ID" == "ubuntu" ]] || [[ "$ID_LIKE" == *"ubuntu"* ]]; then
      OS="ubuntu"
      ARCH=$(uname -m)
      print_success "Detected Ubuntu $VERSION_ID on $ARCH${IS_WSL:+ (WSL2)}"
    elif [[ "$ID" == "fedora" ]]; then
      OS="fedora"
      ARCH=$(uname -m)
      print_success "Detected Fedora $VERSION_ID on $ARCH${IS_WSL:+ (WSL2)}"
    else
      print_error "Unsupported Linux distribution: $ID. Currently only Ubuntu and Fedora are supported."
    fi
  else
    print_error "Unsupported operating system: $OSTYPE"
  fi
}

check_xcode_tools() {
  print_step "Checking for Xcode Command Line Tools..."

  if xcode-select -p >/dev/null 2>&1; then
    XCODE_TOOLS_INSTALLED=true
    print_success "Xcode Command Line Tools are already installed"
  else
    print_warning "Xcode Command Line Tools not found"
  fi
}

install_xcode_tools() {
  if [ "$XCODE_TOOLS_INSTALLED" = false ]; then
    print_step "Installing Xcode Command Line Tools..."
    echo "This will open a dialog to install Xcode Command Line Tools."
    echo "Please follow the prompts and re-run this installer after installation completes."

    xcode-select --install

    print_warning "Please complete the Xcode Command Line Tools installation and re-run this installer."
    exit 0
  fi
}

check_homebrew() {
  print_step "Checking for Homebrew..."

  if command -v brew >/dev/null 2>&1; then
    HOMEBREW_INSTALLED=true
    print_success "Homebrew is already installed"
  else
    print_warning "Homebrew not found"
  fi
}

confirm_action() {
  local action="$1"
  echo ""
  echo "About to: $action"
  read -p "Continue? (y/n): " choice
  case $choice in
  [Yy]*) return 0 ;;
  *)
    echo "Skipping: $action"
    return 1
    ;;
  esac
}

install_homebrew() {
  if [ "$HOMEBREW_INSTALLED" = false ]; then
    if confirm_action "Install Homebrew (this will also install Xcode Command Line Tools)"; then
      print_step "Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

      # Add Homebrew to PATH for current session
      if [[ "$ARCH" == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      else
        eval "$(/usr/local/bin/brew shellenv)"
      fi

      print_success "Homebrew installed successfully"

      # Update the status variables since Homebrew installs Xcode tools
      HOMEBREW_INSTALLED=true
      XCODE_TOOLS_INSTALLED=true
    else
      print_error "Homebrew is required for Voice Mode dependencies. Installation aborted."
    fi
  fi
}

check_system_dependencies() {
  print_step "Checking system dependencies..."

  if [[ "$OS" == "macos" ]]; then
    local packages=("node" "portaudio" "ffmpeg" "cmake")
    local missing_packages=()

    for package in "${packages[@]}"; do
      if brew list "$package" >/dev/null 2>&1; then
        print_success "$package is already installed"
      else
        missing_packages+=("$package")
      fi
    done

    if [ ${#missing_packages[@]} -eq 0 ]; then
      print_success "All system dependencies are already installed"
      return 0
    else
      echo "Missing packages: ${missing_packages[*]}"
      return 1
    fi
  elif [[ "$OS" == "fedora" ]]; then
    local packages=("nodejs" "portaudio-devel" "ffmpeg" "cmake" "python3-devel" "alsa-lib-devel")
    local missing_packages=()

    for package in "${packages[@]}"; do
      # Special handling for ffmpeg which might be installed from RPM Fusion
      if [[ "$package" == "ffmpeg" ]]; then
        if command -v ffmpeg >/dev/null 2>&1; then
          print_success "$package is already installed"
        else
          missing_packages+=("$package")
        fi
      elif rpm -q "$package" >/dev/null 2>&1; then
        print_success "$package is already installed"
      else
        missing_packages+=("$package")
      fi
    done

    if [ ${#missing_packages[@]} -eq 0 ]; then
      print_success "All system dependencies are already installed"
      return 0
    else
      echo "Missing packages: ${missing_packages[*]}"
      return 1
    fi
  elif [[ "$OS" == "ubuntu" ]]; then
    local packages=("nodejs" "npm" "portaudio19-dev" "ffmpeg" "cmake" "python3-dev" "libasound2-dev" "libasound2-plugins")
    local missing_packages=()

    for package in "${packages[@]}"; do
      if dpkg -l "$package" 2>/dev/null | grep -q '^ii'; then
        print_success "$package is already installed"
      else
        missing_packages+=("$package")
      fi
    done

    if [ ${#missing_packages[@]} -eq 0 ]; then
      print_success "All system dependencies are already installed"
      return 0
    else
      echo "Missing packages: ${missing_packages[*]}"
      return 1
    fi
  fi
}

install_system_dependencies() {
  if ! check_system_dependencies; then
    if [[ "$OS" == "macos" ]]; then
      if confirm_action "Install missing system dependencies via Homebrew"; then
        print_step "Installing system dependencies..."

        # Update Homebrew
        brew update

        # Install required packages
        local packages=("node" "portaudio" "ffmpeg" "cmake")

        for package in "${packages[@]}"; do
          if brew list "$package" >/dev/null 2>&1; then
            print_success "$package is already installed"
          else
            print_step "Installing $package..."
            brew install "$package"
            print_success "$package installed"
          fi
        done
      else
        print_warning "Skipping system dependencies. Voice Mode may not work properly without them."
      fi
    elif [[ "$OS" == "fedora" ]]; then
      if confirm_action "Install missing system dependencies via DNF"; then
        print_step "Installing system dependencies..."

        # Update package lists (ignore exit code as dnf check-update returns 100 when updates are available)
        sudo dnf check-update || true

        # Install required packages
        local packages=("nodejs" "portaudio-devel" "ffmpeg" "cmake" "python3-devel" "alsa-lib-devel")

        print_step "Installing packages: ${packages[*]}"
        sudo dnf install -y "${packages[@]}"
        print_success "System dependencies installed"
      else
        print_warning "Skipping system dependencies. Voice Mode may not work properly without them."
      fi
    elif [[ "$OS" == "ubuntu" ]]; then
      if confirm_action "Install missing system dependencies via APT"; then
        print_step "Installing system dependencies..."

        # Update package lists
        sudo apt update

        # Install required packages
        local packages=("nodejs" "npm" "portaudio19-dev" "ffmpeg" "cmake" "python3-dev" "libasound2-dev" "libasound2-plugins" "pulseaudio" "pulseaudio-utils")

        # Add WSL-specific packages if detected
        if [[ "$IS_WSL" == true ]]; then
          print_warning "WSL2 detected - installing additional audio packages"
          packages+=("libasound2-plugins" "pulseaudio")
        fi

        print_step "Installing packages: ${packages[*]}"
        sudo apt install -y "${packages[@]}"
        print_success "System dependencies installed"

        # WSL-specific audio setup
        if [[ "$IS_WSL" == true ]]; then
          print_step "Setting up WSL2 audio support..."

          # Start PulseAudio if not running
          if ! pgrep -x "pulseaudio" >/dev/null; then
            pulseaudio --start 2>/dev/null || true
            print_success "Started PulseAudio service"
          fi

          # Check audio devices
          if command -v pactl >/dev/null 2>&1; then
            if pactl list sources short 2>/dev/null | grep -q .; then
              print_success "Audio devices detected in WSL2"
            else
              print_warning "No audio devices detected. WSL2 audio setup may require:"
              echo "  1. Enable Windows microphone permissions for your terminal"
              echo "  2. Ensure WSL version is 2.3.26.0 or higher (run 'wsl --version')"
              echo "  3. See: https://github.com/mbailey/voicemode/blob/main/docs/troubleshooting/wsl2-microphone-access.md"
            fi
          fi
        fi
      else
        print_warning "Skipping system dependencies. Voice Mode may not work properly without them."
      fi
    fi
  fi
}

check_python() {
  print_step "Checking Python installation..."

  if command -v python3 >/dev/null 2>&1; then
    local python_version=$(python3 --version | cut -d' ' -f2)
    print_success "Python 3 found: $python_version"

    # Check if pip3 is available
    if command -v pip3 >/dev/null 2>&1; then
      print_success "pip3 is available"
    else
      print_error "pip3 not found. Please install pip for Python 3."
    fi
  else
    print_error "Python 3 not found. Please install Python 3 first."
  fi
}

install_uvx() {
  if ! command -v uvx >/dev/null 2>&1; then
    if confirm_action "Install UV/UVX (required for Voice Mode)"; then
      print_step "Installing UV/UVX..."

      # Install UV using the official installer
      curl -LsSf https://astral.sh/uv/install.sh | sh

      # Add UV to PATH for current session
      export PATH="$HOME/.local/bin:$PATH"

      # Add to shell profile if not already there
      local shell_profile=""
      if [[ "$SHELL" == *"zsh"* ]]; then
        shell_profile="$HOME/.zshrc"
      elif [[ "$SHELL" == *"bash"* ]]; then
        if [[ "$OS" == "macos" ]]; then
          shell_profile="$HOME/.bash_profile"
        else
          shell_profile="$HOME/.bashrc"
        fi
      fi

      if [ -n "$shell_profile" ] && [ -f "$shell_profile" ]; then
        if ! grep -q "\.local/bin" "$shell_profile"; then
          echo 'export PATH="$HOME/.local/bin:$PATH"' >>"$shell_profile"
          print_success "Added UV to PATH in $shell_profile"
        fi
      fi

      print_success "UV/UVX installed successfully"
    else
      print_error "UV/UVX is required for Voice Mode. Installation aborted."
      return 1
    fi
  else
    print_success "UV/UVX is already installed"
  fi
}

setup_local_npm() {
  print_step "Setting up local npm configuration..."

  # Set up npm to use local directory (no sudo required)
  mkdir -p "$HOME/.npm-global"
  npm config set prefix "$HOME/.npm-global"

  # Add to PATH for current session
  export PATH="$HOME/.npm-global/bin:$PATH"

  # Add to shell profile if not already there
  local shell_profile=""
  if [[ "$SHELL" == *"zsh"* ]]; then
    shell_profile="$HOME/.zshrc"
  elif [[ "$SHELL" == *"bash"* ]]; then
    shell_profile="$HOME/.bash_profile"
  fi

  if [ -n "$shell_profile" ] && [ -f "$shell_profile" ]; then
    if ! grep -q "\.npm-global/bin" "$shell_profile"; then
      echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >>"$shell_profile"
      print_success "Added npm global bin to PATH in $shell_profile"
    fi
  fi

  print_success "Local npm configuration complete"
}

configure_claude_voicemode() {
  if command -v claude >/dev/null 2>&1; then
    # Check if voice-mode is already configured
    if claude mcp list 2>/dev/null | grep -q "voice-mode"; then
      print_success "Voice Mode is already configured in Claude Code"
      echo ""
      echo "🎉 Setup complete! You can now use voice commands in Claude Code by running:"
      echo ""
      echo "  claude converse"
      echo ""
      echo "Voice Mode will automatically install local speech services if needed."
    else
      if confirm_action "Configure Voice Mode with Claude Code (adds MCP server)"; then
        print_step "Configuring Voice Mode with Claude Code..."

        # Try with --scope flag first (newer versions)
        if claude mcp add --scope user voice-mode -- uvx voice-mode 2>/dev/null; then
          print_success "Voice Mode configured with Claude Code"
          echo ""
          echo "🎉 Setup complete! You can now use voice commands in Claude Code:"
          echo "  claude converse"
          echo ""
          echo "Voice Mode will automatically install local speech services if needed."
        # Fallback to without --scope flag (older versions)
        elif claude mcp add voice-mode -- uvx voice-mode; then
          print_success "Voice Mode configured with Claude Code (global config)"
          echo ""
          echo "🎉 Setup complete! You can now use voice commands in Claude Code:"
          echo "  claude converse"
          echo ""
          echo "Voice Mode will automatically install local speech services if needed."
        else
          print_error "Failed to configure Voice Mode with Claude Code"
        fi
      else
        print_step "Skipping Voice Mode configuration"
        echo "You can configure it later with:"
        echo "  claude mcp add voice-mode -- uvx voice-mode"
      fi
    fi
  else
    print_warning "Claude Code not found. Please install it first to use Voice Mode."
  fi
}

install_claude_if_needed() {
  if ! command -v claude >/dev/null 2>&1; then
    if confirm_action "Install Claude Code (required for Voice Mode)"; then
      print_step "Installing Claude Code..."
      if command -v npm >/dev/null 2>&1; then
        npm install -g @anthropic-ai/claude-code
        print_success "Claude Code installed"
      else
        print_error "npm not found. Please install Node.js first."
        return 1
      fi
    else
      print_warning "Claude Code is required for Voice Mode. Skipping configuration."
      return 1
    fi
  fi
  return 0
}

main() {
  echo -e "${BLUE}🎤 Voice Mode Universal Installer${NC}"
  echo "This installer will set up Voice Mode and its dependencies on your system."
  echo ""

  # Pre-flight checks
  detect_os

  # OS-specific setup
  if [[ "$OS" == "macos" ]]; then
    check_homebrew
    # Skip Xcode tools check if Homebrew will handle it
    if [ "$HOMEBREW_INSTALLED" = false ]; then
      install_homebrew # This installs Xcode tools automatically
    fi
  fi

  check_python
  install_uvx

  # Install dependencies
  install_system_dependencies

  # Setup npm for non-macOS systems
  if [[ "$OS" != "macos" ]]; then
    setup_local_npm
  fi

  # Install Claude Code if needed, then configure Voice Mode
  if install_claude_if_needed; then
    configure_claude_voicemode
  fi

  # WSL-specific instructions
  if [[ "$IS_WSL" == true ]]; then
    echo ""
    echo -e "${YELLOW}WSL2 Audio Setup:${NC}"
    echo "Voice Mode requires microphone access in WSL2. If you encounter audio issues:"
    echo "  1. Enable Windows microphone permissions for your terminal app"
    echo "  2. Ensure PulseAudio is running: pulseaudio --start"
    echo "  3. Test audio devices: python3 -m sounddevice"
    echo "  4. See troubleshooting guide: https://github.com/mbailey/voicemode/blob/main/docs/troubleshooting/wsl2-microphone-access.md"
  fi

  echo ""
  echo "For more information, visit: https://github.com/mbailey/voicemode"
}

# Run main function
main "$@"
