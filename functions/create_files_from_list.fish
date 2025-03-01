function create_files_from_list -d "create (dummy) files from list.txt, fast!"
    set color_error (set_color red)
    set color_success (set_color green)
    set color_warning (set_color yellow)
    set color_info (set_color blue)
    set color_normal (set_color normal)
    set color_progress (set_color cyan)

    set color_kaomoji (set_color brmagenta)
    set color_file_count (set_color brgreen)
    set color_directory (set_color bryellow)

    # prefixes and extensions for random filenames
    set -l prefixes doc img video data backup report file project note archive
    set -l extensions txt md pdf jpg png mp4 csv json xml zip

    # parse arguments for --seed flag
    set use_random false
    set num_files 1000 # default number of random files

    set args_count (count $argv)
    set i 1
    while test $i -le $args_count
        switch $argv[$i]
            case --seed
                set use_random true
                if test (math "$i + 1") -le $args_count
                    if not string match -qr '^--' $argv[(math "$i + 1")]
                        set num_files $argv[(math "$i + 1")]
                        set i (math "$i + 1")
                    end
                end
            case '*'
                if test $i -eq 1
                    set input_file $argv[$i]
                else if test $i -eq 2
                    set output_dir $argv[$i]
                end
        end
        set i (math "$i + 1")
    end

    if test $use_random = true
        set input_file (mktemp)
        # generate random filenames
        for i in (seq 1 $num_files)
            set -l prefix (random choice $prefixes)
            set -l extension (random choice $extensions)
            set -l random_num (random 10000 99999)
            echo "$prefix-$random_num.$extension" >>$input_file
        end
        if not set -q output_dir
            set output_dir "./random_files"
        end
        set delete_input true
    else if test (count $argv) -lt 2
        echo -e "$color_warning(｡•́︿•̀｡) usage: create_files_from_list INPUT_FILE OUTPUT_DIR$color_normal"
        echo -e "$color_warning       or: create_files_from_list --seed [NUMBER] [OUTPUT_DIR]$color_normal"
        return 1
    end

    if not set -q input_file
        echo -e "$color_error(。ŏ﹏ŏ) input file not specified.$color_normal"
        return 1
    end

    if not test -f $input_file
        echo -e "$color_error(。ŏ﹏ŏ) input file '$input_file' not found.$color_normal"
        return 1
    end

    mkdir -p $output_dir

    set total_files (wc -l < "$input_file")

    printf "%s %s ૮ • ᴥ • ა %s preparing to create %s %s files in %s '%s' %s...\n" \
        "$color_info" \
        "$color_kaomoji" \
        "$color_info" \
        "$color_file_count" "$total_files" \
        "$color_directory" "$output_dir" "$color_normal"

    set batch_size 500 # smaller batch size == faster performance/feedback
    set created 0
    set temp_file (mktemp)

    cat "$input_file" | while read -l filename
        echo $filename >>$temp_file
        set created (math $created + 1)

        if test (math "$created % $batch_size") -eq 0 -o $created -eq $total_files
            cat $temp_file | xargs -P4 -I {} touch "$output_dir/{}" 2>/dev/null # parallel processes

            set percent (math "floor($created * 100 / $total_files)")
            set bar_length 30
            set filled (math "floor($bar_length * $created / $total_files)")
            set unfilled (math "$bar_length - $filled")

            printf "\r $color_progress progress: [$color_normal"
            for i in (seq 1 $filled)
                printf "▓"
            end
            for i in (seq 1 $unfilled)
                printf "░"
            end
            printf "$color_progress] $percent%% ($created/$total_files)$color_normal"

            echo -n >$temp_file
        end
    end

    rm -f $temp_file

    # clean up temporary files
    if set -q delete_input; and test $delete_input = true
        rm -f $input_file
    end

    echo ""
    printf "%s yass!! created %s %s files in %s '%s' %s\n" \
        "$color_success" \
        "$color_file_count" "$total_files" \
        "$color_directory" "$output_dir" "$color_normal"

    echo -e "$color_success $color_kaomoji ૮ • ﻌ - ა ✧ done!$color_normal"
end
