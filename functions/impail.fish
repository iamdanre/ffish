function impail --description 'run Laravel development environment with queue, logs, vite, and PHP server'
    bunx concurrently -c "#93c5fd,#c4b5fd,#fb7185,#fdba74,#34d399" "php artisan queue:listen --tries=1" "php artisan pail --timeout=0 -vvv" "npm run build --watch" "php -S 0.0.0.0:8000 -t ../public_html" --names=server,queue,logs,vite,phpserver
end
