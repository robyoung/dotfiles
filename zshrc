# local overrides
echo "$(date ) Boot start" >> /tmp/zsh-startup-robyoung
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

function check_bin {
  hash $1 2>/dev/null
}

skip_global_compinit=1

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"
CASE_SENSITIVE="true"
DEFAULT_USER="robyoung"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git vagrant golang ssh fabric pass colors docker dash npm mvn)
echo "$(date) Plugins set" >> /tmp/zsh-startup-robyoung

source $ZSH/oh-my-zsh.sh
echo "$(date) oh-my-zsh" >> /tmp/zsh-startup-robyoung

[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh
echo "$(date) boxen" >> /tmp/zsh-startup-robyoung

function venv() {
  if [ -e "$(which virtualenvwrapper.sh)" ]; then
    if [ ! -e "$(which python)" ]; then
      VIRTUALENVWRAPPER_PYTHON="$(which python3)"
    fi

    export WORKON_HOME=$HOME/.virtualenvs
    source $(which virtualenvwrapper.sh)
  fi
}
echo "$(date) Stage 2" >> /tmp/zsh-startup-robyoung

alias p='pass -c'

export GOPATH=$HOME/go
[ -d /usr/sbin ] && export PATH="$PATH:/usr/sbin"
[ -d ~/src/go_appengine ] && export PATH="$PATH:$(echo "$HOME/src/go_appengine")"
[ -d /usr/local/go/bin ] && export PATH="/usr/local/go/bin:$PATH"
export PATH=/Library/Java/JavaVirtualMachines/jdk1.8.0_45.jdk/Contents/Home/bin:$PATH
export PATH=$HOME/bin:$HOME/usr/bin:/usr/local/sbin:/usr/local/bin:$PATH:${GOPATH//://bin:}/bin
export PATH=$HOME/.cargo/bin:$PATH
export GROOVY_HOME=/usr/local/opt/groovy/libexec

# Navigation
# Move forwards with Ctrl+o
bindkey ^o forward-word
echo "$(date) Stage 3" >> /tmp/zsh-startup-robyoung

# Set up gpg-agent
if ! pgrep -x -u "${USER}" gpg-agent >/dev/null 2>&1; then
  echo "Starting gpg-agent"
  eval "$(gpg-agent --daemon --write-env-file "${GNUPGHOME:-$HOME/.gnupg}/gpg-agent.info")"
else
  echo "Not starting gpg-agent"
  eval "$(cat "${GNUPGHOME:-$HOME/.gnupg}/gpg-agent.info")"
  export SSH_AUTH_SOCK SSH_AGENT_PID
fi
unset GPG_AGENT_INFO GPG_TTY
echo "$(date) Stage 4 (gpg agent)" >> /tmp/zsh-startup-robyoung

# Set homebrew github token if available
[ -e ~/.config/homebrew/token ] && export HOMEBREW_GITHUB_API_TOKEN="$(cat ~/.config/homebrew/token)"

# added by travis gem
[ -f /Users/robyoung/.travis/travis.sh ] && source /Users/robyoung/.travis/travis.sh

# Restart virtualbox network interfaces
restart_vboxnets() {
  for net in $(ifconfig | grep '^vboxnet' | cut -f 1 -d :); do
    sudo ifconfig "$net" down && sudo ifconfig "$net" up
  done
}

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

echo "$(date) Stage 5 (pre-rbenv)" >> /tmp/zsh-startup-robyoung
# rbenv setup
if check_bin rbenv; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

echo "$(date) Stage 6 (pre-gvm)" >> /tmp/zsh-startup-robyoung
#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "/Users/robyoung/.gvm/bin/gvm-init.sh" ]] && source "/Users/robyoung/.gvm/bin/gvm-init.sh"
echo "$(date) Stage 7 (end)" >> /tmp/zsh-startup-robyoung
