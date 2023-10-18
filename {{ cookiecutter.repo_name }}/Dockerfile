# Load from existing image
ARG NVIDIA=23.09

FROM nvcr.io/nvidia/pytorch:$NVIDIA-py3
# FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    sudo \
    build-essential \
    curl \
    software-properties-common \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV HOME                /workspace
RUN mkdir -p $HOME $HOME/references $HOME/models $HOME/src $HOME/data
ENV PATH=$HOME/.local/bin:"$PATH"

# Create non-root user
ARG USER=user
ARG UID=1000

# Create a new non-root user
RUN groupadd -r -g $UID $USER && \
    useradd -s /bin/bash -N -u $UID -g $USER $USER

# Set file permissions to grant access to the new user
RUN chown -R $USER:$USER $HOME

# Expose default ports for gradi, streamlit, and jupyter
# Note: Still need to map the ports in docker run
EXPOSE 7860 8501 8888
HEALTHCHECK CMD curl --fail http://localhost:8501/_stcore/health

# Copy files into the container
COPY ./references $HOME/references
COPY ./models $HOME/models
COPY ./src $HOME/src

COPY *.py *.cfg *.sh Makefile requirements.txt $HOME/

RUN chmod -R 755 $HOME/

# Set workdir
WORKDIR $HOME

ENTRYPOINT ["/bin/bash", "-c"]

CMD ["python3", "src/models/train.py"]