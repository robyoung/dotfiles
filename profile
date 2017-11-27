ZSH_SHELL="$(chsh -l | grep zsh)"
echo "Shell is: $SHELL -- $ZSH_SHELL"
if [ "$SHELL" != "$ZSH_SHELL" ]; then
  export SHELL="$ZSH_SHELL"
  exec $ZSH_SHELL -l
fi
