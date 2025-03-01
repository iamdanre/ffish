function get_file_size --description "Calculates the size of a file from a given URL"
    set -l url $argv[1]
    if not string match -q -r '^https?://' $url
        echo "Error: URL must start with http:// or https://"
        return 1
    end

    set -l result (curl -sI $url)
    if test $status -ne 0
        echo "Error: Failed to fetch headers from $url"
        return 1
    end

    set -l content_length (string match -r '[Cc]ontent-[Ll]ength: *(\d+)' $result)[2]
    if test -z "$content_length"
        echo "Error: Could not find content-length header."
        return 1
    end

    set -l size_bytes (string trim $content_length)
    set -l size_kb (math "$size_bytes / 1024")
    set -l size_mb (math "$size_kb / 1024")
    set -l size_gb (math "$size_mb / 1024")

    if test (math "$size_gb") -ge 1
        printf "%.2f GB\n" $size_gb
    else if test (math "$size_mb") -ge 1
        printf "%.2f MB\n" $size_mb
    else if test (math "$size_kb") -ge 1
        printf "%.2f KB\n" $size_kb
    else
        echo "$size_bytes bytes"
    end
end
