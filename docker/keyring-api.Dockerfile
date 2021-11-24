#########################################################################################
#
# Builds minimal runtime environment for the keyring-api
# Copyright 2019 Fraunhofer AISEC
#
#########################################################################################
FROM debian:stretch-slim

RUN apt-get update \
&& echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
&& apt-get --no-install-recommends install -y -q ca-certificates gnupg2 libssl1.1 libc6 lsb-core

# trust the DAPS certificate
COPY docker/daps_cachain.crt /usr/local/share/ca-certificates/daps_cachain.crt
RUN update-ca-certificates

RUN mkdir /server
WORKDIR /server

COPY target/release/keyring-api .
COPY docker/entrypoint.sh .

ENTRYPOINT ["/server/entrypoint.sh"]
CMD ["/server/keyring-api"]
