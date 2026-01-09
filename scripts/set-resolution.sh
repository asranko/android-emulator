#!/bin/bash
# Switches between Phone and Tablet resolution

if [ "$1" == "tablet" ]; then
    echo "Switching to Tablet Mode..."
        adb shell wm size 1920x1080
            adb shell wm density 240
            elif [ "$1" == "desktop" ]; then
                echo "Switching to Desktop Mode (1080p)..."
                    adb shell wm size 1920x1080
                        adb shell wm density 160
                        else
                            echo "Switching to Phone Mode..."
                                adb shell wm size 1080x1920
                                    adb shell wm density 420
                                    fi

                                    echo "Resolution Changed!"
                                    echo "If the screen looks weird, refresh the noVNC page."
