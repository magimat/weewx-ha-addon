#!/usr/bin/with-contenv bashio

# --- Initial configuration setup ---

# Define the source paths for default files and folders
DEFAULT_CONFIG_FILE="/default_config/weewx.conf"
DEFAULT_ASSETS_DIR="/default_config/skins/"

# Define the destination paths in the persistent /config volume
CONFIG_FILE="/config/weewx.conf"
ASSETS_DIR="/config/skins/"

# Check for and copy the default config file if it doesn't exist
if [ ! -f "$CONFIG_FILE" ]; then
    bashio::log.info "No config file found. Copying default config..."
    cp "$DEFAULT_CONFIG_FILE" "$CONFIG_FILE"
else
    bashio::log.info "Config file already exists. Skipping copy."
fi

# Check for and copy the default assets directory if it doesn't exist or is empty
if [ ! -d "$ASSETS_DIR" ] || [ -z "$(ls -A "$ASSETS_DIR")" ]; then
    bashio::log.info "Assets directory is missing or empty. Copying default assets..."
    # Ensure the destination directory exists
    mkdir -p "$ASSETS_DIR"
    # Copy the contents of the source directory recursively
    cp -R "$DEFAULT_ASSETS_DIR." "$ASSETS_DIR"
else
    bashio::log.info "Assets directory already exists. Skipping copy of default assets."
fi

