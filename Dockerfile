FROM cidasdpdasartip.cr.usgs.gov:8447/wma/wma-spring-boot-base:0.0.1

# Pull Artifact
ENV repo_name=aqcu-maven-centralized
ENV artifact_id=aqcu-tss-report
ENV artifact_version=0.0.4-SNAPSHOT
RUN ./pull-from-artifactory.sh ${repo_name} gov.usgs.aqcu ${artifact_id} ${artifact_version} app.jar

#Add Launch Script
ADD launch-app.sh launch-app.sh
RUN ["chmod", "+x", "launch-app.sh"]

#Default ENV Values
ENV serverPort=7501
ENV maxHeapSpace=300M
ENV javaToRServiceEndpoint=https://reporting-services.nwis.usgs.gov:7500/aqcu-java-to-r/
ENV aqcuReportsWebserviceUrl=https://reporting.nwis.usgs.gov/aqcu/timeseries-ws/
ENV aquariusServiceEndpoint=http://ts.nwis.usgs.gov
ENV aquariusServiceUser=apinwisra
ENV hystrixThreadTimeout=300000
ENV hystrixMaxQueueSize=200
ENV hystrixThreadPoolSize=10
ENV oauthResourceId=resource-id
ENV oauthResourceTokenKeyUri=https://example.gov/oauth/token_key
ENV AQUARIUS_SERVICE_PASSWORD_PATH=/aquariusPassword.txt
ENV HEALTHY_RESPONSE_CONTAINS='{"status":{"code":"UP","description":""}'
