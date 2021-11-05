FROM ubuntu:20.04

ARG GH_RUNNER_VERSION="2.283.3"
ARG RUNNER_URL
ARG RUNNER_TOKEN
ENV RUNNER_WORK_DIR="/home/runner"
ENV RUNNER_ALLOW_RUNASROOT=0

RUN apt update && \
    apt install -y \
        curl \
        ca-certificates \
        sudo && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean && \
    apt update

RUN mkdir -p ${RUNNER_WORK_DIR}
WORKDIR ${RUNNER_WORK_DIR}

RUN GH_RUNNER_VERSION=${GH_RUNNER_VERSION:-$(curl -s "https://api.github.com/repos/actions/runner/releases/latest" | grep tag_name | sed -E 's/.*"v([^"]+)".*/\1/')} && \
    curl -L -O https://github.com/actions/runner/releases/download/v${GH_RUNNER_VERSION}/actions-runner-linux-x64-${GH_RUNNER_VERSION}.tar.gz && \
    tar -zxf actions-runner-linux-x64-${GH_RUNNER_VERSION}.tar.gz && \
    rm -f actions-runner-linux-x64-${GH_RUNNER_VERSION}.tar.gz && \
    ./bin/installdependencies.sh && \
    chown -R root: /home/runner && \
    rm -rf /var/lib/apt/lists/* &&\
    apt clean

ENTRYPOINT ${RUNNER_WORK_DIR}/config.sh --url ${RUNNER_URL} --token ${RUNNER_TOKEN} --name `hostname` --work ${RUNNER_WORK_DIR} --unattended && \
           ${RUNNER_WORK_DIR}/run.sh
