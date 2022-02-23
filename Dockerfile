FROM pytorch/pytorch:1.10.0-cuda11.3-cudnn8-runtime

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
	ca-certificates git wget vim sudo bzip2 ffmpeg make && \
    rm -rf /var/lib/apt/lists/*

# create a non-root user
ARG USER_ID=1000
RUN useradd -m --no-log-init --system  --uid ${USER_ID} appuser -g sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER appuser
ENV HOME=/home/appuser

ENV PATH="/home/appuser/.local/bin:${PATH}"


WORKDIR $HOME
RUN chmod -R 777 $HOME


# install HRNet dependeicies
RUN git clone https://github.com/mirghasemi-atomicbits/deep-high-resolution-net.pytorch.git HRNet && \
	cd HRNet && \
	pip3 install --user --no-deps -r requirements.txt && \
  cd lib && \
  make



# install COCOAPI
WORKDIR $HOME/HRNet
ENV COCOAPI=$HOME/HRNet/COCOAPI
RUN git clone https://github.com/cocodataset/cocoapi.git $COCOAPI
#RUN cd $COCOAPI/PythonAPI && make install
RUN echo "Installation" > installation.txt

WORKDIR $HOME/HRNet


CMD ["bash"]
