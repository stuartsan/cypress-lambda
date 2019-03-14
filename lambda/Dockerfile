from lambci/lambda:build-nodejs8.10

WORKDIR /app 

RUN yum -y install wget

# https://gist.github.com/dimkir/f4afde77366ff041b66d2252b45a13db
COPY eltool.sh .
RUN ./eltool.sh dev-tools 
RUN ./eltool.sh dist-deps
RUN ./eltool.sh centos-deps
RUN ./eltool.sh gconf-compile gconf-install 
RUN ./eltool.sh pixbuf-compile pixbuf-install
RUN ./eltool.sh gtk-compile  # this will take 3 minutes on t2.small instance
RUN ./eltool.sh gtk-install 
RUN ./eltool.sh xvfb-install 

# provides libasound...from:
# github.com/cypress-io/cypress-docker-images/blob/15c5bf875454a289e20587b192c4e4322787956c/base/centos7/Dockerfile#L1
RUN yum install -y alsa-lib*

COPY package.json .
COPY package-lock.json .
RUN npm install

COPY cypress.json .
COPY cypress ./cypress

COPY link.sh .
RUN ./link.sh

# https://unix.stackexchange.com/a/315172 LMAO
COPY xkb-compile.sh .
RUN ./xkb-compile.sh

# put everything in lib
RUN mkdir lib

RUN ldd /usr/bin/Xvfb | cut -d' ' -f 3 | tr -d '\r' \
  | xargs -I{} cp -R -L {} ./lib/
RUN ldd /root/.cache/Cypress/3.1.5/Cypress/Cypress | cut -d' ' -f 3 | tr -d '\r' \
  | xargs -I{} cp -R -L {} ./lib/
RUN cp -L -R /usr/share/X11/xkb ./lib/
RUN cp /app/default.xkm ./lib/
RUN cp -L -R /root/.cache/Cypress/3.1.5/Cypress/* ./lib/

# we need some node prune up in here
# gotta get lib under 512mb!
RUN curl -sfL https://install.goreleaser.com/github.com/tj/node-prune.sh | bash -s -- -b /usr/local/bin
RUN node-prune lib/resources/app/packages/server
RUN node-prune lib/resources/app/packages/https-proxy
RUN node-prune lib/resources/app/packages/electron

COPY patch.sh .
RUN ./patch.sh

# tar it up
RUN GZIP=-9 tar cvzf lib.tar.gz ./lib

CMD npx cypress run --config video=false
