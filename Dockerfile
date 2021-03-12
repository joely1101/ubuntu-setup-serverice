FROM alpine:3.12
LABEL maintainer="Joel <joely1101@gmail.com>"
RUN apk add --no-cache tftp-hpa vsftpd bash nginx
COPY docker-rc /etc/
COPY vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY vsftpd.conf /etc/vsftpd/vsftpd.conf
#COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx.conf.d.default /etc/nginx/conf.d/default.conf 
CMD [ "/etc/docker-rc" ]

