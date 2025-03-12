# ~/.zshrc

# Source common shell configurations
if [ -f ~/.common_shellrc ]; then
  source ~/.common_shellrc
fi

# Ensure a dynamic git branch prompt is displayed
autoload -Uz vcs_info
precmd() {
    PS1_CMD1 = $(git branch --show-current 2> /dev/null)
}

# Set the prompt format
PS1='%n@%m|%~(${PS1_CMD1})%# '