# exec-in-term
Execute a command in a new interactive terminal window.

## Syntax
```bash
PARAMETERS
  -E|--term-exec-prefix CMD   # Optional, terminal command and flags to precede the command to be executed
  -x|--execute CMD            # String to be executed
  -d|--working-dir DIR        # Optional, directory to open in
  -p|--persist                # Optional, leave the terminal open after execution, makes -x optional
  --stdin                     # Read string to be executed from stdin
  -h|--help                   # Output help

ENVIRONMENT VARIABLES
  TERM_EXEC_PREFIX            # Fallback for -E, terminal command and flags to precede the command to be executed
  TMPDIR|XDG_RUNTIME_DIR      # Path to temp directory, fallback is /tmp

EXAMPLES
  export TERM_EXEC_PREFIX='xfce4-terminal -x'

  exec-in-term -p -x 'echo hello'
  exec-in-term -p -E 'alacritty -e' --stdin <<< 'echo hello'
  exec-in-term -x 'read -rp "Enter a message: "; notify-send "REPLY=$REPLY"'
```

## License
Licensed under Zero-Clause BSD (0BSD). See LICENSE for details.
