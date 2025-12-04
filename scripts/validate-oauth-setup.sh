#!/bin/bash
# Validation script to check OAuth token setup in Dev Containers

set -e

echo "🔍 Validating OAuth Token Setup"
echo "================================"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_info() { echo -e "${BLUE}ℹ${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }

# Check if running inside a Dev Container
if [ -n "$REMOTE_CONTAINERS" ] || [ -n "$CODESPACES" ]; then
    print_success "Running inside a Dev Container or Codespace"
    INSIDE_CONTAINER=true
else
    print_info "Running on host machine (not in Dev Container)"
    INSIDE_CONTAINER=false
fi

echo ""
echo "Environment Variables Check:"
echo "----------------------------"

# Check CLAUDE_CODE_OAUTH_TOKEN
if [ -n "$CLAUDE_CODE_OAUTH_TOKEN" ]; then
    # Show only first and last 4 characters for security
    TOKEN_PREFIX="${CLAUDE_CODE_OAUTH_TOKEN:0:4}"
    TOKEN_SUFFIX="${CLAUDE_CODE_OAUTH_TOKEN: -4}"
    print_success "CLAUDE_CODE_OAUTH_TOKEN: ${TOKEN_PREFIX}...${TOKEN_SUFFIX}"
else
    print_error "CLAUDE_CODE_OAUTH_TOKEN: Not set"
fi

# Check ANTHROPIC_API_KEY
if [ -n "$ANTHROPIC_API_KEY" ]; then
    KEY_PREFIX="${ANTHROPIC_API_KEY:0:7}"
    KEY_SUFFIX="${ANTHROPIC_API_KEY: -4}"
    print_success "ANTHROPIC_API_KEY: ${KEY_PREFIX}...${KEY_SUFFIX}"
else
    print_error "ANTHROPIC_API_KEY: Not set"
fi

# Check optional AWS credentials
echo ""
echo "Optional AWS Credentials:"
echo "-------------------------"

if [ -n "$AWS_ACCESS_KEY_ID" ]; then
    print_success "AWS_ACCESS_KEY_ID: Set"
else
    print_info "AWS_ACCESS_KEY_ID: Not set (optional)"
fi

if [ -n "$AWS_SECRET_ACCESS_KEY" ]; then
    print_success "AWS_SECRET_ACCESS_KEY: Set"
else
    print_info "AWS_SECRET_ACCESS_KEY: Not set (optional)"
fi

if [ -n "$AWS_SESSION_TOKEN" ]; then
    print_success "AWS_SESSION_TOKEN: Set"
else
    print_info "AWS_SESSION_TOKEN: Not set (optional)"
fi

# Check .env files
echo ""
echo ".env Files Check:"
echo "-----------------"

for env_file in .env .env.local; do
    if [ -f "$env_file" ]; then
        print_success "Found: $env_file"

        # Check if it contains tokens (without showing values)
        if grep -q "CLAUDE_CODE_OAUTH_TOKEN" "$env_file"; then
            print_info "  - Contains CLAUDE_CODE_OAUTH_TOKEN"
        fi
        if grep -q "ANTHROPIC_API_KEY" "$env_file"; then
            print_info "  - Contains ANTHROPIC_API_KEY"
        fi
    else
        print_info "$env_file: Not found (using environment variables instead)"
    fi
done

# Check .gitignore
echo ""
echo "Security Check:"
echo "---------------"

if [ -f ".gitignore" ]; then
    if grep -q "\.env" ".gitignore"; then
        print_success ".env files are in .gitignore"
    else
        print_warning ".env files NOT in .gitignore - please add them!"
    fi
else
    print_warning "No .gitignore found"
fi

# Check devcontainer configuration
echo ""
echo "Dev Container Configuration:"
echo "----------------------------"

if [ -f ".devcontainer/devcontainer.json" ]; then
    print_success "Found .devcontainer/devcontainer.json"

    if grep -q "CLAUDE_CODE_OAUTH_TOKEN" ".devcontainer/devcontainer.json"; then
        print_success "CLAUDE_CODE_OAUTH_TOKEN referenced in devcontainer"
    else
        print_warning "CLAUDE_CODE_OAUTH_TOKEN not found in devcontainer.json"
    fi

    if grep -q "ANTHROPIC_API_KEY" ".devcontainer/devcontainer.json"; then
        print_success "ANTHROPIC_API_KEY referenced in devcontainer"
    else
        print_warning "ANTHROPIC_API_KEY not found in devcontainer.json"
    fi
else
    print_info "No devcontainer.json in current directory"
fi

# Test API connectivity (if inside container and API key is set)
if [ "$INSIDE_CONTAINER" = true ] && [ -n "$ANTHROPIC_API_KEY" ]; then
    echo ""
    echo "API Connectivity Test:"
    echo "----------------------"

    # Check if curl is available
    if command -v curl &> /dev/null; then
        print_info "Testing Anthropic API connection..."

        RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
            -H "x-api-key: $ANTHROPIC_API_KEY" \
            -H "anthropic-version: 2023-06-01" \
            https://api.anthropic.com/v1/messages 2>&1 || echo "000")

        if [ "$RESPONSE" = "400" ] || [ "$RESPONSE" = "401" ]; then
            # 400 means API key format is valid but request is incomplete (expected)
            # 401 means invalid API key
            if [ "$RESPONSE" = "400" ]; then
                print_success "API connection successful (API key is valid)"
            else
                print_error "API authentication failed (check your API key)"
            fi
        elif [ "$RESPONSE" = "000" ]; then
            print_warning "Could not connect to API (check internet connection)"
        else
            print_info "API returned status: $RESPONSE"
        fi
    else
        print_info "curl not available, skipping API test"
    fi
fi

# Summary
echo ""
echo "Summary:"
echo "--------"

ERRORS=0
WARNINGS=0

if [ -z "$CLAUDE_CODE_OAUTH_TOKEN" ]; then
    ((ERRORS++))
fi

if [ -z "$ANTHROPIC_API_KEY" ]; then
    ((ERRORS++))
fi

if [ -f ".env" ] || [ -f ".env.local" ]; then
    if [ -f ".gitignore" ]; then
        if ! grep -q "\.env" ".gitignore"; then
            ((WARNINGS++))
        fi
    else
        ((WARNINGS++))
    fi
fi

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    print_success "All checks passed! Your OAuth setup is complete."
elif [ $ERRORS -eq 0 ]; then
    print_warning "$WARNINGS warning(s) found. Please review above."
else
    print_error "$ERRORS error(s) and $WARNINGS warning(s) found."
    echo ""
    echo "To fix errors, run:"
    echo "  ./scripts/setup-devcontainer-oauth.sh"
fi

echo ""
