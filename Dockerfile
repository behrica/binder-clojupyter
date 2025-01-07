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

RUN apt-get update && apt-get install -y openjdk-17-jdk curl

ADD https://github.com/behrica/noj/releases/download/noj-2-beta4-clojupyter/noj-2-beta4-clojupyter.jar /tmp/clojupyter.jar
RUN chown ${USER} /tmp/clojupyter.jar
WORKDIR ${HOME}
USER ${USER}

RUN ls -la /tmp/clojupyter.jar
RUN java -cp /tmp/clojupyter.jar clojupyter.cmdline install -j /tmp/clojupyter.jar  -i clojupyter-noj
COPY noj.ipynb .
