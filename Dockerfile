FROM tomcat:9-jre8
MAINTAINER Pan Guolin "13661440134@163.com"

# PREPARING OPENGROK BINARIES AND FOLDERS
ADD https://github.com/OpenGrok/OpenGrok/releases/download/1.0/opengrok-1.0.tar.gz /opengrok.tar.gz
RUN tar -zxvf /opengrok.tar.gz && mv opengrok-* /opengrok && chmod -R +x /opengrok/bin
RUN mkdir /hack
RUN mkdir /src
RUN mkdir /data
RUN ln -s /data /var/opengrok
RUN ln -s /src /var/opengrok/src

#INSTALLING DEPENDENCIES
RUN apt-get update && apt-get install -y exuberant-ctags git mercurial unzip inotify-tools

#ENVIRONMENT VARIABLES CONFIGURATION
ENV SRC_ROOT /src
ENV DATA_ROOT /data
ENV OPENGROK_WEBAPP_CONTEXT /
ENV OPENGROK_TOMCAT_BASE /usr/local/tomcat
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
ENV PATH /opengrok/bin:$PATH
ENV CATALINA_BASE /usr/local/tomcat
ENV CATALINA_HOME /usr/local/tomcat
ENV CATALINA_TMPDIR /usr/local/tomcat/temp
ENV JRE_HOME /usr/local/openjdk-8
ENV CLASSPATH /usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar


# custom deployment to / with redirect from /source
RUN rm -rf /usr/local/tomcat/webapps/* && \
    /opengrok/bin/OpenGrok deploy && \
    mv "/usr/local/tomcat/webapps/source.war" "/usr/local/tomcat/webapps/ROOT.war"

# disable all file logging
ADD logging.properties /usr/local/tomcat/conf/logging.properties
RUN sed -i -e 's/Valve/Disabled/' /usr/local/tomcat/conf/server.xml

# add our scripts
ADD scripts /scripts
RUN chmod -R +x /scripts

# run
WORKDIR $CATALINA_HOME
EXPOSE 8080

CMD ["/scripts/start.sh"]
