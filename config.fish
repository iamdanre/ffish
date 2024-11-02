function fish_greeting
    if not set -q fish_greeting
        set -l line1 (printf (_ 'welcome to %sffish%s, the fucked friendly interactive shell') (set_color white) (set_color normal))
        set -l line2 \n(printf (_ 'type %shelp%s for instructions on how to use fish %s≽⋆f< /ᐷ%s') (set_color green) (set_color normal) (set_color brmagenta))
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

    # Lando
    # Keep it that way to not print superfluous newlines on old configuration
    test -n "$fish_greeting"
    and echo $fish_greeting
end

#  SETUVAR fish_greeting
if status is-interactive
    # Commands to run in interactive sessions can go here
    # printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "fish"}}\x9c'
end

# Created by `pipx` on 2024-04-01 00:22:04
# set PATH $PATH /Users/o.x.o/.local/bin

# Load fish provided completions
if test -d ~/.config/fish/completions
    for file in ~/.config/fish/completions/*.fish
        source $file
    end
end

# source /Users/o.x.o/.config/fish/completions/herd.fish

# source (herd completion fish | psub)
# tabtab source for packages
# uninstall by removing these lines
# [ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true

# pnpm
# set -gx PNPM_HOME "/Users/o.x.o/Library/pnpm"
# if not string match -q -- $PNPM_HOME $PATH
#   set -gx PATH "$PNPM_HOME" $PATH
# end
# pnpm end


# test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

#starship init fish | source


# export PATH="/Users/o.x.o/.lando/bin${PATH+:$PATH}"; #landopath

# Wasmer
# export WASMER_DIR="/Users/o.x.o/.wasmer"
# [ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

# source /opt/homebrew/opt/asdf/libexec/asdf.fish
# uv generate-shell-completion fish | source
# uvx --generate-shell-completion fish | source
