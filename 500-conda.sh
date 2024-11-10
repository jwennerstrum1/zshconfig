#!/usr/bin/env zsh

autoload -U add-zsh-hook

# Note: usually managed by 'conda init'
# However, we support a more dynamic setup supporting multiple conda installations
conda_init() {
    __conda_setup="$("${C3_CONDA_EXE}" 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
       eval "$__conda_setup"
    fi
    unset __conda_setup
    __conda_reactivate
}


# Initialize conda environment if it is not set yet or differs from the currently active one
conda_switch() {
    if [ -z "${C3_CONDA_EXE}" ]; then
        return
    fi

    if [ "${CONDA_EXE}" != "${C3_CONDA_EXE}" ]; then
        conda_init
        echo "Switched to $(conda --version)"
        unset C3_CONDA_EXE
    fi
}

add-zsh-hook precmd conda_switch
