
function fatal() {
    echo "[fatal $1] $2" >&2
    exit $1
}

function cleanup() {
    ## Stop the progress watcher
    [ -f "${GIT_LFS_PROGRESS}" ] && rm -f "${GIT_LFS_PROGRESS}"

    if [ -d "$(git rev-parse --git-dir)/lfs/incomplete/" ]; then
        echo "[info] Cleaning up unrecoverable LFS incomplete blobs"
        find "$(git rev-parse --git-dir)/lfs/incomplete/" -type f ! -name '*.part' -delete -print
        echo "[info] Leaving recoverable LFS incomplete blobs"
        find "$(git rev-parse --git-dir)/lfs/incomplete/" -type f -name '*.part'
    fi
}

function progress() {
    truncate -s 0 "${GIT_LFS_PROGRESS}"

    ## Periodically tail and truncate the progress file
    while [ -f "${GIT_LFS_PROGRESS}" ]; do
        tail -n 8 "${GIT_LFS_PROGRESS}"
        truncate -s 0 "${GIT_LFS_PROGRESS}"
        sleep 5
    done &
}
