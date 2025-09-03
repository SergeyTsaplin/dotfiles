source $HOME/.config/fish/helpers/init_homebrew.fish
source $HOME/.config/fish/helpers/init_docker.fish
source $HOME/.config/fish/helpers/mise.fish
init_homebrew
init_docker
init_mise
init_starship

if test -n "$WEZTERM_EXECUTABLE_DIR"
    fish_add_path -amg "$WEZTERM_EXECUTABLE_DIR"
end

set --export EDITOR nvim
