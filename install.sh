#!/bin/bash

# Install catalog-importer with multi-header authentication support
# Usage: curl -fsSL https://raw.githubusercontent.com/magzbaxter/catalog-importer/maggie-backstage/install.sh | bash

set -e

# Determine OS and architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case $ARCH in
    x86_64) ARCH="amd64" ;;
    arm64|aarch64) ARCH="arm64" ;;
    *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

case $OS in
    darwin) OS="darwin" ;;
    linux) OS="linux" ;;
    *) echo "Unsupported OS: $OS"; exit 1 ;;
esac

echo "Installing catalog-importer with multi-header authentication support..."
echo "OS: $OS, Architecture: $ARCH"

# Create temporary directory
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

# Clone and build
echo "Downloading source..."
git clone --depth 1 --branch maggie-backstage https://github.com/magzbaxter/catalog-importer.git
cd catalog-importer

echo "Building catalog-importer..."
go build -o catalog-importer ./cmd/catalog-importer

# Install to /usr/local/bin (or ~/bin if no permissions)
INSTALL_DIR="/usr/local/bin"
if [ ! -w "$INSTALL_DIR" ]; then
    INSTALL_DIR="$HOME/bin"
    mkdir -p "$INSTALL_DIR"
    echo "Installing to $INSTALL_DIR (add to PATH if needed)"
else
    echo "Installing to $INSTALL_DIR"
fi

cp catalog-importer "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/catalog-importer"

# Cleanup
cd /
rm -rf "$TMP_DIR"

echo "✅ catalog-importer installed successfully!"
echo "🔧 This version supports multi-header authentication for Backstage"
echo ""
echo "Usage:"
echo "  catalog-importer sync --config=your-config.jsonnet"
echo ""
echo "Example config with multi-header auth:"
echo "  {" 
echo "    backstage: {"
echo "      endpoint: 'https://backstage.company.com/api/catalog/entities/by-query',"
echo "      headers: {"
echo "        'Authorization': 'Bearer \$(BACKSTAGE_TOKEN)',"
echo "        'Cookie': '\$(COOKIE_VALUE)',"
echo "      },"
echo "    },"
echo "  }"
echo ""
echo "Set environment variables:"
echo "  export BACKSTAGE_TOKEN='your-token'"
echo "  export COOKIE_VALUE='session=abc123; auth=xyz789'"