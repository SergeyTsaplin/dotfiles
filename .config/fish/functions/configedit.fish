function configedit --wraps='GIT_DIR=$HOME/.cfg GIT_WORK_TREE=$HOME nvim' --description 'alias configedit GIT_DIR=$HOME/.cfg GIT_WORK_TREE=$HOME nvim'
    GIT_DIR=/Users/s_tsaplin/.cfg GIT_WORK_TREE=/Users/s_tsaplin nvim +'Telescope git_files'
end
