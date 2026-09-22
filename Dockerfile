ARG BASE_IMAGE=debian:trixie-slim

FROM ${BASE_IMAGE} AS base


RUN <<BASE
	apt-get update
	apt-get -y install extrepo
	extrepo enable mise
	apt-get update
	apt-get -y install mise yq pre-commit curl ca-certificates
BASE

RUN <<BASE
	echo 'eval "$(mise activate bash)"' > /etc/profile.d/mise.sh
	echo 'eval "$(mise activate bash)"' >> /root/.bashrc
	echo 'mise install' >> /etc/profile.d/mise.sh
	echo 'mise ls' >> /etc/profile.d/mise.sh
BASE

FROM base AS devcontainer

ENV MISE_ENV="development"

RUN <<DEV
	mise install
DEV

FROM base AS runner

WORKDIR /workspace/template

COPY . /workspace/template

RUN <<RUN 
	mise install
RUN

ENTRYPOINT ["mise","exec","--"]
