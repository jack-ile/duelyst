# Slim images are based on Debian, but with a smaller size footprint.
FROM node:18-slim

# Install bcrypt dependencies and git.
# TODO: Isolate bcrypt dependencies to API images only.
RUN apt-get update && apt-get -y install python3 make gcc g++ git

# TODO: vv Remove this code once zlib1g@1:1.2.13 is no longer distributed in the node base image

# Patch out zlib vulnerability SNYK-DEBIAN12-ZLIB-6008963 (https://security.snyk.io/vuln/SNYK-DEBIAN12-ZLIB-6008963)
# Completely purge zlib1g@1:1.2.13 from the image, this comes installed by default and contains the vulnerability
RUN apt-get -y purge zlib1g && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Replace the former zlib package with the newest after apt-get update without the vulnerability
RUN apt-get -y install zlib1g

# TODO: ^^ Remove this code once zlib1g@1:1.2.13 is no longer distributed in the node base image

# Work around boneskull/yargs dependency using the deprecated git protocol.
RUN git config --global url."https://github.com/".insteadOf git@github.com:
RUN git config --global url."https://".insteadOf git://

# Include Node.js dependencies in the image.
WORKDIR /duelyst
COPY package.json /duelyst/
COPY yarn.lock /duelyst/
COPY packages /duelyst/packages
RUN yarn install --production && yarn cache clean

# Include the code in the image.
COPY version.json /duelyst/
COPY app/*.coffee /duelyst/app/
COPY app/common /duelyst/app/common
COPY app/data /duelyst/app/data
COPY app/localization /duelyst/app/localization
COPY app/sdk /duelyst/app/sdk
COPY bin /duelyst/bin
COPY config /duelyst/config
COPY server /duelyst/server
COPY worker /duelyst/worker
