#!/usr/bin/env fish
# brew?
if type -q brew
    if not contains /opt/homebrew/bin $PATH
        set -gx PATH /opt/homebrew/bin $PATH
        echo "added /opt/homebrew/bin to PATH"
    end
end
# fish
echo "🐠 $(which fish)"

#  OS and architecture
set ARCH (node -e "console.log(process.arch)")
set OS (uname -s)
# package manager
if type -q pnpm # replace with bun/yarn/deno/etc
    set PACKAGE_MANAGER pnpm # also replace this
    set INSTALL_CMD add # and this
else #default npm
    set PACKAGE_MANAGER npm
    set INSTALL_CMD install
end
echo "📦 $(which $PACKAGE_MANAGER)"

# macOS on arm64?
if test "$OS" = Darwin -a "$ARCH" = arm64
    echo "🍎 arm64 macOS detected, installing @esbuild/darwin-arm64 globally"
    $PACKAGE_MANAGER $INSTALL_CMD @esbuild/darwin-arm64 --save-dev

    # TODO check taps
    # shell
    brew install eza zoxide bat node pnpm bun yarn curl fzf git gh gping htop m-cli mailpit mas memcached micro neovim webtorrent-cli wget
    # casks
    brew install --cask iterm dbngin font-geist-mono-nerd-font font-jetbrains-mono font-monaspace iterm2 keka orbstack raycast
end

# helper functions
echo "💡 try 'artisan ' and hit tab for available artisan commands, no need to prepend 'php '"
function artisan -d 'Alias that helps fish recognize artisan as a command that should be completed'
    php artisan $argv
end
funcsave artisan

echo "🌻 remove pesky .DS_Store files with rmds"
function rmds -d 'remove .DS_Store files recursively from working directory'
    find . -type f -name ".DS_Store" -delete
end
funcsave rmds

echo "🪴 check which ports are in use with 'portsinuse' (requires sudo)"
function portsinuse -d 'check which ports are being used'
    sudo lsof -i -n -P | grep TCP
end
funcsave portsinuse

# php
set PHP_PATH (which php)
if test -z "$PHP_PATH"
    echo "PHP is not installed."
else
    echo "🐘 $PHP_PATH"
end
# function dev
#     command composer run dev
# end

echo "🚀 run 'dev' for a lit laravel development server"
function dev -d 'laravel dev server 🔥'
    set -x COMPOSER_PROCESS_TIMEOUT 0
    npx concurrently -c "#93c5fd,#c4b5fd,#fb7185,#fdba74" "php artisan serve" "php artisan queue:listen --tries=1" "php artisan pail" "npm run dev --silence-deprecations" --names=server,queue,logs,vite
end
funcsave dev
