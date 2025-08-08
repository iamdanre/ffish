# Fish completions for pretty-php
# Command description
complete -c pretty-php -d 'Format PHP files'

# File and directory arguments
complete -c pretty-php -f -a '*.php'   -d 'PHP files'
complete -c pretty-php -f -a '*'        -d 'Directories'

# Include / exclude regex
complete -c pretty-php -s I -l include            -r -d 'Regex for pathnames to include'
complete -c pretty-php -s X -l exclude            -r -d 'Regex for pathnames to exclude'
complete -c pretty-php -s P -l include-if-php     -rx -d 'Regex for pathnames to include if PHP'

# Indentation options
complete -c pretty-php -s t -l tab                -r -d 'Indent using tabs (size)'
complete -c pretty-php -s s -l space              -r -d 'Indent using spaces (size)'
complete -c pretty-php -s l -l eol                -r -a 'auto platform lf crlf' -d 'End-of-line sequence'

# Formatting rules
complete -c pretty-php -s i -l disable             -r -d 'Disable default formatting rules'
complete -c pretty-php -s r -l enable              -r -d 'Enable optional formatting rules'
complete -c pretty-php -s 1 -l one-true-brace-style -d 'One True Brace Style'
complete -c pretty-php -s O -l operators-first      -d 'Place newlines before operators'
complete -c pretty-php -s L -l operators-last       -d 'Place newlines after operators'
complete -c pretty-php -s T -l tight                -d 'Remove blank lines between same-type declarations'
complete -c pretty-php -s N -l ignore-newlines      -d 'Ignore position of newlines'
complete -c pretty-php -s S -l no-simplify-strings  -d "Don't normalize escape sequences in strings"
complete -c pretty-php -s n -l no-simplify-numbers  -d "Don't normalize numbers"

# Heredoc and imports
complete -c pretty-php -s h -l heredoc-indent       -r -a 'none line mixed hanging' -d 'Indent level for heredocs'
complete -c pretty-php -s m -l sort-imports-by      -r -a 'none name depth'         -d 'Sort order for import statements'
complete -c pretty-php -s M -l no-sort-imports      -d "Don't sort/group import statements"
complete -c pretty-php -s b -l indent-between-tags  -d 'Indent between tags'
complete -c pretty-php -l psr12                     -d 'Enforce PSR-12 compliance'

# Presets and config
complete -c pretty-php -s p -l preset              -r -a 'drupal laravel symfony wordpress' -d 'Apply formatting preset'
complete -c pretty-php -s c -l config              -r -d 'JSON config file'
complete -c pretty-php -l no-config                -d 'Ignore config files'

# Output and diff
complete -c pretty-php -s o -l output              -r -d 'Write output to file'
complete -c pretty-php -l diff                     -r -a 'unified name-only'        -d 'Show diff if not formatted'
complete -c pretty-php -l check                    -d 'Fail silently if not formatted'
complete -c pretty-php -l print-config             -d 'Print sample config'

# Other options
complete -c pretty-php -s F -l stdin-filename      -r -d 'Path used for STDIN filename'
complete -c pretty-php -l debug                    -r -d 'Create debug output directory'
complete -c pretty-php -l log-progress             -d 'Log formatting progress files'
complete -c pretty-php -l timers                   -d 'Report timers and resources'
complete -c pretty-php -l fast                     -d 'Skip equivalence checks'
complete -c pretty-php -s v -l verbose             -d 'Report unchanged files'
complete -c pretty-php -s R -l no-problems         -d 'Suppress warnings'
complete -c pretty-php -s q -l quiet               -d 'Reduce output verbosity'
