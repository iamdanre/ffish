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
