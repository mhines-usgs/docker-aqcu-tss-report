FROM openjdk:8-jdk-alpine

RUN set -x & \
  apk update && \
  apk upgrade && \
  apk add --no-cache curl && \
  apk --no-cache add openssl

ENV repo_name=aqcu-maven-centralized
ENV artifact_id=aqcu-tss-report
ENV artifact_version=0.0.1-SNAPSHOT

ADD pull-from-artifactory.sh pull-from-artifactory.sh
RUN ["chmod", "+x", "pull-from-artifactory.sh"]

RUN ./pull-from-artifactory.sh ${repo_name} gov.usgs.aqcu ${artifact_id} ${artifact_version} app.jar

ADD entrypoint.sh entrypoint.sh
RUN ["chmod", "+x", "entrypoint.sh"]

#Default ENV Values
ENV requireSsl=true
ENV serverPort=7501
ENV serverContextPath=/
ENV springFrameworkLogLevel=info
ENV javaToRServerList=http://localhost:8444
ENV aqcuReportsWebserviceUrl=http://reporting.nwis.usgs.gov/aqcu/timeseries-ws/
ENV aquariusServiceEndpoint=http://tsqa.nwis.usgs.gov
ENV aquariusServiceUser=apinwisra
ENV keystoreLocation=/localkeystore.p12
ENV keystorePassword=changeme
ENV keystoreSSLKey=tomcat
ENV ribbonMaxAutoRetries=3
ENV ribbonConnectTimeout=1000
ENV ribbonReadTimeout=10000
ENV hystrixThreadTimeout=10000000
ENV AQUARIUS_SERVICE_PASSWORD_PATH=/aquariusPassword.txt
ENV TOMCAT_CERT_PATH=/tomcat-wildcard-ssl.crt
ENV TOMCAT_KEY_PATH=/tomcat-wildcard-ssl.key

ENTRYPOINT [ "/entrypoint.sh" ]

HEALTHCHECK CMD curl -k "https://127.0.0.1:${serverPort}${serverContextPath}/health" | grep -q '{"status":{"code":"UP","description":""}' || exit 1