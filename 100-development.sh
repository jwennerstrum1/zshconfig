#!/usr/bin/env sh

# Default to deploying on a K8s cluster, cf.
# https://github.com/c3-e/c3server/blob/develop/README.md
export K8S_MODE=on

# The use_conda function is convenient to initialize conda in the
# _current_ shell and can be used an alternative to "conda init".
#
# The issue with "conda init" is that it modifies the shell's profile 
# globally and in turn requires a user to _restart_ the shell.
# This global initialization is undesirable as the conda path
# is hard-coded, and for 7.* and V8, they can be different.
#
# Note: `direnv` sets C3_DIR based on the intended use of the workspace.
# Outside of the c3server worktree, this function is a noop.
use_conda() {

    [ -z "${C3_DIR}" ] && return

    __conda="${C3_DIR}/conda/anaconda/bin/conda"

    if [ -x "$__conda" ]; then
        __conda_setup="$("${__conda}" 'shell.bash' 'hook' 2> /dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__conda_setup"
        fi
        unset __conda_setup
    fi

    unset __conda
}
