test -e {$HOME}/.iterm2_shell_integration.fish; and source {$HOME}/.iterm2_shell_integration.fish

if type -q brew
    if not contains /opt/homebrew/bin $PATH
        set -gx PATH /opt/homebrew/bin $PATH
        echo "added /opt/homebrew/bin to PATH"
    end
end

# Prevent fish-eza from recreating aliases on every start
if not set -q __FISH_EZA_ALIASES_INITIALIZED
    set -U __FISH_EZA_ALIASES_INITIALIZED 1
end

function fish_greeting
    if not set -q fish_greeting
        set -l line1 (printf (_ 'welcome to %sffish%s, the fucked friendly interactive shell') (set_color white) (set_color normal))
        set -l line2 \n(printf (_ 'type %shelp%s for instructions on how to. ffuck. ffish %s≽⋆f< /ᐷ%s') (set_color green) (set_color normal) (set_color brmagenta))
        set -g fish_greeting "$line1$line2"
    end

    if set -q fish_private_mode
        set -l line (_ "fish is running in private mode, history will not be persisted.")
        if set -q fish_greeting[1]
            set -g fish_greeting $fish_greeting\n$line
        else
            set -g fish_greeting $line
        end
    end

    # Keep it that way to not print superfluous newlines on old configuration
    test -n "$fish_greeting"
    and echo $fish_greeting
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# herd php config
set -gx HERD_PHP_84_INI_SCAN_DIR $HOME/Library/Application\ Support/Herd/config/php/84
# set -gx HERD_PHP_83_INI_SCAN_DIR $HOME/Library/Application\ Support/Herd/config/php/83
fish_add_path -U $HOME/Library/Application\ Support/Herd/bin/

# test -e {$HOME}/.iterm2_shell_integration.fish; and source {$HOME}/.iterm2_shell_integration.fish

# pnpm
set -gx PNPM_HOME /Users/booboo/Library/pnpm
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# bun
# set -gx BUN_INSTALL /opt/homebrew/bin/bun
# if not string match -q -- $BUN_INSTALL $PATH
#     set -gx PATH "$BUN_INSTALL" $PATH
# end

if not string match -q -- $HOME/.bun/bin $PATH
    set -gx PATH "$HOME/.bun/bin" $PATH
end
# bun end

# DBngin
for mariadb_dir in /Users/Shared/DBngin/mariadb/*/bin
    if test -d $mariadb_dir
        if not contains $mariadb_dir $PATH
            set -gx PATH $mariadb_dir $PATH
        end
    end
end
# DBngin end

# mommy
#if test -d /usr/local/share/fish/vendor_completions.d/
#    set -p fish_complete_path /usr/local/share/fish/vendor_completions.d/
#end

# Added by LM Studio CLI (lms)
# set -gx PATH $PATH /Users/booboo/.lmstudio/bin

# custom executables
# set -gx PATH $PATH /Users/booboo/bin
# Optional: Make all files in the directory executable automatically
# for file in /Users/booboo/bin/forPath/*
#     if test -f $file
#         chmod +x $file
#     end
# end

# Load completions quietly
if test -d ~/.config/fish/completions
    for file in ~/.config/fish/completions/*.fish
        source $file >/dev/null 2>&1
    end
end

# export PATH="$PATH:$HOME/.local/bin"
fish_add_path "$HOME/.local/bin"
# fish_add_path "$HOME/bin"
source $HOME/bin/fish_include.fish # other local binaries and functions . . .

# Start and persist ssh-agent
if not pgrep -x ssh-agent > /dev/null
    eval (ssh-agent -c)
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
end

# Load keys from keychain if not already loaded
ssh-add -l > /dev/null; or ssh-add --apple-load-keychain

source (/opt/homebrew/bin/starship init fish --print-full-init | psub)

string match -q "$TERM_PROGRAM" "kiro" and . (kiro --locate-shell-integration-path fish)
