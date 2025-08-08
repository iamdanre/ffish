#!/opt/homebrew/bin/fish

function squimg --description '🗜️ compress images'
    for file in $argv
        if not test -e $file
            echo "File not found: $file"
            continue
        end
        set ext (string lower (string split . $file)[-1])
        switch $ext
            case png
                set cmd oxipng
            case jpg jpeg
                set cmd mozjpeg
            case avif
                set cmd avif
            case webp
                set cmd webp
            case jxl jpeg_xl
                set cmd jpeg_xl
            case '*'
                echo "Skipping unknown format: $file"
                continue
        end
        ~/bin/rimage/rimage $cmd --effort 4 --quantization 75 "$file"
    end
end

