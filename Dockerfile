from lambci/lambda:build-nodejs8.10

# FIXME not global ok
RUN npm install -g cypress

WORKDIR /app 

RUN yum -y install wget

# This is probably pretty heavy handed, adding some shit that is electron-specific
# that I don't really care about. But ok sure!
COPY eltool.sh .
RUN ./eltool.sh dev-tools  # installs gcc compiler and some libs
RUN ./eltool.sh dist-deps  # we install prebuilt dependencies from Amazon Linux repos by using yum
RUN ./eltool.sh centos-deps # we install some  prebuil dependencies we can take from CentOS6 repo

# There's still a number of libraries which need to compile from source
RUN ./eltool.sh gconf-compile gconf-install 
RUN ./eltool.sh pixbuf-compile pixbuf-install
RUN ./eltool.sh gtk-compile  # this will take 3 minutes on t2.small instance
RUN ./eltool.sh gtk-install 
RUN ./eltool.sh xvfb-install 

COPY cypress.json .
COPY cypress ./cypress

COPY link.sh .
RUN ./link.sh

CMD cypress run
