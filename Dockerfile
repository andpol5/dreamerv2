# https://hub.docker.com/r/nvidia/cuda
FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

# Weirdly enough, library location is not specified correctly inside Nvidia-docker.
ENV LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu/:/usr/local/cuda-10.0/compat/:${LD_LIBRARY_PATH}"

# https://unix.stackexchange.com/questions/146283/how-to-prevent-prompt-that-ask-to-restart-services-when-installing-libpq-dev
ENV DEBIAN_FRONTEND=noninteractive

# Copy the dl-mantle codebase into the container.
COPY . /code
WORKDIR /code/

# Install pre-reqs and create a virtual environment.
RUN apt-get -qq update && apt-get -qq install -y python3-dev python3-pip python3-venv
RUN python3 -m venv dl_venv

# Use the installed virtual env as the default python environment.
# https://pythonspeed.com/articles/activate-virtualenv-dockerfile/
ENV VIRTUAL_ENV=/code/dl_venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN pip install -U pip && pip install -r /code/requirements.txt
