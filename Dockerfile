from lambci/lambda:build-nodejs8.10

WORKDIR /app 

RUN yum -y install wget

# This is probably pretty heavy handed, adding some shit that is electron-specific
# that I don't really care about. But ok sure!
COPY eltool.sh .
RUN ./eltool.sh dev-tools 
RUN ./eltool.sh dist-deps
RUN ./eltool.sh centos-deps

# There's still a number of libraries which need to compile from source
RUN ./eltool.sh gconf-compile gconf-install 
RUN ./eltool.sh pixbuf-compile pixbuf-install
RUN ./eltool.sh gtk-compile  # this will take 3 minutes on t2.small instance
RUN ./eltool.sh gtk-install 
RUN ./eltool.sh xvfb-install 

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

CMD npx cypress run --config video=false
