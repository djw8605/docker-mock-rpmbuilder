FROM centos:8
LABEL "maintainer"="Marco Mornati <marco@mornati.net>"
LABEL "com.github.actions.name"="RPM Builder"
LABEL "com.github.actions.description"="Build RPM using RedHat Mock"
LABEL "com.github.actions.icon"="pocket"
LABEL "com.github.actions.color"="green"

RUN yum -y --setopt="tsflags=nodocs" update && \
	yum -y --setopt="tsflags=nodocs" install epel-release yum-utils rpm-build git && \
	yum -y --setopt="tsflags=nodocs" install mock && \
	yum clean all && \
	rm -rf /var/cache/yum/

#Configure users

VOLUME ["/rpmbuild"]

ADD ./build-rpm.sh /build-rpm.sh
RUN chmod +x /build-rpm.sh
#RUN setcap cap_sys_admin+ep /usr/sbin/mock
ADD ./rpm-sign.exp /rpm-sign.exp
RUN chmod +x /rpm-sign.exp

ENTRYPOINT ["/build-rpm.sh"]
