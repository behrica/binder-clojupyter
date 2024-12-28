FROM python:3.9-slim
# install the notebook package
RUN pip install --no-cache --upgrade pip && \
    pip install --no-cache notebook jupyterlab

# create user with a home directory
ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

RUN apt-get update && apt-get install -y openjdk-17-jdk git curl
RUN curl -L -O https://github.com/clojure/brew-install/releases/latest/download/linux-install.sh && chmod +x linux-install.sh && ./linux-install.sh

WORKDIR ${HOME}
USER ${USER}
RUN git clone https://github.com/clojupyter/clojupyter
RUN cd clojupyter && clojure -T:build uber 
RUN cd clojupyter &&  clojure -M -m clojupyter.cmdline install
