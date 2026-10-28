#!/usr/bin/env bash
set -eu

TARGET_DEVICE="${TARGET_DEVICE:-${WORK_DIR:-}}"
SOURCE_FIRMWARE="${SOURCE_FIRMWARE:-}"

TARGET_DEVICE="${TARGET_DEVICE##*/}"
TARGET_DEVICE="${TARGET_DEVICE,,}"
SOURCE_FIRMWARE="${SOURCE_FIRMWARE,,}"

echo "Checking firmware target compatibility..."
echo "  target: ${TARGET_DEVICE:-unknown}"
echo "  source: ${SOURCE_FIRMWARE:-unknown}"

case "$TARGET_DEVICE" in
  c1s|c1s*|note20|note20*|n980|n981|n985|n986)
    if [[ "$SOURCE_FIRMWARE" == *"s947b"* ]] || \
       [[ "$SOURCE_FIRMWARE" == *"s947"* ]] || \
       [[ "$SOURCE_FIRMWARE" == *"s26"* ]] || \
       [[ "$SOURCE_FIRMWARE" == *"bp4a"* ]]; then
        echo
        echo "ERROR: Firmware mismatch detected."
        echo "  Target device: c1s / Note20"
        echo "  Source firmware: ${SOURCE_FIRMWARE}"
        echo "  Invalid donor: S947B / S26+ / BP4A family"
        echo
        echo "Permanent fix:"
        echo "  Use a donor firmware from the Note20/c1s family."
        echo "  Do not use S947B/S26+ donor firmware for c1s."
        exit 1
    fi
    ;;
esac

echo "Firmware target check passed."
