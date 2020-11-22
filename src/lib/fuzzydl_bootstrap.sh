#!/bin/bash

set -x

YT_CONFIG_FILE="${HOME}/.fuzzydl.rc"


if ! [[ -f ${YT_CONFIG_FILE} ]]
then
    cat << EOF >> ${HOME}/.fuzzydl.rc
# FuzzyDl default configuration
YT_CONFIG_FILE=\${HOME}/.fuzzydl.rc
EOF
fi


if ! [[ -z `which termux-info` ]]
then
    termuxAppCheck=1

    if [[ -z `which fuzzydl` ]] \
    || [[ `which fuzzydl` == "fuzzydl not found" ]]
    then
        binPath=`realpath $0`
        binPath=${binPath//\/src\/lib\/fuzzydl_bootstrap.sh/}

        if ! [[ -d ${HOME}/.local/fuzzydl ]]
        then
            mkdir -p ${HOME}/.local
            ln -s -f -d ${binPath} ${HOME}/.local/fuzzydl
        fi


        if ! [[ ${PATH} =~ "fuzzydl/src/bin" ]]
        then
            export PATH=${PATH}:${HOME}/.local/fuzzydl/src/bin

            echo "PATH=\${PATH}:\${HOME}/.local/fuzzydl/src/bin" >> ${PREFIX}/etc/profile
        fi


        if ! [[ -d ${HOME}/.shortcuts/fuzzydl ]]
        then
            if ! [[ -d ${HOME}/.shortcuts ]]
            then
                mkdir -p ${HOME}/.shortcuts
            fi

            ln -s -f ${binPath}/src/bin/fuzzydl ${HOME}/.shortcuts/fuzzydl
        fi



    fi


    if ! [[ -d ${HOME}/storage ]] \
    && ! [[ `whoami` == "system" ]]
    then
        termux-setup-storage
    fi

    if ! [[ -d ${HOME}/storage/shared/YouTube ]]
    then
        mkdir -p ${HOME}/storage/shared/YouTube
        echo "YT_STORAGE_PATH=\${HOME}/storage/shared/YouTube" >> ${YT_CONFIG_FILE}
    elif [[ -d ${HOME}/storage/shared/YouTube ]] \
    && ! [[ `grep 'YT_STORAGE_PATH' ${YT_CONFIG_FILE}` ]]
    then
        echo "YT_STORAGE_PATH=\${HOME}/storage/shared/YouTube" >> ${YT_CONFIG_FILE}
    fi

else
    if ! [[ -d ${HOME}/YouTube ]]
    then
        mkdir -p ${HOME}/YouTube
        echo "YT_STORAGE_PATH=\${HOME}/YouTube" >> ${YT_CONFIG_FILE}
    elif [[ -d ${HOME}/YouTube ]] \
    && ! [[ `grep 'YT_STORAGE_PATH' ${YT_CONFIG_FILE}` ]]
    then
        echo "YT_STORAGE_PATH=\${HOME}/YouTube" >> ${YT_CONFIG_FILE}
    fi
fi

if [[ -z `which zsh` ]] \
|| [[ `which zsh` == "zsh not found" ]]
then
    apt-get update
    apt-get install -y zsh
    echo "YT_INSTALLED_ZSH=true" >> ${YT_CONFIG_FILE}
else
    echo "YT_INSTALLED_ZSH=true" >> ${YT_CONFIG_FILE}
fi

if [[ -z `which ffmpeg` ]] \
|| [[ `which ffmpeg` == "ffmpeg not found" ]]
then
    apt-get update
    apt-get install -y ffmpeg
    echo "YT_INSTALLED_FFMPEG=true" >> ${YT_CONFIG_FILE}
else
    echo "YT_INSTALLED_FFMPEG=true" >> ${YT_CONFIG_FILE}
fi

if [[ -z `which python` ]] \
|| [[ `which python` == "python not found" ]]
then
    apt-get update
    apt-get install -y python
    echo "YT_INSTALLED_PYTHON=true" >> ${YT_CONFIG_FILE}
else
    echo "YT_INSTALLED_PYTHON=true" >> ${YT_CONFIG_FILE}
fi

if [[ -z `which jq` ]] \
|| [[ `which jq` == "jq not found" ]]
then
    apt-get update
    apt-get install -y jq
    echo "YT_INSTALLED_JQ=true" >> ${YT_CONFIG_FILE}
else
    echo "YT_INSTALLED_JQ=true" >> ${YT_CONFIG_FILE}
fi

if [[ -z `which fzf` ]] \
|| [[ `which fzf` == "fzf not found" ]]
then
    apt-get update
    apt-get install -y fzf
    echo "YT_INSTALLED_FZF=true" >> ${YT_CONFIG_FILE}
else
    echo "YT_INSTALLED_FZF=true" >> ${YT_CONFIG_FILE}
fi

if [[ -z `which youtube-dl` ]] \
|| [[ `which youtube-dl` == "youtube-dl not found" ]]
then
    pip install --upgrade pip \
    && pip install --upgrade youtube-dl \
    && echo "YT_INSTALLED_YTDL=true" >> ${YT_CONFIG_FILE}
else
    echo "YT_INSTALLED_YTDL=true" >> ${YT_CONFIG_FILE}

fi

fuzzydl
exit 0
