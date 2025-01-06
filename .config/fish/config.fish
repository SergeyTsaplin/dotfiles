source $HOME/.config/fish/helpers/init_docker.fish
init_docker

if test -n "$WEZTERM_EXECUTABLE_DIR"
    fish_add_path -amg "$WEZTERM_EXECUTABLE_DIR"
end
