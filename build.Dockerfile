FROM lambci/lambda:build-provided

ARG SWIPL=8.2.1
ARG CMAKE=3.18.2
ARG CMAKE_CHECKSUM=5d4e40fc775d3d828c72e5c45906b4d9b59003c9433ff1b36a1cb552bbd51d7e
ARG SWIPL_CHECKSUM=331bc5093d72af0c9f18fc9ed83b88ef9ddec0c8d379e6c49fa43739c8bda2fb

WORKDIR /build

VOLUME /dist

# Build a modern version of cmake in order to build swipl
RUN curl -L https://github.com/Kitware/CMake/releases/download/v${CMAKE}/cmake-${CMAKE}.tar.gz -o cmake-${CMAKE}.tar.gz &> /dev/null && \
    SUM=$(sha256sum cmake-${CMAKE}.tar.gz | cut -d ' ' -f 1) && \
    [ ${SUM} = ${CMAKE_CHECKSUM} ] && \
    tar xfz cmake-${CMAKE}.tar.gz > /dev/null && \  
    cd cmake-3.15.5 && \
    echo "cmake bootstrap" && \
    ./bootstrap > /dev/null && \
    echo "cmake make" && \
    make > /dev/null && \ 
    echo "cmake make install" && \     
    make install > /dev/null && \
    cd .. && rm -rf * > /dev/nul

# Build swipl
RUN mkdir -p /var/task && \
    curl https://www.swi-prolog.org/download/stable/src/swipl-${SWIPL}.tar.gz -o swipl-${SWIPL}.tar.gz &> /dev/null && \
    SUM=$(sha256sum swipl-${SWIPL}.tar.gz | cut -d ' ' -f 1) && \
    [ ${SUM} = ${SWIPL_CHECKSUM} ] && \
    tar xfz swipl-${SWIPL}.tar.gz > /dev/null && \
    cd swipl-${SWIPL} && \
    echo "SWIPL cmake" && \
    cmake \
        -DCMAKE_INSTALL_PREFIX=/var/task \
        -DSWIPL_PACKAGES_PCRE=OFF \
        -DSWIPL_PACKAGES_ODBC=OFF \
        -DSWIPL_PACKAGES_JAVA=OFF \
        -DSWIPL_PACKAGES_X=OFF \
        -DBUILD_TESTING=OFF \
        -DINSTALL_TESTS=OFF \
        -DINSTALL_DOCUMENTATION=OFF &> /dev/null && \
    echo "SWIPL make" && \
    make > /dev/null && \
    echo "SWIPL make install" && \
    make install > /dev/null && \
    cd .. && rm -rf * > /dev/null && \
    rm -rf /var/task/bin > /dev/null && \
    rm -rf /var/task/share > /dev/null

COPY build.sh /var/task/
COPY prolamb.pl /var/task/
RUN mv /var/task/prolamb.pl /var/task/bootstrap && chmod 777 /var/task/bootstrap

WORKDIR /var/task

CMD ["./build.sh"]
