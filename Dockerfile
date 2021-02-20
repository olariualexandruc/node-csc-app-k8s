#FROM  node:10
FROM  node:12.20.2
#FROM  ubuntu:20.04
#RUN mkdir -p /app
WORKDIR /app
COPY package.json /app
RUN apt-get update -y \
   && apt-get upgrade -y \ 
   && apt auto-remove -y \
   && apt-get install -y opensc git-core build-essential cmake libssl-dev libseccomp-dev \
   && npm install \
   && git clone https://github.com/SUNET/pkcs11-proxy \
   && cd pkcs11-proxy \
   && cmake . && make && make install
   #&& tar -xf app.tar.gz \
   #&& rm -f app.tar.gz 
#RUN npm install 
    #&& npm install --prefix /app nan && npm install --prefix /app sleep
#RUN git clone https://github.com/SUNET/pkcs11-proxy && \
#    cd pkcs11-proxy && \
#    cmake . && make && make install

COPY . /app

ENV PKCS11_PROXY_SOCKET="tcp://192.168.80.102:5657"

RUN useradd csc \
   && chown -R csc.csc /app
USER csc
EXPOSE 8080
CMD [ "/app/bin/csc-server", "-l" ]
