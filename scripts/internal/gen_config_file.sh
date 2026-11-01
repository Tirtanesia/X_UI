#!/usr/bin/env bash
set -euo pipefail

GET_BUILD_VAR() {
    local var_name="$1"
    local fallback="${2:-}"
    local var_value="${!var_name:-$fallback}"

    printf '%s=%s\n' "$var_name" "$var_value"
}

# The generator is invoked from buildenv.sh after sourcing the root environment.
# It must write a config fragment that can be sourced by bash with `set -o allexport`.
OUT_DIR="${OUT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/out}"
mkdir -p "$OUT_DIR"

{
    GET_BUILD_VAR "SOURCE_AUDIO_CONFIG_RECORDALIVE_LIB_VERSION" "none"
    GET_BUILD_VAR "TARGET_AUDIO_CONFIG_RECORDALIVE_LIB_VERSION" "none"
    GET_BUILD_VAR "SOURCE_AUDIO_SUPPORT_ACH_RINGTONE" "false"
    GET_BUILD_VAR "TARGET_AUDIO_SUPPORT_ACH_RINGTONE" "false"
    GET_BUILD_VAR "SOURCE_AUDIO_SUPPORT_DUAL_SPEAKER" "false"
    GET_BUILD_VAR "TARGET_AUDIO_SUPPORT_DUAL_SPEAKER" "false"
    GET_BUILD_VAR "SOURCE_AUDIO_SUPPORT_VIRTUAL_VIBRATION_SOUND" "false"
    GET_BUILD_VAR "TARGET_AUDIO_SUPPORT_VIRTUAL_VIBRATION_SOUND" "false"
} > "$OUT_DIR/config.sh"
