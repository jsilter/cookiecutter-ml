# Load from existing image
ARG NVIDIA=23.09

FROM nvcr.io/nvidia/pytorch:$NVIDIA-py3

# Install sudo
RUN apt-get update && apt-get -y install sudo

# Set arguments
ARG USER
ARG UID

# Set environment variables
ENV HOME                /workspace

# Create user and setup permissions on /etc/sudoers
RUN groupadd -r -g $UID $USER && \
    groupadd -r -g 17131 rsg && \
    useradd -s /bin/bash -N -u $UID -g $USER $USER && \
    usermod -a -G rsg $USER && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers && \
    chmod 0440 /etc/sudoers && \
    chmod g+w /etc/passwd && \
    usermod -d $HOME $USER

RUN echo "export PATH=$PATH:{HOME}/.local/bin" >> $HOME/.bashrc

# Command on start
CMD ["bash"]

# Set workdir and switch back to non-root user
WORKDIR $HOME
USER $UID