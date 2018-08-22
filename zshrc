# local overrides
echo "--------------------------------" >> /tmp/zsh-startup-robyoung
echo "$(~/bin/stamp ) Boot start" >> /tmp/zsh-startup-robyoung
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
# plugins=(ansible git vagrant golang ssh fabric pass colors docker docker-compose dash npm mvn kubectl history-search-multi-word)
# plugins=(git golang ssh pass colors docker kubectl history-search-multi-word)
echo "$(~/bin/stamp) Plugins set" >> /tmp/zsh-startup-robyoung

source $ZSH/oh-my-zsh.sh
echo "$(~/bin/stamp) oh-my-zsh" >> /tmp/zsh-startup-robyoung

_has(){
    command type "$1" > /dev/null 2>&1
}

[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh
echo "$(~/bin/stamp) boxen" >> /tmp/zsh-startup-robyoung

function venv() {
  if [ -e "$(which virtualenvwrapper.sh)" ]; then
    VIRTUALENVWRAPPER_PYTHON="$(which python2)"

    export WORKON_HOME=$HOME/.virtualenvs
    source $(which virtualenvwrapper.sh)
  fi
}
echo "$(~/bin/stamp) Stage 2" >> /tmp/zsh-startup-robyoung

alias p='pass -c'

export GOPATH=$HOME/go
[ -d /usr/sbin ] && export PATH="$PATH:/usr/sbin"
[ -d ~/src/go_appengine ] && export PATH="$PATH:$(echo "$HOME/src/go_appengine")"
[ -d /usr/local/go/bin ] && export PATH="/usr/local/go/bin:$PATH"
export PATH=/Library/Java/JavaVirtualMachines/jdk1.8.0_45.jdk/Contents/Home/bin:$PATH
export PATH=$HOME/bin:$HOME/usr/bin:/usr/local/sbin:/usr/local/bin:$PATH:${GOPATH//://bin:}/bin
export PATH=$HOME/.cargo/bin:$PATH
export PATH=/usr/local/opt/curl/bin:$PATH
export PATH=$PATH:$HOME/Projects/personal/bobnet/bobnet/bin
export GROOVY_HOME=/usr/local/opt/groovy/libexec

# Navigation
# Move forwards with Ctrl+o
bindkey ^o forward-word
echo "$(~/bin/stamp) Stage 3" >> /tmp/zsh-startup-robyoung

# Start gpg-agent
gpgconf --launch gpg-agent

# Set homebrew github token if available
[ -e ~/.config/homebrew/token ] && export HOMEBREW_GITHUB_API_TOKEN="$(cat ~/.config/homebrew/token)"

# added by travis gem
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

# Restart virtualbox network interfaces
restart_vboxnets() {
  for net in $(ifconfig | grep '^vboxnet' | cut -f 1 -d :); do
    sudo ifconfig "$net" down && sudo ifconfig "$net" up
  done
}

# AWS
export AWS_VAULT_BACKEND=file
export AWS_DEFAULT_REGION=eu-west-1

# AAM
export EP_EXEC_USER_ID=$(id -u)

bindkey '^b' backward-word
bindkey '^f' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

echo "$(~/bin/stamp) Stage 6 (pre-rg-fzf)" >> /tmp/zsh-startup-robyoung
# Setting rg as the default source for fzf
if [ -e /usr/local/opt/fzf/shell/completion.zsh ]; then
  source /usr/local/opt/fzf/shell/key-bindings.zsh
  source /usr/local/opt/fzf/shell/completion.zsh
fi
if _has fzf && _has rg; then
  export FZF_DEFAULT_COMMAND='rg -u --files'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
fi
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias it=git

echo "$(~/bin/stamp) Stage 7 (pre-pyenv)" >> /tmp/zsh-startup-robyoung
eval "$(pyenv init - --no-rehash)"
echo "$(~/bin/stamp) Stage 7 (pre-pyenv-virtualenv)" >> /tmp/zsh-startup-robyoung
eval "$(pyenv virtualenv-init -)"

echo "$(~/bin/stamp) Stage 7 (pre-direnv)" >> /tmp/zsh-startup-robyoung
eval "$(direnv hook zsh)"

echo "$(~/bin/stamp) Stage 8 (pre-gvm)" >> /tmp/zsh-startup-robyoung
#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "~/.gvm/bin/gvm-init.sh" ]] && source "~/.gvm/bin/gvm-init.sh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f ~/usr/src/google-cloud-sdk/path.zsh.inc ]; then
  source ~/usr/src/google-cloud-sdk/path.zsh.inc;
fi

# The next line enables shell command completion for gcloud.
if [ -f ~/usr/src/google-cloud-sdk/completion.zsh.inc ]; then
  source ~/usr/src/google-cloud-sdk/completion.zsh.inc;
fi
export CLOUDSDK_PYTHON=/usr/local/bin/python2

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/vault vault

echo "$(~/bin/stamp) Stage 9 (end)" >> /tmp/zsh-startup-robyoung
