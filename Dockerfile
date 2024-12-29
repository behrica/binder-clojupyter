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

WORKDIR ${HOME}
USER ${USER}

RUN curl  -L -o clojupyter.jar https://github.com/clojupyter/clojupyter/releases/download/v0.4.332/clojupyter-0.4.332-standalone.jar 
RUN java -cp clojupyter.jar clojupyter.cmdline install -j clojupyter.jar  -i clojupyter
RUN rm clojupyter.jar
COPY noj.ipynb .
