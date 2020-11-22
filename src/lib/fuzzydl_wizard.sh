#!/bin/zsh

fuzzyUrlPrompt() {
    echo "" \
    | fzf \
    --print-query \
    --bind "change:top" \
    --layout=reverse-list \
    --prompt="~ " \
    --pointer="~ " \
    --header="# Please enter your YouTube link: #" \
    --color=dark \
    --black \
    | read -r DLURL
    
    if ! [[ -z ${DLURL} ]]
    then
        export DLURL \
        && export URL_METADATA=$(youtube-dl --dump-json ${DLURL} | jq -c)
    fi
}

fuzzyFilenamePrompt() {
    echo "" \
    | fzf \
    --bind "change:top" \
    --preview \
        "{  
            cat <(echo -n 'Video Title: '; echo ${URL_METADATA} | jq -r '.title')
            cat <(echo -n 'Video Uploader: '; echo ${URL_METADATA} | jq -r '.uploader_id')
            cat <(echo -e '\n#####\nVideo Description:\n '; echo ${URL_METADATA} | jq -r '.description')
        }"
    --layout=reverse-list \
    --prompt="~ " \
    --pointer="~ " \
    --header="# Please enter a file name: #" \
    --color=dark \
    --black \
    --print-query \
    | read -r ${DLFILENAME}
    
    if [[ -z ${DLFILENAME} ]]
    then
        DLFILENAME=`echo ${URL_METADATA} | jq -r '.title'`
    fi


}

fuzzyFormatPrompt() {
    echo "$(youtube-dl -F ${DLURL} | tail +4)
best
worst
bestvideo
bestaudio
worstvideo
worstaudio" \
    | fzf \
    --bind "change:top" \
    --layout=reverse-list \
    --prompt="~ " \
    --pointer="~ " \
    --header="# Please enter a file format: #" \
    --color=dark \
    --black \
    | read -r DLFORMAT

    if [[ `echo ${DLFORMAT} | awk '{print $3}'` == "audio" ]]
    then
        export AUDIO_OPTS="-x --audio-format `echo ${DLFORMAT} | awk '{print $2}'`"
    fi

    export DLFORMAT_ID=`echo ${DLFORMAT} | awk '{print $1}'`


}

ytdlGet() {
    youtube-dl -f "${DLFORMAT_ID}" ${AUDIO_OPTS} -o "${YTDL_STORAGE_PATH}/${DLFILENAME}" "${DLURL}"
}