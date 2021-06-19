# local overrides

[ -f ~/.zshrc.local ] && source ~/.zshrc.local

skip_global_compinit=1

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"
CASE_SENSITIVE="true"
DEFAULT_USER="robyoung"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(pass git kubectl helm gcloud)

fpath=(~/.config/zsh ~/.zsh $fpath ~/.zfunc)

source $ZSH/oh-my-zsh.sh

_has(){
  type $1 >/dev/null 2>&1
}

export DOCKER_USER='docker'
export DEV_DIR=dev
export GOPATH=$HOME/go
export PATH=$PATH:${GOPATH//://bin:}/bin
export PATH=~/.cargo/bin:$PATH
export PATH=~/dev/github/robyoung/dotfiles/tools:$PATH
export PATH=~/.local/bin:${PATH}
export PATH=${PATH}:~/.local/npm/bin
export PATH=${PATH}:~/.local/thonny/bin
export PYTHONBREAKPOINT=ipdb.set_trace

if [[ -d /opt/homebrew/Caskroom/google-cloud-sdk ]]; then
  source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
  source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi

if [[ -d /opt/homebrew/opt/llvm ]]; then
  export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
fi

# pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Navigation
# Move forwards with Ctrl+o
bindkey ^o forward-word
#echo "$(~/bin/stamp) Stage 3" >> /tmp/zsh-startup-robyoung

# Start gpg-agent
gpgconf --launch gpg-agent

bindkey '^b' backward-word
bindkey '^f' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

if [ -d ~/.fzf ]; then
  export PATH=~/.fzf/bin:${PATH}
  source ~/.fzf/shell/key-bindings.zsh
  source ~/.fzf/shell/completion.zsh
fi

# Setting rg as the default source for fzf
if _has fzf && _has rg; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
fi

if _has exa; then
  alias l='exa -l'
  alias ls='exa'
fi
alias gph="git push origin HEAD"
alias it=git
alias ipy=ipython
alias cy='bat -l yaml'
alias cj='bat -l javascript'
alias shot='shotgun $(slop -l -c 200,0,1,0.4 -f "-i %i -g %g")'
if [[ $(uname -s) == "Linux" ]]; then
  alias open='xdg-open'
fi
alias p='pass -c'
if [[ $(uname -s) == "Darwin" ]]; then
  alias clip='pbcopy'
else
  alias clip='xclip -selection clipboard'
fi
alias my-repos='exa ~/dev/github/robyoung'

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/vault vault

export DIRENV_LOG_FORMAT=
which direnv > /dev/null && eval "$(direnv hook zsh)"

venv() {
  if [ -d ./venv ]; then
    . ./venv/bin/activate
  else
    . ~/${DEV_DIR}/venv/bin/activate
  fi
}

envup() {
  local file=$1

  if [ -f $file ]; then
    set -a
    source $file
    set +a
  else
    echo "No $file file found" 1>&2
    return 1
  fi
}

eval "$(starship init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
