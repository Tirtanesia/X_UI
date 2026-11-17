LOG_STEP_IN "- Enabling BSOH in SecSettings"

DECODE_APK "system" "system/priv-app/SecSettings/SecSettings.apk"

# SecSettings may place these classes in different smali_classesN directories
# depending on the base ROM version. Find them instead of assuming classes5.
SECSETTINGS_DIR="$APKTOOL_DIR/system/priv-app/SecSettings/SecSettings.apk"
BSOH_FILES=()
if [[ -d "$SECSETTINGS_DIR" ]]; then
    mapfile -d '' -t BSOH_FILES < <(find "$SECSETTINGS_DIR" -type f \\
        \( -name 'BatteryRegulatoryPreferenceController.smali' \\
        -o -name 'SecBatteryInfoFragment.smali' \) -print0)
fi

if [[ ${#BSOH_FILES[@]} -eq 0 ]]; then
    echo "::warning::BSOH model replacement skipped: target smali files were not found in $SECSETTINGS_DIR"
else
    for f in "${BSOH_FILES[@]}"; do
        sed -i 's/SM-S947B/SM-N980F/g' "$f"
    done
fi
LOG_STEP_OUT

LOG_STEP_IN "- Enabling Cached App Freezer"
SET_PROP "system" "persist.device_config.activity_manager_native_boot.use_freezer" "true"
LOG_STEP_OUT

# ro.build.2ndbrand is always "false"
LOG_STEP_IN "- Disabling ASKS"
sed -i "s/ro.build.official.release/ro.build.2ndbrand/g" "$APKTOOL_DIR/system/framework/framework.jar/smali/android/content/pm/ASKSManager.smali"
LOG_STEP_OUT
