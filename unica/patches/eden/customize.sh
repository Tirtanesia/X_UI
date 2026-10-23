#!/usr/bin/env bash
# Skip for beyond targets
case "${TARGET_CODENAME}" in
  beyond*)
    [ -n "${LOG:-}" ] && LOG "- Skipping eden patches for $TARGET_CODENAME" || true
    return 0
    ;;
esac
LOG_STEP_IN "- Fixing EDEN debug logging"

VENDOR_BUILD_PROP="$WORK_DIR/vendor/build.prop"
if [ -f "$VENDOR_BUILD_PROP" ]; then
    [ -n "${LOG:-}" ] && LOG "- Removing "log.tag.EDEN=INFO" from vendor/build.prop"
    sed -i '/^log\.tag\.EDEN=INFO$/d' "$VENDOR_BUILD_PROP" 2>/dev/null || true
fi

SYSTEM_BUILD_PROP="$WORK_DIR/system/system/build.prop"
if [ -f "$SYSTEM_BUILD_PROP" ]; then
    [ -n "${LOG:-}" ] && LOG "- Removing "log.tag.EDEN=INFO" from system/system/build.prop"
    sed -i '/^log\.tag\.EDEN=INFO$/d' "$SYSTEM_BUILD_PROP" 2>/dev/null || true
fi

LOG_STEP_OUT

LOG_STEP_IN "- Patching libvpl.so (64-bit only)"
LIBVPL_64="$WORK_DIR/vendor/lib64/libvpl.so"
PATCH_SCRIPT="$MODPATH/patch_libvpl_unload.py"
if [ ! -f "$PATCH_SCRIPT" ]; then
    [ -n "${ABORT:-}" ] && ABORT "patch_libvpl_unload.py not found: ${PATCH_SCRIPT//$SRC_DIR\//}" || return 0
fi
if [ ! -f "$LIBVPL_64" ]; then
    [ -n "${LOG:-}" ] && LOG "\033[0;33m! vendor/lib64/libvpl.so not found, skipping...\033[0m"
else
    python3 "$PATCH_SCRIPT" "$LIBVPL_64" || true
fi
LOG_STEP_OUT
