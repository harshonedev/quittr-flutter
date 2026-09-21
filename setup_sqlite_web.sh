#!/bin/bash

echo "Setting up SQLite for web..."

# Use pub cache path
PUB_CACHE="${HOME}/.pub-cache"
echo "Looking in pub cache: ${PUB_CACHE}"

# Find the sqflite_common_ffi_web directory in hosted packages
PACKAGE_DIR=$(find "${PUB_CACHE}/hosted/pub.dev" -type d -name "sqflite_common_ffi_web-*" | sort -V | tail -1)

if [ -z "$PACKAGE_DIR" ]; then
  echo "Error: sqflite_common_ffi_web package not found in pub cache!"
  echo "Make sure you've run 'flutter pub get' to download the package."
  exit 1
fi

echo "Found package at: $PACKAGE_DIR"

# Create the destination directory
mkdir -p web/assets/packages/sqflite_common_ffi_web

# Check if the assets directory exists
if [ ! -d "$PACKAGE_DIR/assets" ]; then
  echo "Error: assets directory not found in the package!"
  echo "Expected at: $PACKAGE_DIR/assets"
  
  # Try alternative: look for .js files directly
  JS_FILES=$(find "$PACKAGE_DIR" -name "*.js" | grep -i "sqflite")
  
  if [ -n "$JS_FILES" ]; then
    echo "Found JS files directly in package. Copying them..."
    for file in $JS_FILES; do
      cp "$file" web/assets/packages/sqflite_common_ffi_web/
      echo "Copied: $(basename "$file")"
    done
  else
    echo "No SQLite JS files found in the package!"
    exit 1
  fi
else
  # Copy the SQLite wasm files
  echo "Copying SQLite web worker files from assets directory..."
  cp -r $PACKAGE_DIR/assets/* web/assets/packages/sqflite_common_ffi_web/
fi

echo "Successfully copied SQLite web files to your project."
echo "Make sure your index.html and Flutter code are properly configured!"
