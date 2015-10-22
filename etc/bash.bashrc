# System-wide .bashrc file for interactive bash(1) shells.

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, overwrite the one in /etc/profile)
PS1='\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

# Commented out, don't overwrite xterm -T "title" -n "icontitle" by default.
# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
#    ;;
#*)
#    ;;
#esac

# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
	function command_not_found_handle {
	        # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
		   /usr/bin/python /usr/lib/command-not-found -- "$1"
                   return $?
                elif [ -x /usr/share/command-not-found/command-not-found ]; then
		   /usr/bin/python /usr/share/command-not-found/command-not-found -- "$1"
                   return $?
		else
		   printf "%s: command not found\n" "$1" >&2
		   return 127
		fi
	}
fi

# set a fancy prompt (non-color, overwrite the one in /etc/profile)
col() {
	echo "\[\e[1;$1m\]$2\[\e[0m\]"
}
set_prompt() {
	Last_Command=$? # Must come first!
	FancyX='\342\234\227'
	Checkmark='\342\234\223'

	PS1=""
	# If it was successful, print a green check mark. Otherwise, print
	# a red X.
	if [[ $Last_Command == 0 ]]; then
		PS1+="$(col 42 " $Checkmark ")"
	else
		PS1+="$(col 41 " $FancyX ")"
	fi

	PS1+=" ${debian_chroot:+($debian_chroot)}"

	# Show red if root:
	if [[ $EUID == 0 ]]; then
		PS1+="$(col 41 ' \u')"
	else
		PS1+="$(col 43 ' \u')"
	fi

	PS1+="$(col 46)$(col 47 @)$(col 46 '\H ') $(col 44 ' \w ') $(col 37 '\$') "
	PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1\[\e[1;37m\]"
}
PROMPT_COMMAND='set_prompt'
trap 'echo -ne "\e[0m"' DEBUG