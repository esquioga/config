export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="refined"
plugins=(git fzf zsh-syntax-highlighting colored-man-pages)

source $ZSH/oh-my-zsh.sh


export EDITOR='nvim'
export PATH="$PATH:/opt/nvim/bin"

alias vim=nvim
alias vi=nvim

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
