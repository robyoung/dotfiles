# local overrides
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"
CASE_SENSITIVE="true"
DEFAULT_USER="robyoung"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git vagrant golang ssh rbenv fabric pass)

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
[ -d ~/src/go_appengine ] && export PATH="$PATH:$(echo ~/src/go_appengine)"
# Add GNU getopt to path
if which brew > /dev/null; then
  export PATH=$(brew --prefix gnu-getopt)/bin:$PATH
fi
[ -d /usr/local/go/bin ] && export PATH="/usr/local/go/bin:$PATH"
export PATH=$HOME/bin:$PATH:${GOPATH//://bin:}/bin:$HOME/anaconda/bin

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
    shred ${GNUPGHOME:-~/.gnupg}/secring.gpg
    rm -f ${GNUPGHOME:-~/.gnupg}/secring.gpg
  fi
}
find_share() {
  for dir in "$@"; do
    if [ "$(find $dir -name 'secring*' 2> /dev/null)" != "" ]; then
      echo "$(find $dir -name 'secring*' | head -n 1)"
      exit 0
    fi
  done
  exit 1
}
calculate_shares() {
  local usb_drive

  echo $(find_share ~/media /Volumes /media)
  echo $(ls ~/.gnupg/secring.gpg.part.*)
}
export GFSHARES="$(calculate_shares)"

# Set homebrew github token if available
[ -e ~/.config/homebrew/token ] && export HOMEBREW_GITHUB_API_TOKEN="$(cat ~/.config/homebrew/token)"

# Start camlistored if available
if [ -e ~/bin/camlistored -a -z "$CAMLISTORE_DISABLE" ]; then
  if [ ! "$(ps -A | grep -v grep | grep camlistored > /dev/null)" ]; then
    echo "Starting camlistore server"
    (camlistored >> ~/log/camlistored.log 2>&1 &)
  fi
fi

# added by travis gem
[ -f /Users/robyoung/.travis/travis.sh ] && source /Users/robyoung/.travis/travis.sh

# Restart virtualbox network interfaces
restart_vboxnets() {
  for net in $(ifconfig | grep '^vboxnet' | cut -f 1 -d :); do
    sudo ifconfig $net down && sudo ifconfig $net up
  done
}
