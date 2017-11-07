FROM centos:centos7

EXPOSE 27000-27020 80

RUN echo "Downloading the automation agent"

RUN curl -OL http://96.20.149.25:8080/download/agent/automation/mongodb-mms-automation-agent-3.2.15.2257-1.rhel7_x86_64.tar.gz

RUN mkdir -p /opt/mongodb-mms-automation

RUN tar -xvf mongodb-mms-automation-agent-3.2.15.2257-1.rhel7_x86_64.tar.gz -C /opt/mongodb-mms-automation --strip-components=1

RUN sed -i 's,mmsGroupId=,mmsGroupId=59faf0ec715a34060273c8b6,' /opt/mongodb-mms-automation/local.config && \
    sed -i 's,mmsApiKey=,mmsApiKey=1d3c1e0cff58eb6ca7468be466a8b1c2,' /opt/mongodb-mms-automation/local.config && \
    sed -i 's,mmsBaseUrl=,mmsBaseUrl=http://96.20.149.25:8080,' /opt/mongodb-mms-automation/local.config && \
    mkdir -p /var/lib/mongodb-mms-automation && \
    mkdir /var/log/mongodb-mms-automation && \
    mkdir /data && \
    chown `whoami` /var/lib/mongodb-mms-automation && \
    chown `whoami` /var/log/mongodb-mms-automation && \
    chown `whoami` /data && \
    mkdir /var/run/mongodb-mms-automation && \
    echo "Starting the automation agent"

CMD /opt/mongodb-mms-automation/mongodb-mms-automation-agent --config=/opt/mongodb-mms-automation/local.config -pidfilepath /var/run/mongodb-mms-automation/mongodb-mms-automation-agent.pid >> /var/log/mongodb-mms-automation/automation-agent.log
