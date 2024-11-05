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

# OS and architecture
set ARCH (node -e "console.log(process.arch)")
set OS (uname -s)

# package manager
if type -q pnpm # replace with bun/yarn/deno/etc
    set PACKAGE_MANAGER pnpm # also replace this
    set INSTALL_CMD add # and this
else # default npm
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
    brew install eza zoxide bat node pnpm curl fzf git gh gping htop m-cli mailpit micro neovim webtorrent-cli wget
    # casks
    brew install --cask iterm dbngin font-jetbrains-mono font-monaspace font-meslo-lg-nerd-font iterm2 keka orbstack raycast
end

# Install fisher and plugins
if not functions -q fisher
    # Install fisher if not already installed
    echo "Installing Fisher..."
    curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
end

# Install Fisher plugins
echo "Installing Fisher plugins..."
fisher install jorgebucaran/fisher
fisher install jorgebucaran/autopair.fish
fisher install demartini/upmm.fish
fisher install meaningful-ooo/sponge
fisher install jethrokuan/z
fisher install archmagees/swift-fish-completion
fisher install ilancosman/tide@v6
fisher install plttn/fish-eza

# Helper functions
echo "💡 artisan ⇥ "
# https://github.com/adriaanzon/fish-artisan-completion
curl -L --create-dirs -o ~/.config/fish/completions/artisan.fish https://github.com/adriaanzon/fish-artisan-completion/raw/master/completions/artisan.fish
curl -L --create-dirs -o ~/.config/fish/completions/php.fish https://github.com/adriaanzon/fish-artisan-completion/raw/master/completions/php.fish
curl -L --create-dirs -o ~/.config/fish/functions/artisan.fish https://github.com/adriaanzon/fish-artisan-completion/raw/master/functions/artisan.fish

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

echo "🐋 spin up a clean shell (requires a docker runtime)"
function freshfish -d 'new shell on alpine 🦈'
    docker run -it --rm alpine:latest sh -c "apk add --no-cache fish && fish"
end
funcsave freshfish

# PHP
set PHP_PATH (which php)
if test -z "$PHP_PATH"
    echo "PHP is not installed."
else
    echo "🐘 $PHP_PATH"
end

# Laravel dev server
echo "🚀 run 'dev' for a lit Laravel development server"
function dev -d 'laravel dev server 🔥'
    set -x COMPOSER_PROCESS_TIMEOUT 0
    pnpx concurrently -c "#93c5fd,#c4b5fd,#fb7185,#fdba74" "php artisan serve" "php artisan queue:listen --tries=1" "php artisan pail" "pnpm run dev --silence-deprecations" --names=server,queue,logs,vite
end
funcsave dev
