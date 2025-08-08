function record_screen_process -d "🎬 record screen at native res, then compress to 1080p trim"
    # config
    set --local temp_filename_base "screen_$(date "+%Y-%m-%d_%H_%M_%S")"
    set --local temp_filename_native "$temp_filename_base""_native_temp.mp4"
    set --local final_output_dir "$HOME/Pictures/screenshots"
    set --local final_filename_processed "$temp_filename_base""_1080p_trimmed.mp4"
    set --local final_output_path "$final_output_dir/$final_filename_processed"
    set --local trim_end_seconds 2 # seconds to trim from the end

    # record at native res for minimum cpu overhead
    sleep 2 # noone wants to see your terminal, nerd.

    ffmpeg -f avfoundation -i "1:0" \
        -c:v hevc_videotoolbox \
        -q:v 65 \
        -r 30 \
        -pix_fmt yuv420p \
        -c:a aac_at \
        -b:a 192k \
        -movflags +faststart \
        "$temp_filename_native"

    if test $status -ne 0
        echo "FOK. ffmpeg exit code: $status"
        return 1
    end

    echo "native rec saved to $temp_filename_native"

    # process
    # get duration
    set --local original_duration_str (ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$temp_filename_native")
    if test $status -ne 0 -o -z "$original_duration_str"
        echo "FOK: ffprobe exit code: $status"
        return 1
    end

    # calculate new duration, because noone wants to see your terminal, nerd.
    set --local original_duration (math --scale=3 "$original_duration_str") # keep some precision
    set --local new_duration_for_ffmpeg (math --scale=3 "max(0, $original_duration - $trim_end_seconds)")

    if math "$new_duration_for_ffmpeg <= 0"
        echo "FOK: video is shorter than trim duration."
        # rm "$temp_filename_native"
        # echo "deleted temporary native file: $temp_filename_native"
        return 1
    end

    echo "original duration: $original_duration s, new duration: $new_duration_for_ffmpeg s"

    # out dir
    mkdir -p "$final_output_dir"
    if test $status -ne 0
        echo "FOK: could not create output directory $final_output_dir"
        echo "keeping $temp_filename_native"
        return 1
    end

    echo "final output: $final_output_path"

    # 4. re-encode, scale, and trim
    # -hwaccel videotoolbox if this is slow, should be default since -c:v hevc_videotoolbox ...
    ffmpeg -i "$temp_filename_native" \
        -vf "scale=-2:1080" \
        -c:v hevc_videotoolbox \
        -q:v 60 \
        -r 30 \
        -pix_fmt yuv420p \
        -c:a aac_at \
        -b:a 128k \
        -t "$new_duration_for_ffmpeg" \
        -movflags +faststart \
        "$final_output_path"

    if test $status -ne 0
        echo "FOK: post-processing. ffmpeg exit code: $status"
        echo "keeping $temp_filename_native"
        return 1
    end

    echo "saved to $final_output_path"

    # delete temp file
    rm "$temp_filename_native"
    if test $status -eq 0
        echo "deleted temporary native file: $temp_filename_native"
    else
        echo "FOK: $temp_filename_native not deleted."
    end

    echo "done (・3・)"
    return 0
end
