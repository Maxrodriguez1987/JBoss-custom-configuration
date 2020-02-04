FROM registry.redhat.io/jboss-eap-7/eap72-openshift
COPY configuration/standalone-openshift.xml  /home/jboss/standalone/configuration
COPY modules/ /home/jboss/modules
#RUN keytool -import -trustcacerts -keystore $JAVA_HOME/jre/lib/security/cacerts -file extensions/CA_Servidores_Prod_SHA256.cer -storepass changeit -noprompt
# Prepare for configuration
ENV DEFAULT_LAUNCH $JBOSS_HOME/bin/openshift-launch.sh
ENV DEFAULT_LAUNCH_NOSTART $JBOSS_HOME/bin/openshift-launch-nostart.sh
RUN cp $DEFAULT_LAUNCH $DEFAULT_LAUNCH_NOSTART
RUN sed -i '/^.*standalone.sh/s/^/echo/' $DEFAULT_LAUNCH_NOSTART
RUN sed -i '/^.*wait/s/^/echo/' $DEFAULT_LAUNCH_NOSTART
RUN $DEFAULT_LAUNCH_NOSTART
# Configure
RUN rm -rf /opt/eap/standalone/configuration/standalone_xml_history/current
