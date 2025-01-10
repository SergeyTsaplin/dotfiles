function configedit --wraps='GIT_DIR=$HOME/.cfg GIT_WORK_TREE=$HOME nvim' --description 'alias configedit GIT_DIR=$HOME/.cfg GIT_WORK_TREE=$HOME nvim'
    GIT_DIR=$HOME/.cfg GIT_WORK_TREE=$HOME nvim +'Telescope git_files'
end
