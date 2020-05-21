# Dockerfile to build sine and libsndfile for Amazon Linux 2.
#
# To build:
#   docker build -t sine .
#
# To copy the binaries to the host system, run:
#   docker create --name sine-build sine:latest
#   docker cp sine-build:/usr/local/lib64/libsndfile.so.1.0.29 .
#   docker cp sine-build:/usr/local/lib64/libsndfile.so.1 .
#   docker cp sine-build:/usr/local/lib64/libsndfile.so .
#   docker cp sine-build:/opt/sine/insta//bin/sine .
#   docker rm sine-build
#

FROM amazonlinux:2.0.20200406.0

RUN \
  yum -q -y groupinstall "Development Tools"

RUN \
  yum -q -y install \
    cmake3 \
    ninja-build \
  && ln -s /usr/bin/cmake3 /usr/bin/cmake

# Build and install libsndfile. Compile as a shared library to conform to LGPL.
#
# libsndfile-devel 1.0.25 is available through the package manager, but that
# version doesn't provide a CMake package configuration file. Therefore, build a
# more recent version.
# TODO: Update when https://github.com/erikd/libsndfile/pull/524 is merged.
ENV LIBSNDFILE_GIT_REF c103c16c972c3c30197ef0da963802ce7c33ad72
ENV LIBSNDFILE_TARBALL_SHA256 17a43830e869987ae2dca7839363f7317b6ce00dfe161d507ef0b73ccc6b4c42
WORKDIR /opt/libsndfile
RUN \
  curl -L https://api.github.com/repos/msmolens/libsndfile/tarball/${LIBSNDFILE_GIT_REF} > libsndfile.tar.gz && \
  echo "$LIBSNDFILE_TARBALL_SHA256 libsndfile.tar.gz" | sha256sum -c -w --status - && \
  mkdir libsndfile && \
  tar zxf libsndfile.tar.gz --strip-components=1 && \
  mkdir build && \
  cd build && \
  cmake -G Ninja \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DBUILD_SHARED_LIBS:BOOL=ON \
    -DBUILD_PROGRAMS:BOOL=OFF \
    -DBUILD_TESTING:BOOL=OFF \
    -DENABLE_EXTERNAL_LIBS:BOOL=OFF \
    .. && \
  cmake --build . --target install

# Build and install the example sine program.
ENV INSTALL_PREFIX /opt/sine/install
WORKDIR /opt/sine/build
COPY sine .
RUN mkdir build && \
  cd build && \
  cmake -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
    .. && \
  cmake --build . --target install && \
  echo "Shared libraries:" && \
  ldd ${INSTALL_PREFIX}/bin/sine && \
  strip ${INSTALL_PREFIX}/bin/sine
