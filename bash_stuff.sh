alias off='systemctl poweroff'
alias reboot='systemctl reboot'
alias suspend='systemctl suspend'
alias up='sudo apt update; sudo apt upgrade'
alias install='sudo apt install'
alias search='sudo apt search'
alias night='pkill -USR1 redshift'
alias em='emacsclient -n'
alias ff='emacsclient -n'
alias di='emacsclient -n --eval "(dired nil)"'
alias down='cd ~/Downloads/; di'
alias ba='em ~/.bashrc'

export PATH="$PATH:/home/joe/Projects/Odin"
export PATH="$PATH:/home/joe/Projects/ols"
export PATH="$PATH:/snap/bin"

# Created by `pipx` on 2024-01-04 17:54:51
export PATH="$PATH:/home/joe/.local/bin"
. "$HOME/.cargo/env"

# fzf
source ~/scripts/completion.bash
source ~/scripts/key-bindings.bash 
