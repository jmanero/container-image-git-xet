
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

function set_remote_url() {
    local remote=$1; shift
    local url=$1; shift

    echo "[info] Checking remote '${remote}'"
    if git remote get-url "${remote}" &>/dev/null; then
        echo "[info] Setting remote '${remote}' to ${url}"
        git remote set-url "${remote}" "${url}"
    else
        echo "[info] Adding remote '${remote}' at ${url}"
        git remote add "${remote}" "${url}"
fi

}
