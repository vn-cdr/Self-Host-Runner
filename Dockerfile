FROM ubuntu:20.04

ARG GH_RUNNER_VERSION=""
ARG RUNNER_WORK_DIR="/home/runner"

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

RUN GH_RUNNER_VERSION=${GH_RUNNER_VERSION:-$(curl --silent "https://api.github.com/repos/actions/runner/releases/latest" | grep tag_name | sed -E 's/.*"v([^"]+)".*/\1/')} && \
    curl -L -O https://github.com/actions/runner/releases/download/v${GH_RUNNER_VERSION}/actions-runner-linux-x64-${GH_RUNNER_VERSION}.tar.gz && \
    tar -zxf actions-runner-linux-x64-${GH_RUNNER_VERSION}.tar.gz && \
    rm -f actions-runner-linux-x64-${GH_RUNNER_VERSION}.tar.gz && \
    ./bin/installdependencies.sh && \
    chown -R root: ${RUNNER_WORK_DIR} && \
    rm -rf /var/lib/apt/lists/* &&\
    apt clean

