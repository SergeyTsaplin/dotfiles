source $HOME/.config/fish/helpers/init_homebrew.fish
source $HOME/.config/fish/helpers/init_docker.fish
init_homebrew
init_docker

if test -n "$WEZTERM_EXECUTABLE_DIR"
    fish_add_path -amg "$WEZTERM_EXECUTABLE_DIR"
end

set --export EDITOR /usr/local/bin/nvim
