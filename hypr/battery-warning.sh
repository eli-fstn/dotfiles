#!/bin/bash

BATTERY="/sys/class/power_supply/BAT0"
LOW=30
CRITICAL=20
VERY_CRITICAL=10

last_level=""

while true; do
    capacity=$(cat "$BATTERY/capacity")
    status=$(cat "$BATTERY/status")

    # Reset warnings while charging
    if [ "$status" = "Charging" ] || [ "$status" = "Full" ]; then
        last_level=""
    fi

    # Only warn when discharging
    if [ "$status" = "Discharging" ]; then
        if [ "$capacity" -le "$VERY_CRITICAL" ] && [ "$last_level" != "5" ]; then
            notify-send -u critical \
                "🚨 CRITICAL BATTERY" \
                "Battery is at ${capacity}%. Plug in your charger NOW!"
            last_level="5"

        elif [ "$capacity" -le "$CRITICAL" ] && [ "$last_level" != "10" ]; then
            notify-send -u critical \
                "⚠️ Critical Battery" \
                "Battery is at ${capacity}%. Please connect your charger."
            last_level="10"

        elif [ "$capacity" -le "$LOW" ] && [ "$last_level" != "20" ]; then
            notify-send -u normal \
                "🔋 Battery Low" \
                "Battery is at ${capacity}%. Consider plugging in."
            last_level="20"
        fi
    fi

    sleep 30
done
