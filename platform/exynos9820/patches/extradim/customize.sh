#!/usr/bin/env bash
if [[ "${TARGET_CODENAME:-}" =~ ^beyond ]]; then
    if declare -f LOG >/dev/null 2>&1; then
        LOG "- Skipping extradim patches for $TARGET_CODENAME"
    fi
    # Move smali patches out of way so they don't get applied
    SMALI_DIR="$MODPATH/smali"
    if [ -d "$SMALI_DIR" ]; then
        mv "$SMALI_DIR" "${SMALI_DIR}.disabled_beyond" 2>/dev/null || true
    fi
    return 0
fi

LOG_STEP_IN "- Removing device specific checks"

if declare -f APPLY_PATCHES >/dev/null 2>&1; then
    APPLY_PATCHES "smali/system/priv-app/SecSettings/SecSettings.apk" "$MODPATH/smali/system/priv-app/SecSettings/SecSettings.apk/*.patch"
    APPLY_PATCHES "smali/system_ext/priv-app/SystemUI/SystemUI.apk" "$MODPATH/smali/system_ext/priv-app/SystemUI/SystemUI.apk/*.patch"
fi

LOG_STEP_OUT
