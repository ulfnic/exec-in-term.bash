# exec-in-term.bash
Execute a BASH command in a new terminal window.

## Syntax
```bash
PARAMETERS
  -E|--term-exec-prefix EXEC_PREFIX  # Optional, terminal command and flags to precede the command to be executed
  -x|--execute EXEC_CMD              # String to be executed
  -d|--working-dir DIR               # Optional, directory to open in
  +i|--non-interactive               # Optional, use bash without -i for executing EXEC_CMD, note: -P will always be interactive
  -p|--persist                       # Optional, Execute bash after EXEC_CMD is executed with bash -i, makes -x optional
  -P|--persist-append                # Optional, Execute bash with EXEC_CMD appended to the bottom of a copied $HOME/.bashrc, makes -x optional
  --stdin                            # Optional, Read string to be executed from stdin
  -h|--help                          # Optional, Output help

ENVIRONMENT VARIABLES
  EITB__EXEC_PREFIX           # Fallback for -E, terminal command and flags to precede the command to be executed
  TMPDIR|XDG_RUNTIME_DIR      # Path to temp directory, fallback is /tmp

EXAMPLES
  export EITB__EXEC_PREFIX='xfce4-terminal -x'

  exec-in-term.bash -p -x 'echo hello'
  exec-in-term.bash -p -E 'alacritty -e' --stdin <<< 'echo hello'
  exec-in-term.bash -x 'read -rp "Enter a message: "; notify-send "REPLY=$REPLY"'

  # Open a terminal with a dark blue background by using -P to append the command to a copy of $HOME/.bashrc
  exec-in-term.bash -P -x 'printf "\033]11;#%s\007" "000033"'
```

## License
Licensed under Zero-Clause BSD (0BSD). See LICENSE for details.
