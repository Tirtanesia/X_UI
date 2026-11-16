LOG_STEP_IN "- Enabling BSOH in SecSettings"

DECODE_APK "system" "system/priv-app/SecSettings/SecSettings.apk"

FILES="
BatteryRegulatoryPreferenceController.smali
SecBatteryInfoFragment.smali
"

for file in $FILES; do
    TARGET=$(find "$APKTOOL_DIR/system/priv-app/SecSettings/SecSettings.apk" -type f -name "$file" | head -n 1)
    if [ -n "$TARGET" ]; then
        sed -i "s/SM-A236B/SM-S731B/g" "$TARGET"
    else
        LOG "Warning: $file tidak ditemukan, melewati patch."
    fi
done

LOG_STEP_OUT

LOG_STEP_IN "- Enabling Cached App Freezer"
SET_PROP "system" "persist.device_config.activity_manager_native_boot.use_freezer" "true"
LOG_STEP_OUT

# ro.build.2ndbrand is always "false"
LOG_STEP_IN "- Disabling ASKS"
sed -i "s/ro.build.official.release/ro.build.2ndbrand/g" "$APKTOOL_DIR/system/framework/framework.jar/smali/android/content/pm/ASKSManager.smali"
LOG_STEP_OUT