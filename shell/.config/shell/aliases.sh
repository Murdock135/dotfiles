alias sbash='source ~/.bashrc'
alias szsh='source ~/.zshrc'
alias src='[ -n "$ZSH_VERSION" ] && source ~/.zshrc || source ~/.bashrc'

alias tree="eza --tree --level=3 -la --group-directories-first --ignore-glob='.git'"
alias ag='alias | grep'

# Git
alias gst='git status'
alias gaa='git add --all'
alias gc='git commit'
alias gp='git push'
alias gpr='git pull --rebase'
alias gd='git diff'
alias gcb='git checkout -b' # safer
alias gba='git branch --all'
alias grv='git remote --verbose'
alias gco='git checkout'
alias gl='git log --oneline --graph --decorate'

# Navigation
alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias mine='cd ~/Documents/code/mine/'
alias theirs='cd ~/Documents/code/theirs/'
alias vaults='cd ~/Documents/obsidian_vaults/'
alias ..="cd .."
alias ~="cd ~"
alias dots="cd ~/dotfiles/"
alias config="eza -la ~/.config/"
alias where='pwd'
alias alacrittyconf='vi ~/.config/alacritty/alacritty.toml'

# Utils
alias c="clear"
alias grep="grep --color=auto"
alias pingg="ping google.com"
alias myip="curl ifconfig.me"
alias ports="ss -tulwn"
alias df="df -h"
alias du="du -h -c"
alias free="free -m"
alias path='echo -e ${PATH//:/\\n}'
alias h="history | grep"
alias j="jobs -l"
alias vi="nvim"

# Docker
alias d='docker'
alias dps='docker ps -a'
alias di='docker images'
alias dcl='docker container ls'
alias drm='docker rm'   # remove container
alias dst='docker stop' # stop container
