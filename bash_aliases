alias ll='ls -lF'
alias la='ls -lF -a'
alias clip='clip.exe'

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

if [ -f ~/.bash_aliases_local ]; then
	. ~/.bash_aliases_local
fi
