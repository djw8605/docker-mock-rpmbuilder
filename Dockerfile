FROM almalinux:9
LABEL "maintainer"="Marco Mornati <marco@mornati.net>"
LABEL "com.github.actions.name"="RPM Builder"
LABEL "com.github.actions.description"="Build RPM using RedHat Mock"
LABEL "com.github.actions.icon"="pocket"
LABEL "com.github.actions.color"="green"

RUN dnf -y --setopt="tsflags=nodocs" update && \
	dnf -y --setopt="tsflags=nodocs" install epel-release dnf-utils rpm-build git redhat-rpm-config && \
	dnf -y --setopt="tsflags=nodocs" install epel-rpm-macros mock && \
	dnf clean all && \
	rm -rf /var/cache/dnf/

#Configure users
RUN useradd -u 1000 builder && \
	usermod -a -G mock builder

VOLUME ["/rpmbuild"]

ADD ./build-rpm.sh /build-rpm.sh
RUN chmod +x /build-rpm.sh
#RUN setcap cap_sys_admin+ep /usr/sbin/mock
ADD ./rpm-sign.exp /rpm-sign.exp
RUN chmod +x /rpm-sign.exp

ENTRYPOINT ["/build-rpm.sh"]
