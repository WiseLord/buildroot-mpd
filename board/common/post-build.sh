#!/bin/sh

# Run mpd earlier
if [ -f "${TARGET_DIR}/etc/init.d/S95mpd" ]; then
    mv -f "${TARGET_DIR}/etc/init.d/S95mpd" "${TARGET_DIR}/etc/init.d/S35mpd"
fi

# Optimize database size by limiting stored audio metadata
if ! grep -q "# Metadata stored in database" "${TARGET_DIR}/etc/mpd.conf"; then
    cat << EOF >> "${TARGET_DIR}/etc/mpd.conf"

# Metadata stored in database
metadata_to_use        "artist,album,title,track,name,genre,date"
EOF
fi
