# Build Stage
FROM fuzzers/aflplusplus:3.12c as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git cmake

## Add source code to the build stage. ADD prevents git clone being cached when it shouldn't
WORKDIR /
ADD https://api.github.com/repos/capuanob/wsServer/git/refs/heads/mayhem version.json
RUN git clone -b mayhem https://github.com/capuanob/wsServer.git
WORKDIR /wsServer

## Build library
env AFL_FUZZ=yes
RUN make

## Prepare all library dependencies for copy
#RUN mkdir /deps
#RUN cp `ldd ./src/gregorio-6* | grep so | sed -e '/^[^\t]/ d' | sed -e 's/\t//' | sed -e 's/.*=..//' | sed -e 's/ (0.*)//' | sort | uniq` /deps 2>/dev/null || :
#RUN cp `ldd /usr/local/bin/afl-fuzz | grep so | sed -e '/^[^\t]/ d' | sed -e 's/\t//' | sed -e 's/.*=..//' | sed -e 's/ (0.*)//' | sort | uniq` /deps 2>/dev/null || :

## Package Stage

#FROM --platform=linux/amd64 ubuntu:20.04
#COPY --from=builder /usr/local/bin/afl-fuzz /afl-fuzz
#COPY --from=builder /gregorio/src/gregorio-6* /gregorio
#COPY --from=builder /deps /usr/lib
#COPY --from=builder /gregorio/corpus /tests

#env AFL_SKIP_CPUFREQ=1

#ENTRYPOINT ["/afl-fuzz", "-i", "/tests", "-o", "/out"]
#CMD ["/gregorio", "--stdin", "--stdout"]
