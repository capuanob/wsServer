# Build Stage
FROM fuzzers/aflplusplus:3.12c as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake

ADD . /wsServer
WORKDIR /wsServer

## Build library
RUN make MAYHEM_FUZZ=yes

## Package Stage
FROM fuzzers/aflplusplus:3.12c
COPY --from=builder /wsServer/tests/fuzzy/ws_file /ws_file
COPY --from=builder /wsServer/tests/fuzzy/in /tests

ENTRYPOINT ["afl-fuzz", "-i", "/tests", "-o", "/out"]
CMD ["/ws_file", "@@"]
