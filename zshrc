# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"
CASE_SENSITIVE="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git vagrant golang)

source $ZSH/oh-my-zsh.sh

PROMPT='%{$fg[green]%}h %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function

[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh

if [ -e "$(which virtualenvwrapper.sh)" ]; then
  if [ ! -e "$(which python)" ]; then
    VIRTUALENVWRAPPER_PYTHON="$(which python3)"
  fi
  
  export WORKON_HOME=$HOME/.virtualenvs
  source $(which virtualenvwrapper.sh)
fi

alias p='pass -c'

export GOPATH=$HOME/go
[ -d /usr/sbin ] && export PATH="$PATH:/usr/sbin"
# Add GNU getopt to path
if which brew > /dev/null; then
  export PATH=$(brew --prefix gnu-getopt)/bin:$PATH
fi
export PATH=$HOME/bin:$PATH:${GOPATH//://bin:}/bin

# Set up gpg-agent
eval $(gpg-agent --daemon)

# Set up GPG key share combining
combine_keyring() {
  local error
  if [ "$GFSHARES" ]; then
    shares=(${=GFSHARES})
    error=$(gfcombine -o ${GNUPGHOME:-~/.gnupg}/secring.gpg $shares[1,2] 2>&1)
    if [ $? != 0 ]; then
      echo "Failed to combine keyring: ${error}"
      exit 1
    fi
  fi
}
remove_keyring() {
  if [ "$GFSHARES" ]; then
    srm -f -z ${GNUPGHOME:-~/.gnupg}/secring.gpg
  fi
}
calculate_shares() {
  local usb_drive
  if [[ -d /Volumes ]]; then
    usb_drive=/Volumes
  else
    usb_drive=/media/removable
  fi
  echo $(ls $usb_drive/UNTITLED/gpg/secring.gpg.parts.*)
  echo $(ls ~/.gnupg/secring.gpg.parts.*)
}
export GFSHARES="$(calculate_shares)"
