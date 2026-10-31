git-xet Container Image
===

Builds a container image based upon fedora-minimal with `git`, `git-lfs`, and `git-xet` installed.

Two scripts are included for use in Hashicorp Nomad batch jobs:

- `init` - Setup a new bare git repository with an origin remote
  - `env NOMAD_META_REMOTE_URL` - Remote git repository URL
  - `env NOMAD_META_REPO_NAME`  - Local repository path relative to the working directory

- `pull` - Fetch a remote ref to the local bare repository
  - `NOMAD_META_REPO_NAME`- Local repository path
  - `NOMAD_META_HEAD`     - [optional] Reference to fetch into the local repository

By default, the container's working directory is `/models`.