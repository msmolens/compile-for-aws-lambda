# Compile for AWS Lambda

## Overview

For a native executable to run in an AWS Lambda function, it must be compatible
with the runtime's operating system. This repository is an example of using
Docker to build a custom C++ executable that runs on AWS Lambda.

## Requirements

- [Docker](https://docs.docker.com/)
- [Make](https://www.gnu.org/software/make/)

## Usage

Enter this directory and run `make`:

```console
$ cd /path/to/compile-for-aws-lambda
$ make
```

The `build` directory now contains binaries that can be packaged in the ZIP file
for an AWS Lambda function:

```
$ tree build
build
├── libsndfile.so -> libsndfile.so.1
├── libsndfile.so.1 -> libsndfile.so.1.0.29
├── libsndfile.so.1.0.29
└── sine
```

The example `sine` program generates a sine wave at the specified frequency (Hz)
and writes it as a WAV file:
```console
$ cd build
$ export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.
$ ./sine 2600 /tmp/2600.wav
$ file /tmp/2600.wav
2600.wav: RIFF (little-endian) data, WAVE audio, Microsoft PCM, 24 bit, mono 44100 Hz
```

To run the program in a Lambda function, use the
[child_process](https://nodejs.org/docs/latest-v12.x/api/child_process.html)
module in Node.js, or the
[subprocess](https://docs.python.org/3.8/library/subprocess.html) module in
Python.

## Details

From the [Running Arbitrary Executables in AWS
Lambda](https://aws.amazon.com/blogs/compute/running-executables-in-aws-lambda/)
blog post:

> If you compile your own binaries, ensure that they’re either statically linked
> or built for the matching version of Amazon Linux.

The example `sine` program in this repository uses the LGPL-licensed
[libsndfile](https://github.com/erikd/libsndfile) library. To comply with the
LPGL, libsndfile must be used as a shared library; it cannot be statically
linked.

### Dockerfile

To compile binaries that are compatible with Amazon Linux 2, the
[`Dockerfile`](./Dockerfile) starts from an Amazon Linux 2 base image:

```docker
FROM amazonlinux:2.0.20200406.0
```

The Dockerfile then builds and installs `libsndfile` and `sine`. 

Binaries compiled in this environment will run on any AWS Lambda runtime that's
based on Amazon Linux 2, such as the Node.js 12 and Python 3.8 runtimes. See
[AWS Lambda
runtimes](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html) for
a complete list.

### Makefile

The [`Makefile`](./Makefile) creates a container from the Docker image and
copies the built artifacts from the container to the host system.
