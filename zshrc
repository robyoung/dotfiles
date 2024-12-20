# local overrides

[ -f ~/.zshrc.local ] && source ~/.zshrc.local

skip_global_compinit=1

# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"
CASE_SENSITIVE="true"
DEFAULT_USER="robyoung"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git kubectl helm gcloud)

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
export PATH=~/dev/github/robyoung/dotfiles/tools:~/dev/dotfiles/tools:$PATH
export PATH=~/.local/bin:${PATH}
export PATH=${PATH}:~/.local/npm/bin
export PATH=${PATH}:~/.local/thonny/bin
export PYTHONBREAKPOINT=ipdb.set_trace
export EDITOR="nvim"
export TEALDEER_CONFIG_DIR=~/.config/tealdeer
export AICHAT_CONFIG_DIR=~/.config/aichat

if [[ -x ~/.pyenv/bin/pyenv ]]; then
  export PATH=${PATH}:~/.pyenv/bin
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

if _has eza; then
  alias l='eza -l'
  alias ls='eza'
  alias lt='eza -T'
fi
if _has batcat; then
    alias bat=batcat
fi
alias ipy=ipython
alias cy='bat -l yaml'
alias cj='bat -l javascript'

case $(uname -s) in
  Linux)
    alias clip='xclip -selection clipboard'
    alias open='xdg-open'
    ;;
  Darwin)
    alias clip='pbcopy'
    ;;
esac

alias my-repos='ls ~/dev/github/robyoung'
alias prl='gh pr list --search "-author:@me is:open is:pr -reviewed-by:@me -is:draft"  --web'

unsetopt autocd

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/vault vault

export DIRENV_LOG_FORMAT=
which direnv > /dev/null && eval "$(direnv hook zsh)"

venv() {
  if [ -d ./venv ]; then
    . ./venv/bin/activate
  elif [ -d ./.venv ]; then
    . ./.venv/bin/activate
  elif [ $PWD = $HOME ]; then
    >&2 echo "Could not find virtualenv to load"
  else
    pushd .. > /dev/null
    venv 
    popd > /dev/null
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

gtrack() {
  git branch --set-upstream-to=origin/$(git branch --show-current) $(git branch --show-current)
}

if _has keychain; then
  # For Loading the SSH key
  keychain -q --nogui $HOME/.ssh/id_ed25519
  source $HOME/.keychain/$HOST-sh  
fi

_has starship && eval "$(starship init zsh)"
_has zoxide && eval "$(zoxide init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Volta npm version manager
[ -d "$HOME/.volta" ] && {
  export VOLTA_HOME="$HOME/.volta"
  export PATH="$VOLTA_HOME/bin:$PATH"
}

export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"

[ -f ~/.atuin/bin/env ] && source "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

