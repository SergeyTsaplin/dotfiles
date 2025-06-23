if [[ -v DOCKER_HOST ]]; then
    return 0
fi

if [[ -e "${HOME}/.rd/docker.sock" ]]; then
    export DOCKER_HOST=unix://${HOME}/.rd/docker.sock
    if [ -d "${HOME}/.rd/bin" ]; then
        export PATH=${HOME}/.rd/bin:$PATH
    fi
elif [[ -e "/var/run/docker.sock" ]]; then
    export DOCKER_HOST=unix:///var/run/docker.sock
fi

