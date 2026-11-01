FROM quay.io/fedora/fedora AS xet

RUN dnf install --assumeyes unzip

## Use RUN curl instead of ADD to expand uname -m. `ADD ...` does not run arguments through a shell
RUN curl -sSL "https://github.com/huggingface/xet-core/releases/download/git-xet-v0.2.1/git-xet-linux-$(uname -m).zip" -o git-xet.zip
RUN unzip git-xet.zip
RUN chmod +x git-xet

FROM quay.io/fedora/fedora-minimal

RUN microdnf install --assumeyes --nodocs --setopt install_weak_deps=0 git git-lfs && \
    microdnf clean all -y


COPY --from=xet git-xet /usr/local/bin
COPY checkout init pull /usr/local/bin/
RUN git xet install

RUN mkdir -p /models
WORKDIR /models

ENV GIT_TERMINAL_PROMPT=0
ENV HF_XET_CACHE=/models/.xet-cache
