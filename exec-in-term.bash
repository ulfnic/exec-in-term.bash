#!/usr/bin/env bash
set -o errexit


help_doc (){
	cat <<-'HelpDoc'
		exec-in-term.bash: execute a BASH command in a new terminal window

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

	HelpDoc
	exit 0
}



print_stderr() {
	if [[ $1 == '0' ]]; then
		[[ $2 ]] && printf "$2" "${@:3}" 1>&2 || :
	else
		[[ $2 ]] && printf '%s'"$2" "ERROR: ${0##*/}, " "${@:3}" 1>&2 || :
		exit "$1"
	fi
}



# Check dependencies
type setsid 1>/dev/null



setsid_detach() {
	setsid -f -- "$@" 0<&- &>/dev/null
}



[[ $1 ]] || help_doc
persist_mode='none'
i_flag='-i'
unset \
	term_exec_prefix \
	execute_cmd \

while [[ $1 ]]; do
	case $1 in
		'--term-exec-prefix'|'-E')
			shift; term_exec_prefix=$1 ;;
		'--execute'|'-x')
			shift; execute_cmd=$1 ;;
		'--working-dir'|'-d')
			shift; cd -- "$1" ;;
		'--non-interactive'|'+i')
			i_flag='' ;;
		'--persist'|'-p')
			persist_mode='regular' ;;
		'--perist-append'|'-P')
			persist_mode='append' ;;
		'--stdin')
			execute_cmd=$(</dev/stdin) ;;
		'--help'|'-h')
			help_doc ;;
		*)
			print_stderr 1 '%s\n' 'unrecognized parameter: '"$1" ;;
	esac
	shift
done



# Insure term_exec_prefix has a value and use EITB__EXEC_PREFIX as a fallback
: ${term_exec_prefix:=$EITB__EXEC_PREFIX}
if [[ ! $term_exec_prefix ]]; then
	print_stderr 1 '%s\n%s\n' \
		'missing a terminal prefix from either -E or EITB__EXEC_PREFIX export variable' \
		'Example: export EITB__EXEC_PREFIX='\''xfce4-terminal -x'\'
fi



setsid_detach() {
	setsid -f -- "$@" 0<&- &>/dev/null
}



case $persist_mode in
	'none')
		# If there's no command to execute, just open the terminal
		[[ $execute_cmd ]] || printf '%s\n' 'no command provided to execute.'
		setsid_detach $term_exec_prefix bash "$i_flag" -c "${execute_cmd}"
		;;

	'regular')
		: ${execute_cmd:=':'}
		setsid_detach $term_exec_prefix bash "$i_flag" -c "${execute_cmd} ; bash"
		;;

	'append')
		# Create a named pipe with 0600 permissions (rw for user only).
		temp_dir=${TMPDIR:-${XDG_RUNTIME_DIR:-/tmp}}
		[[ -d $temp_dir ]] || print_stderr 1 '%s\n' 'temp directory does not exist: '"$temp_dir"
		fifo_path=$temp_dir'/exec-in-term__'$$'_'${EPOCHREALTIME:-$(date +%s.%N)}
		mkfifo --mode 0600 "$fifo_path"

		# Create the .bashrc remix
		printf -v bashrc_remix '%s\n%s\n' "$(< $HOME/.bashrc)" "$execute_cmd"

		# Open terminal and have bash listen on the named pipe for the rcfile
		setsid_detach $term_exec_prefix bash --rcfile "$fifo_path"

		# Deliver the remixed .bashrc over the named pipe
		printf '%s' "$bashrc_remix" > "$fifo_path"

		# Delete the named pipe
		rm -- "$fifo_path"
		;;
esac



