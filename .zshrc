# ~/.zshrc

HISTFILE=~/.zshist
HISTSIZE=750
SAVEHIST=1000

# KEY BINDS #

bindkey -e
bindkey "\e[3~"		delete-char 
bindkey  "^[[H"		beginning-of-line
bindkey  "^[[F"		end-of-line

#-----------#

export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"

autoload -U colors && colors
#PS1="%B%{$fg[red]%} ZSH %~>%%%{$reset_color%} $b"
PROMPT=' %(?.%B%F{green}ZSH.%F{red}ZSH)%f%b %B%F{red}%~>%f%b '


if [ "$TERM" = "linux" ]; then	# TTY Catpuccin mocha colors
	printf %b '\e]P01E1E2E' # set background color to "Base"
	printf %b '\e]P8585B70' # set bright black to "Surface2"
	printf %b '\e]P7BAC2DE' # set text color to "Text"
	printf %b '\e]PFA6ADC8' # set bright white to "Subtext0"
	printf %b '\e]P1F38BA8' # set red to "Red"
	printf %b '\e]P9F38BA8' # set bright red to "Red"
	printf %b '\e]P2A6E3A1' # set green to "Green"
	printf %b '\e]PAA6E3A1' # set bright green to "Green"
	printf %b '\e]P3F9E2AF' # set yellow to "Yellow"
	printf %b '\e]PBF9E2AF' # set bright yellow to "Yellow"
	printf %b '\e]P489B4FA' # set blue to "Blue"
	printf %b '\e]PC89B4FA' # set bright blue to "Blue"
	printf %b '\e]P5F5C2E7' # set magenta to "Pink"
	printf %b '\e]PDF5C2E7' # set bright magenta to "Pink"
	printf %b '\e]P694E2D5' # set cyan to "Teal"
	printf %b '\e]PE94E2D5' # set bright cyan to "Teal"
	clear #for background artifacting
	neofetch --off
	echo ""
else
	echo ""
	echo ""
	echo "Microsoft(R) Windows 95"
	echo "   (C)Copyright Microsoft Corp 1981-1996."
	echo ""
fi

# /usr/lib/kconf_update_bin/gtk_theme 


# Aliases
alias ls='ls --color=auto'
alias l='ls -XF'
alias la='ls -XFa'
alias ..='cd ../'
alias x='exit'
alias kittyrc='nano ~/.config/kitty/kitty.conf'
alias zshrc='nano ~/.zshrc'
alias gimme='sudo chown -R salt:salt ./'
alias vocal='espeak -k20 -p 0 -s150'
alias ipv4address="ip -json route get 8.8.8.8 | jq -r '.[].prefsrc'"
alias help='grep -oP "alias\K.*" ~/.zshrc'
alias fbshot='sudo fbgrab sshot.png &>/dev/null'

# Scripts
alias saltvl="bash ~/.local/share/scripts/saltvl/saltvl.sh"
alias db="cd ~/core/database/ ; python terminal.py"
alias awesome-test="Xephyr :5 & sleep 1 ; DISPLAY=:5 awesome"
alias xwm="Xephyr :5 -screen 1920x1080  & sleep 1 ; DISPLAY=:5"
