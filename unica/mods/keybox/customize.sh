# Rebalance framework multidex for Keybox/PIF hooks on One UI 8.5 / One UI 9 (Android 16/17)
SDK_VER="${SOURCE_PLATFORM_SDK_VERSION:-${SOURCE_SDK_VERSION:-37}}"

if [ "$SDK_VER" -ge 36 ] && \
    [ -f "$APKTOOL_DIR/system/framework/framework.jar/smali_classes3/android/os/BaseBundle.smali" ]; then
    LOG "- Rebalancing framework multidex for Keybox/PIF hooks"
    EVAL "mkdir -p \"$APKTOOL_DIR/system/framework/framework.jar/smali_classes6/android/os\""
    EVAL "mv \"$APKTOOL_DIR/system/framework/framework.jar/smali_classes3/android/os/BaseBundle.smali\" \"$APKTOOL_DIR/system/framework/framework.jar/smali_classes6/android/os/BaseBundle.smali\""
fi
