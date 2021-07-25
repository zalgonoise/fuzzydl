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
        && URL_METADATA=`mktemp` \
        && youtube-dl --no-check-certificate --dump-json ${DLURL} | jq -c > ${URL_METADATA}
    fi
}

fuzzyFilenamePrompt() {
    metaTitle=`cat ${URL_METADATA} | jq '.title'`
    metaUploader=`cat ${URL_METADATA} | jq '.uploader_id'`
    metaDesc=`cat ${URL_METADATA} | jq -c '.description'`


    echo "" \
    | fzf \
    --bind "change:top" \
    --preview \
        "{
            echo 'Video Title: ${(Q)metaTitle}'
            echo 'Video Uploader: ${(Q)metaUploader}'
            echo -e '\nVideo Description:\n#####\n' ; cat <( echo ${metaDesc} ) ; echo -e '\n#####'
        }" \
    --layout=reverse-list \
    --prompt="~ " \
    --pointer="~ " \
    --header="# Please enter a file name: #" \
    --color=dark \
    --black \
    --query=${(Q)metaTitle} \
    --print-query \
    | read -r DLFILENAME

    if [[ -z ${DLFILENAME} ]] \
    && ! [[ -z ${metaTitle} ]]
    then
        DLFILENAME=${metaTitle}
    fi


}

fuzzyFormatPrompt() {
    echo "$(youtube-dl  --no-check-certificate -F ${DLURL} | tail +4)
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
        export AUDIO_OPTS="`echo ${DLFORMAT} | awk '{print $2}'`"
    fi

    export DLFORMAT_ID=`echo ${DLFORMAT} | awk '{print $1}'`


}

ytdlGet() {
    if [[ -z ${AUDIO_OPTS} ]]
    then
        youtube-dl --no-check-certificate -f "${DLFORMAT_ID}" -o "${YT_STORAGE_PATH_INTERNAL}/${DLFILENAME}.%(ext)s" "${DLURL}"
        mv ${YT_STORAGE_PATH_INTERNAL}/*  ${YT_STORAGE_PATH}/.
    else
        youtube-dl --no-check-certificate -f "${DLFORMAT_ID}" -x --audio-format "${AUDIO_OPTS}" -o "${YT_STORAGE_PATH_INTERNAL}/${DLFILENAME}.%(ext)s" "${DLURL}"
        mv ${YT_STORAGE_PATH_INTERNAL}/* ${YT_STORAGE_PATH}/.
    fi
}

cleanUpAfterYourself() {
    if [[ -f ${URL_METADATA} ]]
    then
        rm -rf ${URL_METADATA}
    fi

    unset YT_CONFIG_FILE YT_INSTALLED_FFMPEG YT_INSTALLED_FZF YT_INSTALLED_JQ \
    YT_INSTALLED_PYTHON YT_INSTALLED_YTDL YT_INSTALLED_ZSH YT_STORAGE_PATH \
    curPath execPath _input \
    DL_AUTOMATED DLFILENAME DLURL URL_METADATA DLFORMAT_ID AUDIO_OPTS
}
