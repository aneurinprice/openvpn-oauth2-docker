FROM alpine:3.20.3 AS build

ARG UpstreamRelease=https://github.com/jkroepke/openvpn-auth-oauth2/releases/download/v1.22.2/openvpn-auth-oauth2_1.22.2_linux_amd64.tar.xz

RUN wget -O UpstreamRelease.tar.xz ${UpstreamRelease} && tar -xvf UpstreamRelease.tar.xz



FROM alpine:3.20.3

COPY --from=build --chmod=0775 /openvpn-auth-oauth2 /usr/local/bin/openvpn-auth-oauth2

RUN apk add --no-cache\
	openvpn\
	sudo\
	supervisor

RUN echo 'nobody ALL=(ALL) NOPASSWD: /usr/sbin/openvpn' > /etc/sudoers.d/openvpn

COPY supervisord.conf /etc/supervisord.conf

RUN mkdir -p /var/run/supervisord && chown nobody /var/run/supervisord

USER nobody
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

