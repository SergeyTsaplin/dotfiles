function init_docker
    if test -e $HOME/.rd/docker.sock
        set -Ux DOCKER_HOST unix://$HOME/.rd/docker.sock
        fish_add_path -pmg "$HOME/.rd/bin"
    end
end
