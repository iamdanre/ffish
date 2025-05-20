function brew_whos_your_mommy -d '👀 show the leaf (parent) of a formula' -a formula
    if test (count $formula) -eq 0
        printf "Usage: "(set_color yellow)"brew_whos_your_mommy"(set_color normal)" <formula>\n"
        return 1
    end
    set -l target_formula $formula[1]

    # if not command -v $target_formula >/dev/null
    #     set_color red
    #     printf "'%s' is not a command 💀\n" $target_formula
    #     set_color normal
    #     return 1
    # end

    if command -v $target_formula >/dev/null && not brew list --formula | grep -q "^$target_formula\$"
        set_color cyan
        printf "'%s' is not a brew command 🌻\n" $target_formula
        printf "path: %s\n" (which $target_formula)
        set_color normal
        return 1
    else if not brew list --formula | grep -q "^$target_formula\$"
        set_color red
        printf "formula '%s' is not installed via brew\n" $target_formula
        printf "path: %s\n" (which $target_formula)
        set_color normal
        return 1
    end

    if brew leaves | grep -q "^$target_formula\$" || brew list --formula | grep -q "^$target_formula\$"
        set_color green
        printf "%s is a leaf 🌿\n" $target_formula
        set_color normal
    else
        set_color yellow
        printf "%s is a dependency of:\n" $target_formula
        set_color green
        set -l dependencies (brew uses --installed $target_formula | sort)
        for dep in $dependencies
            printf " • %s\n" $dep
        end
        set_color normal
    end
end

complete -c brew_whos_your_mommy -fa "(brew list --formula)"

if type -q brew_whos_your_mommy
    complete -c brew_whos_your_mommy -fa "(brew list --formula)"
end
