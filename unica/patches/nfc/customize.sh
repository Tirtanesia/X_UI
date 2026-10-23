if [[ "$TARGET_NFC_CHIP_VENDOR" == "NXP" && "$SOURCE_NFC_CHIP_VENDOR" == "SLSI" ]]; then
    BLOBS_LIST="
    system/lib64/libnfc_sec_jni.so
    "
    for blob in $BLOBS_LIST
    do
        DELETE_FROM_WORK_DIR "system" "$blob"
    done

    BLOBS_LIST="
    system/etc/libnfc-nci.conf
    system/lib64/libnfc_nci_jni.so
    system/lib64/libnfc_prop_extn.so
    system/lib64/libnfc_vendor_extn.so
    "
    for blob in $BLOBS_LIST
    do
        ADD_TO_WORK_DIR "e3qxxx" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0"
    done
else
    LOG "- NFC chip is not NXP. Ignoring."
fi

DECODE_APK "system" "system/priv-app/SecSettings/SecSettings.apk"

# Newer donor builds compile SEC_PRODUCT_FEATURE_NFC_CONFIG_ANTENNA_POSITION
# into SecSettings as a literal ("27" on this donor). The NFC settings screen
# and the antenna guide dialog throw an IllegalArgumentException whenever that
# compiled value differs from ro.vendor.nfc.info.antpos, which is what made
# Settings crash on the target. Realign the compiled value with the target
# vendor property instead of hardcoding it.
NFC_ANTPOS="$(GET_PROP "vendor" "ro.vendor.nfc.info.antpos")"

if [ -z "$NFC_ANTPOS" ]; then
    LOG "- Target NFC antenna position is not declared; skipping antenna guide alignment"
else
    LOG_STEP_IN "- Matching NFC antenna guide to target position $NFC_ANTPOS"

    SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
        "smali_classes5/com/samsung/android/settings/nfc/NfcAntennaGuideDialog.smali" \
        "replace" "onCreate(Landroid/os/Bundle;)V" \
        "27" "$NFC_ANTPOS"

    SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
        "smali_classes5/com/samsung/android/settings/nfc/NfcSettings.smali" \
        "replace" "populateViewForOrientation(Lcom/android/settingslib/widget/LayoutPreference;)V" \
        "27" "$NFC_ANTPOS"

    LOG_STEP_OUT
fi

unset NFC_ANTPOS
