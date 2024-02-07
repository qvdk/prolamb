FROM amazonlinux:2023

ARG SICSTUS=4.9.0
ARG SICSTUS_CHECKSUM=65c9caf7070a73fd04c818e04208d58d05623164346f152ad03d15936dedd940

ARG SITENAME
ARG LICENSECODE
ARG EXPIRES

WORKDIR /build

VOLUME /dist

RUN dnf install -y \
  gettext \
  gcc \
  perl \
  tar \
  gzip &> /dev/null

COPY sicstus.install.cache /build/sicstus.install.cache

RUN curl https://sicstus.sics.se/sicstus/products4/sicstus/${SICSTUS}/binaries/linux/sp-${SICSTUS}-x86_64-linux-glibc2.28.tar.gz -o sicstus-${SICSTUS}.tar.gz &> /dev/null && \
    SUM=$(sha256sum sicstus-${SICSTUS}.tar.gz | cut -d ' ' -f 1) && \
    [ ${SUM} = ${SICSTUS_CHECKSUM} ] && \
    tar xfz sicstus-${SICSTUS}.tar.gz && \
    cd sp-${SICSTUS}-x86_64-linux-glibc2.28 && \
    envsubst < /build/sicstus.install.cache > install.cache && \
    ./InstallSICStus --batch && \
    rm -rf /var/task/lib/sp-4.9.0

COPY build.sh /var/task/
COPY prolamb.pl /var/task/
RUN mv /var/task/prolamb.pl /var/task/bootstrap && chmod 777 /var/task/bootstrap

WORKDIR /var/task

CMD ["./build.sh"]