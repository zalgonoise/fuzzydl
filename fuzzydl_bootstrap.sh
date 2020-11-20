fuzzydl_bootstrap.sh
#!/bin/bash

if ! [[ -f ${HOME}/.fuzzydl.rc ]]
then
    YT_CONFIG_FILE=${HOME}/.fuzzydl.rc
    cat << EOF >> ${HOME}/.fuzzydl.rc
# FuzzyDl default configuration
YT_CONFIG_FILE=\${HOME}/.fuzzydl.rc
EOF
fi


if ! [[ -z `which termux-info` ]]
then
    termuxAppCheck=1

    if ! [[ -d ${HOME}/storage ]]
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

if [[ -z `which zsh` ]]
then
    apt-get update
    apt-get install -y zsh
    echo "YT_INSTALLED_ZSH=true" >> ${YT_CONFIG_FILE}
else 
    echo "YT_INSTALLED_ZSH=true" >> ${YT_CONFIG_FILE}
fi

if [[ -z `which python` ]]
then
    apt-get update
    apt-get install -y python
    echo "YT_INSTALLED_PYTHON=true" >> ${YT_CONFIG_FILE}
else 
    echo "YT_INSTALLED_PYTHON=true" >> ${YT_CONFIG_FILE}
fi

if [[ -z `which jq` ]]
then
    apt-get update
    apt-get install -y jq
    echo "YT_INSTALLED_JQ=true" >> ${YT_CONFIG_FILE}
else 
    echo "YT_INSTALLED_JQ=true" >> ${YT_CONFIG_FILE}
fi

if [[ -z `which fzf` ]]
then
    apt-get update
    apt-get install -y fzf
    echo "YT_INSTALLED_FZF=true" >> ${YT_CONFIG_FILE}
else 
    echo "YT_INSTALLED_FZF=true" >> ${YT_CONFIG_FILE}
fi

if [[ -z `which youtube-dl` ]]
then
    pip install --upgrade youtube-dl
    echo "YT_INSTALLED_YTDL=true" >> ${YT_CONFIG_FILE}
else 
    echo "YT_INSTALLED_YTDL=true" >> ${YT_CONFIG_FILE}

fi

