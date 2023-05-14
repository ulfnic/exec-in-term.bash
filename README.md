# exec-in-term
Execute a command in a new interactive terminal window.

## Syntax
```bash
exec-in-term
  -t|--terminal      # Optional, filename of terminal to use
  -d|--working-dir   # Optional, directory to open in
  -p|--persist       # Optional, leave the terminal open after execution, makes -x optional
  -x|--execute       # String to be executed
  --stdin            # Read string to be executed from stdin
  -h|--help          # Output help

Examples of use:
  exec-in-term -p -x 'date'
  exec-in-term -t 'alacritty' -x 'vim'
  exec-in-term --stdin <<< "micro \"$HOME/.bashrc\""
```

## Installation
```bash
# Install to /usr/local/bin
cd /usr/local/bin
sudo wget https://raw.githubusercontent.com/ulfnic/exec-in-term/main/exec-in-term
sudo chmod +x ./exec-in-term

# Test run
exec-in-term -p -x 'echo "test"'

# Satisfy dependencies if prompted to do so.
```

## License
Licensed under Zero-Clause BSD (0BSD). See LICENSE for details.
