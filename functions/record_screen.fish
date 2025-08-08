function record_screen -d "🎬 record screen with ffmpeg, scaled to 1080p height"
    # Declare filename as a variable local to this function
    set --local filename "screen_$(date "+%Y-%m-%d_%H_%M_%S")_1080p.mp4" # Added _1080p to filename
    echo "saving to: $filename"

    # Optional: Uncomment to list devices if you're unsure about "1:0"
    # echo "Listing available AVFoundation input devices:"
    # ffmpeg -f avfoundation -list_devices true -i ""
    # echo "---------------------------------------------------"
    # echo "Ensure your input device in -i \"VIDEO:AUDIO\" is correct."
    # echo "---------------------------------------------------"

    echo "starting 1080p recording in 2 seconds..."
    sleep 2

    ffmpeg -f avfoundation -i "1:0" \w
        -vf "scale=-2:1080" \
        -c:v hevc_videotoolbox \
        -q:v 65 \
        -r 30 \
        -pix_fmt yuv420p \
        -c:a aac_at \
        -b:a 192k \
        -movflags +faststart \
        "$filename"

    if test $status -eq 0
        echo "recording saved to $filename"
    else
        echo "error during recording. FFmpeg exit code: $status"
    end
end
