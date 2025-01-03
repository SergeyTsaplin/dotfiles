function config
    # `config` alias for dotconfig files
    command /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $argv
end

