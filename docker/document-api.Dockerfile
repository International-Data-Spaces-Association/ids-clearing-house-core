#########################################################################################
#
# Builds minimal runtime environment for the document-api
# Copyright 2019 Fraunhofer AISEC
#
#########################################################################################
FROM debian:bullseye-slim

RUN apt-get update \
&& echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
&& apt-get --no-install-recommends install -y -q ca-certificates gnupg2 libssl1.1 libc6

# trust the DAPS certificate
COPY docker/daps_cachain.crt /usr/local/share/ca-certificates/daps_cachain.crt
RUN update-ca-certificates

RUN mkdir /server
WORKDIR /server

COPY target/release/document-api .

ENTRYPOINT ["/server/document-api"]
