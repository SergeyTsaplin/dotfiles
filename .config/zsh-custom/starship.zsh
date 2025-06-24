builtin whence -p "starship" &> /dev/null

[[ $? -ne 0 ]] && return 0

eval "$(starship init zsh)"
