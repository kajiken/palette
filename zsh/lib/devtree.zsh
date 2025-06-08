# devtree - Git worktree and devcontainer integration
# Provides seamless development environment management combining git worktree and devcontainers

# Environment variables with defaults
DEVTREE_DEFAULT_PATH="${DEVTREE_DEFAULT_PATH:-./}"
DEVTREE_AUTO_OPEN="${DEVTREE_AUTO_OPEN:-false}"
DEVTREE_CONTAINER_RUNTIME="${DEVTREE_CONTAINER_RUNTIME:-docker}"
DEVTREE_LOG_DIR="${DEVTREE_LOG_DIR:-$HOME/.devtree/logs}"

# Load configuration files
_devtree_load_config() {
    # Load global config from ~/.devtreerc
    if [[ -f "$HOME/.devtreerc" ]]; then
        source "$HOME/.devtreerc"
    fi
}

# Logging function
_devtree_log() {
    local level="$1"
    local message="$2"
    
    # Create log directory if it doesn't exist
    mkdir -p "$DEVTREE_LOG_DIR"
    
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local log_file="$DEVTREE_LOG_DIR/devtree.log"
    
    echo "[$timestamp] [$level] $message" >> "$log_file"
}

# Verbose logging function
_devtree_verbose_log() {
    local message="$1"
    
    if [[ "$DEVTREE_VERBOSE" == "true" ]]; then
        echo "DEBUG: $message"
    fi
    
    _devtree_log "DEBUG" "$message"
}

# Main devtree function
devtree() {
    # Load configuration
    _devtree_load_config
    
    local subcommand="$1"
    
    # Log command execution
    _devtree_log "INFO" "Command executed: devtree $*"
    
    case "$subcommand" in
        create)
            shift
            _devtree_create "$@"
            ;;
        up)
            shift
            _devtree_up "$@"
            ;;
        list)
            shift
            _devtree_list "$@"
            ;;
        remove)
            shift
            _devtree_remove "$@"
            ;;
        config)
            shift
            _devtree_config "$@"
            ;;
        help|--help|-h)
            _devtree_help
            ;;
        *)
            echo "devtree: unknown subcommand: $subcommand"
            echo "Try 'devtree help' for more information."
            return 1
            ;;
    esac
}

# Helper function to check if we're in a git repository
_devtree_check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "Error: Not in a git repository"
        return 1
    fi
}

# Helper function to check if devcontainer CLI is available
_devtree_check_devcontainer_cli() {
    if ! command -v devcontainer > /dev/null 2>&1; then
        echo "Error: devcontainer CLI not found. Install with 'npm install -g @devcontainers/cli'"
        return 1
    fi
}

# Helper function to check if container runtime is available
_devtree_check_container_runtime() {
    if ! command -v "$DEVTREE_CONTAINER_RUNTIME" > /dev/null 2>&1; then
        echo "Error: Container runtime '$DEVTREE_CONTAINER_RUNTIME' not found"
        return 1
    fi
    
    if ! "$DEVTREE_CONTAINER_RUNTIME" ps > /dev/null 2>&1; then
        echo "Error: Container runtime '$DEVTREE_CONTAINER_RUNTIME' is not running"
        return 1
    fi
}

# Helper function to check if .devcontainer/devcontainer.json exists
_devtree_check_devcontainer_config() {
    local path="$1"
    if [[ ! -f "$path/.devcontainer/devcontainer.json" ]]; then
        echo "Error: .devcontainer/devcontainer.json not found in $path"
        return 1
    fi
}

# Subcommand implementations
_devtree_create() {
    local branch_name=""
    local worktree_path=""
    local from_branch=""
    local code_flag=false
    local verbose_flag=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --from)
                from_branch="$2"
                shift 2
                ;;
            --code)
                code_flag=true
                shift
                ;;
            --verbose)
                verbose_flag=true
                DEVTREE_VERBOSE="true"
                shift
                ;;
            *)
                if [[ -z "$branch_name" ]]; then
                    branch_name="$1"
                elif [[ -z "$worktree_path" ]]; then
                    worktree_path="$1"
                else
                    echo "Error: Unexpected argument: $1"
                    return 1
                fi
                shift
                ;;
        esac
    done
    
    # Validate required arguments
    if [[ -z "$branch_name" ]]; then
        echo "Error: Branch name is required"
        echo "Usage: devtree create <branch-name> [path] [--from <base-branch>] [--code]"
        return 1
    fi
    
    # Set default path if not provided
    if [[ -z "$worktree_path" ]]; then
        worktree_path="$DEVTREE_DEFAULT_PATH/$branch_name"
    fi
    
    # Run prerequisite checks
    _devtree_check_git_repo || return 1
    _devtree_check_devcontainer_cli || return 1
    _devtree_check_container_runtime || return 1
    
    # Get current branch if from_branch not specified
    if [[ -z "$from_branch" ]]; then
        from_branch=$(git branch --show-current)
        if [[ -z "$from_branch" ]]; then
            echo "Error: Could not determine current branch and --from not specified"
            return 1
        fi
    fi
    
    # Check if target path already exists
    if [[ -e "$worktree_path" ]]; then
        echo "Error: Path already exists: $worktree_path"
        return 1
    fi
    
    # Check if branch already exists
    if git show-ref --verify --quiet "refs/heads/$branch_name"; then
        echo "Error: Branch already exists: $branch_name"
        return 1
    fi
    
    _devtree_verbose_log "Creating worktree '$branch_name' at '$worktree_path' from '$from_branch'"
    echo "Creating worktree '$branch_name' at '$worktree_path' from '$from_branch'..."
    
    # Create worktree
    if ! git worktree add -b "$branch_name" "$worktree_path" "$from_branch"; then
        _devtree_log "ERROR" "Failed to create worktree: $branch_name at $worktree_path"
        echo "Error: Failed to create worktree"
        return 1
    fi
    
    _devtree_log "INFO" "Successfully created worktree: $branch_name at $worktree_path"
    
    # Check for devcontainer configuration
    if ! _devtree_check_devcontainer_config "$worktree_path"; then
        echo "Warning: No devcontainer configuration found, but worktree created successfully"
        return 0
    fi
    
    _devtree_verbose_log "Starting devcontainer in '$worktree_path'"
    echo "Starting devcontainer in '$worktree_path'..."
    
    # Start devcontainer
    if ! (cd "$worktree_path" && devcontainer up --workspace-folder .); then
        _devtree_log "ERROR" "Failed to start devcontainer at $worktree_path"
        echo "Error: Failed to start devcontainer"
        echo "Worktree created at '$worktree_path' but devcontainer failed to start"
        read "response?Remove the worktree? [y/N]: "
        if [[ "$response" =~ ^[Yy]$ ]]; then
            git worktree remove "$worktree_path" 2>/dev/null || rm -rf "$worktree_path"
            _devtree_log "INFO" "Removed worktree after devcontainer failure: $worktree_path"
            echo "Worktree removed"
        fi
        return 1
    fi
    
    _devtree_log "INFO" "Successfully created worktree and started devcontainer at $worktree_path"
    echo "Successfully created worktree and started devcontainer at '$worktree_path'"
    
    # Auto-open VSCode if requested or configured
    if [[ "$code_flag" == true ]] || [[ "$DEVTREE_AUTO_OPEN" == "true" ]]; then
        if command -v code > /dev/null 2>&1; then
            echo "Opening VSCode..."
            code "$worktree_path"
        else
            echo "Warning: VSCode not found in PATH"
        fi
    fi
    
    return 0
}

_devtree_up() {
    local worktree_path="."
    local code_flag=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --code)
                code_flag=true
                shift
                ;;
            --verbose)
                DEVTREE_VERBOSE="true"
                shift
                ;;
            *)
                if [[ "$worktree_path" == "." ]]; then
                    worktree_path="$1"
                else
                    echo "Error: Unexpected argument: $1"
                    return 1
                fi
                shift
                ;;
        esac
    done
    
    # Convert to absolute path
    worktree_path=$(cd "$worktree_path" 2>/dev/null && pwd)
    if [[ $? -ne 0 ]]; then
        echo "Error: Path does not exist: $1"
        return 1
    fi
    
    # Run prerequisite checks
    _devtree_check_devcontainer_cli || return 1
    _devtree_check_container_runtime || return 1
    _devtree_check_devcontainer_config "$worktree_path" || return 1
    
    # Check if we're in a git worktree
    if ! (cd "$worktree_path" && git rev-parse --git-dir > /dev/null 2>&1); then
        echo "Error: '$worktree_path' is not a git repository or worktree"
        return 1
    fi
    
    echo "Starting devcontainer in '$worktree_path'..."
    
    # Start devcontainer
    if ! (cd "$worktree_path" && devcontainer up --workspace-folder .); then
        echo "Error: Failed to start devcontainer"
        return 1
    fi
    
    echo "Successfully started devcontainer at '$worktree_path'"
    
    # Auto-open VSCode if requested or configured
    if [[ "$code_flag" == true ]] || [[ "$DEVTREE_AUTO_OPEN" == "true" ]]; then
        if command -v code > /dev/null 2>&1; then
            echo "Opening VSCode..."
            code "$worktree_path"
        else
            echo "Warning: VSCode not found in PATH"
        fi
    fi
    
    return 0
}

_devtree_list() {
    local show_status=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --status)
                show_status=true
                shift
                ;;
            *)
                echo "Error: Unexpected argument: $1"
                return 1
                ;;
        esac
    done
    
    # Check if we're in a git repository
    _devtree_check_git_repo || return 1
    
    # Get worktree list
    local worktrees
    if ! worktrees=$(git worktree list --porcelain 2>/dev/null); then
        echo "Error: Failed to get worktree list"
        return 1
    fi
    
    if [[ -z "$worktrees" ]]; then
        echo "No worktrees found"
        return 0
    fi
    
    echo "Git Worktrees:"
    echo "=============="
    
    # Parse worktree list output
    local current_worktree=""
    local current_path=""
    local current_branch=""
    local current_head=""
    
    while IFS= read -r line; do
        case "$line" in
            worktree\ *)
                if [[ -n "$current_path" ]]; then
                    _devtree_print_worktree_info "$current_path" "$current_branch" "$current_head" "$show_status"
                fi
                current_path="${line#worktree }"
                current_branch=""
                current_head=""
                ;;
            HEAD\ *)
                current_head="${line#HEAD }"
                ;;
            branch\ *)
                current_branch="${line#branch refs/heads/}"
                ;;
            detached)
                current_branch="(detached)"
                ;;
        esac
    done <<< "$worktrees"
    
    # Print the last worktree
    if [[ -n "$current_path" ]]; then
        _devtree_print_worktree_info "$current_path" "$current_branch" "$current_head" "$show_status"
    fi
}

# Helper function to print worktree information
_devtree_print_worktree_info() {
    local path="$1"
    local branch="$2"
    local head="$3"
    local show_status="$4"
    
    local status_info=""
    
    if [[ "$show_status" == true ]]; then
        # Check devcontainer status
        if [[ -f "$path/.devcontainer/devcontainer.json" ]]; then
            # Try to determine if devcontainer is running
            # This is a simplified check - a more robust implementation would query docker/podman
            local container_name
            container_name=$(cd "$path" 2>/dev/null && devcontainer exec --workspace-folder . echo "running" 2>/dev/null)
            if [[ $? -eq 0 ]] && [[ -n "$container_name" ]]; then
                status_info="[devcontainer: running]"
            else
                status_info="[devcontainer: stopped]"
            fi
        else
            status_info="[no devcontainer config]"
        fi
    fi
    
    # Format output
    local branch_display="${branch:-"(unknown)"}"
    if [[ "$branch_display" == "(detached)" ]]; then
        branch_display="(detached at ${head:0:8})"
    fi
    
    printf "  %-40s %-25s %s\n" "$path" "$branch_display" "$status_info"
}

_devtree_remove() {
    local worktree_path=""
    local force=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --force)
                force=true
                shift
                ;;
            --verbose)
                DEVTREE_VERBOSE="true"
                shift
                ;;
            *)
                if [[ -z "$worktree_path" ]]; then
                    worktree_path="$1"
                else
                    echo "Error: Unexpected argument: $1"
                    return 1
                fi
                shift
                ;;
        esac
    done
    
    # Validate required arguments
    if [[ -z "$worktree_path" ]]; then
        echo "Error: Path is required"
        echo "Usage: devtree remove <path> [--force]"
        return 1
    fi
    
    # Convert to absolute path and validate
    if [[ ! -d "$worktree_path" ]]; then
        echo "Error: Path does not exist: $worktree_path"
        return 1
    fi
    
    worktree_path=$(cd "$worktree_path" && pwd)
    
    # Check if we're in a git repository
    _devtree_check_git_repo || return 1
    
    # Check if the path is actually a git worktree
    if ! (cd "$worktree_path" && git rev-parse --git-dir > /dev/null 2>&1); then
        echo "Error: '$worktree_path' is not a git repository or worktree"
        return 1
    fi
    
    # Check if this is the main worktree
    local main_worktree
    main_worktree=$(git rev-parse --show-toplevel 2>/dev/null)
    if [[ "$worktree_path" == "$main_worktree" ]]; then
        echo "Error: Cannot remove the main worktree: $worktree_path"
        return 1
    fi
    
    # Get branch name if available
    local branch_name
    branch_name=$(cd "$worktree_path" && git branch --show-current 2>/dev/null)
    
    # Confirmation prompt unless --force is used
    if [[ "$force" != true ]]; then
        echo "This will remove the worktree at: $worktree_path"
        if [[ -n "$branch_name" ]]; then
            echo "Branch: $branch_name"
        fi
        
        # Check if there are uncommitted changes
        if (cd "$worktree_path" && ! git diff --quiet 2>/dev/null) || (cd "$worktree_path" && ! git diff --cached --quiet 2>/dev/null); then
            echo "WARNING: There are uncommitted changes in this worktree!"
        fi
        
        read "response?Are you sure you want to proceed? [y/N]: "
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            echo "Cancelled"
            return 0
        fi
    fi
    
    # Stop devcontainer if it's running
    if [[ -f "$worktree_path/.devcontainer/devcontainer.json" ]]; then
        echo "Stopping devcontainer..."
        if command -v devcontainer > /dev/null 2>&1; then
            (cd "$worktree_path" && devcontainer down --workspace-folder . 2>/dev/null) || true
        fi
        
        # Additional cleanup: try to remove any running containers
        # This is a best-effort cleanup
        if command -v "$DEVTREE_CONTAINER_RUNTIME" > /dev/null 2>&1; then
            local container_id
            container_id=$("$DEVTREE_CONTAINER_RUNTIME" ps -q --filter "label=devcontainer.local_folder=$worktree_path" 2>/dev/null | head -1)
            if [[ -n "$container_id" ]]; then
                echo "Removing container: $container_id"
                "$DEVTREE_CONTAINER_RUNTIME" rm -f "$container_id" 2>/dev/null || true
            fi
        fi
    fi
    
    echo "Removing worktree: $worktree_path"
    
    # Remove the worktree
    if ! git worktree remove "$worktree_path" 2>/dev/null; then
        # If git worktree remove fails, try force removal
        echo "Git worktree remove failed, attempting force removal..."
        if ! git worktree remove --force "$worktree_path" 2>/dev/null; then
            echo "Git worktree remove --force failed, manually removing directory..."
            rm -rf "$worktree_path"
        fi
    fi
    
    # Optionally delete the branch if it only exists in this worktree
    if [[ -n "$branch_name" ]] && [[ "$force" != true ]]; then
        # Check if branch exists in other worktrees or remotes
        local branch_refs
        branch_refs=$(git for-each-ref --format='%(refname)' --glob="refs/heads/$branch_name" --glob="refs/remotes/*/$branch_name" 2>/dev/null | wc -l)
        
        if [[ "$branch_refs" -eq 1 ]]; then
            read "response?Delete the branch '$branch_name' as well? [y/N]: "
            if [[ "$response" =~ ^[Yy]$ ]]; then
                git branch -D "$branch_name" 2>/dev/null || true
                echo "Branch '$branch_name' deleted"
            fi
        fi
    elif [[ -n "$branch_name" ]] && [[ "$force" == true ]]; then
        # In force mode, delete local branch if it's not on any remote
        if ! git ls-remote --heads origin "$branch_name" > /dev/null 2>&1; then
            git branch -D "$branch_name" 2>/dev/null || true
            echo "Branch '$branch_name' deleted"
        fi
    fi
    
    echo "Successfully removed worktree: $worktree_path"
    return 0
}

# Config subcommand implementation
_devtree_config() {
    local action="$1"
    
    case "$action" in
        init)
            shift
            _devtree_config_init "$@"
            ;;
        show)
            _devtree_config_show
            ;;
        *)
            echo "Error: Unknown config action: $action"
            echo "Usage: devtree config <init|show>"
            return 1
            ;;
    esac
}

# Initialize .devtreerc configuration file
_devtree_config_init() {
    local force=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --force)
                force=true
                shift
                ;;
            *)
                echo "Error: Unexpected argument: $1"
                echo "Usage: devtree config init [--force]"
                return 1
                ;;
        esac
    done
    
    local config_file="$HOME/.devtreerc"
    
    # Check if file already exists
    if [[ -f "$config_file" ]] && [[ "$force" != true ]]; then
        echo "Configuration file already exists: $config_file"
        echo "Use --force to overwrite"
        return 1
    fi
    
    # Create configuration file
    cat > "$config_file" << 'EOF'
# devtree global configuration
# This file is sourced by the devtree function

# Default path for creating worktrees (relative to project root)
export DEVTREE_DEFAULT_PATH="$HOME/.devtree/worktrees"

# Auto-open VSCode when starting devcontainers (true/false)
export DEVTREE_AUTO_OPEN="false"

# Container runtime to use (docker/podman)
export DEVTREE_CONTAINER_RUNTIME="docker"

# Log directory for devtree operations
export DEVTREE_LOG_DIR="$HOME/.devtree/logs"

# Additional custom settings can be added below
# Example:
# export DEVTREE_VERBOSE="true"
EOF

    if [[ $? -eq 0 ]]; then
        echo "Configuration file created: $config_file"
        echo "Edit this file to customize devtree behavior globally."
        _devtree_log "INFO" "Configuration file created: $config_file"
    else
        echo "Error: Failed to create configuration file"
        return 1
    fi
}

# Show current configuration
_devtree_config_show() {
    echo "Current devtree configuration:"
    echo "=============================="
    echo "DEVTREE_DEFAULT_PATH      = $DEVTREE_DEFAULT_PATH"
    echo "DEVTREE_AUTO_OPEN         = $DEVTREE_AUTO_OPEN"
    echo "DEVTREE_CONTAINER_RUNTIME = $DEVTREE_CONTAINER_RUNTIME"
    echo "DEVTREE_LOG_DIR          = $DEVTREE_LOG_DIR"
    echo "DEVTREE_VERBOSE          = ${DEVTREE_VERBOSE:-false}"
    echo ""
    
    local config_file="$HOME/.devtreerc"
    if [[ -f "$config_file" ]]; then
        echo "Configuration file: $config_file (exists)"
    else
        echo "Configuration file: $config_file (not found)"
        echo "Run 'devtree config init' to create it."
    fi
}

# Help function
_devtree_help() {
    cat << EOF
devtree - Git worktree and devcontainer integration

USAGE:
    devtree <subcommand> [options]

SUBCOMMANDS:
    create <branch-name> [path] [--from <base-branch>] [--code] [--verbose]
        Create new worktree and start devcontainer
        Options:
          --from <branch>  Base branch for new worktree (default: current branch)
          --code          Auto-open VSCode after creation
          --verbose       Enable verbose logging output
        
    up [path] [--code] [--verbose]
        Start devcontainer in existing worktree
        Options:
          --code          Auto-open VSCode after startup
          --verbose       Enable verbose logging output
        
    list [--status]
        List worktrees and devcontainer status
        Options:
          --status        Show devcontainer running status
        
    remove <path> [--force] [--verbose]
        Remove worktree and devcontainer
        Options:
          --force         Skip confirmation prompts
          --verbose       Enable verbose logging output
          
    config <init|show> [options]
        Manage devtree configuration
        Actions:
          init [--force]  Create ~/.devtreerc configuration file
          show           Display current configuration
        
    help
        Show this help message

ENVIRONMENT VARIABLES:
    DEVTREE_DEFAULT_PATH      Default path for worktrees (default: ./)
    DEVTREE_AUTO_OPEN         Auto-open VSCode (default: false)
    DEVTREE_CONTAINER_RUNTIME Container runtime (default: docker)
    DEVTREE_LOG_DIR          Log directory (default: ~/.devtree/logs)
    DEVTREE_VERBOSE          Enable verbose output (set by --verbose)

CONFIGURATION:
    ~/.devtreerc             Global configuration file (shell script)
                             Create with: devtree config init

EXAMPLES:
    # Initialize configuration file
    devtree config init
    
    # Show current configuration
    devtree config show
    
    # Create new feature branch with worktree and devcontainer
    devtree create feature/new-api
    
    # Create in specific path from main branch and open VSCode
    devtree create hotfix/urgent ../hotfixes/urgent --from main --code
    
    # Start devcontainer in existing worktree
    devtree up ../worktrees/feature-xyz
    
    # List all worktrees with devcontainer status
    devtree list --status
    
    # Remove worktree and cleanup (with confirmation)
    devtree remove ../worktrees/old-feature
    
    # Force remove without confirmation
    devtree remove ../worktrees/old-feature --force

DEPENDENCIES:
    - git command
    - devcontainer CLI (npm install -g @devcontainers/cli)
    - docker or podman

For more information, see the project documentation.
EOF
}
