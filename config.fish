if type -q brew
    if not contains /opt/homebrew/bin $PATH
        set -gx PATH /opt/homebrew/bin $PATH
        echo "added /opt/homebrew/bin to PATH"
    end
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

fish_add_path -U $HOME/Library/Application\ Support/Herd/bin/
# fish_add_path -U $HOME/Library/Application\ Support/Herd/config/nvm/versions/node/v20.18.0/bin

# Load fish provided completions
if test -d ~/.config/fish/completions
    for file in ~/.config/fish/completions/*.fish
        source $file
    end
end

eval "$(/Users/booboo/Library/Application\ Support/Herd/bin/herd.phar completion fish)"

source (/opt/homebrew/bin/starship init fish --print-full-init | psub)

test -e {$HOME}/.iterm2_shell_integration.fish; and source {$HOME}/.iterm2_shell_integration.fish

# pnpm
set -gx PNPM_HOME "/Users/booboo/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
