function ffinker --description '🔄 laravel tinker with bootstrap'
    set app_name (cat .env | grep APP_NAME | cut -d '=' -f2)
    set_color green
    printf "tinkering in %s...\n" $app_name
    set_color normal
    echo "  • ctrl+d reloads"
    echo "  • ctrl+c quits"
    echo "  • 'help' helps"
    set_color yellow

    if not test -f artisan
        set_color red
        echo "artisan file not found."
        set_color normal
        return 1
    end

    set_color normal
    zsh -c "app_name='$app_name'; trap 'exit 0' INT TERM; while true; do 
        if php artisan tinker; then
            if [ \$? -eq 0 ]; then
                echo -e \"\n→ reloading tinker for \$app_name...\"
            else
                exit 0
            fi
        else
            echo \"error running tinker!\"
            exit 1
        fi
    done"
end
