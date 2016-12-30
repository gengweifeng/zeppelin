FROM debian:jessie

MAINTAINER zepplin Docker Maintainers "1516827586@qq.com"

ENV TZ Asia/Shanghai

RUN apt-get update -y && apt-get install -y git \
    && apt-get install -y wget \
    && apt-get install -y openjdk-7-jdk \
    && apt-get install -y npm \
    && apt-get install -y libfontconfig \
    && wget http://www.eu.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz \
    && tar -zxf apache-maven-3.3.9-bin.tar.gz -C /usr/local/ \
    && ln -s /usr/local/apache-maven-3.3.9/bin/mvn /usr/local/bin/mvn
    
ENV MAVEN_OPTS "-Xmx2g -XX:MaxPermSize=1024m"

RUN git clone https://github.com/apache/zeppelin.git \
    && cd zeppelin \
    && ./dev/change_scala_version.sh 2.11 \
    && mvn clean package -DskipTests -Pspark-2.0 -Phadoop-2.4 -Pyarn -Ppyspark -Psparkr -Pr -Pscala-2.11
    
ENTRYPOINT ["./bin/zeppelin-daemon.sh"]
CMD ["start"]
