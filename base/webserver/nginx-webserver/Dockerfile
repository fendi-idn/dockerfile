#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#

FROM nginx:stable-alpine

MAINTAINER Donny Arieffian <donny.arieffian@gmail.com>

ENV TZ = Asia/Jakarta

# ADD config /etc/nginx/

RUN apk add --no-cache bash tzdata \
    && adduser -D -H -u 1000 -s /bin/bash www-data

#
#--------------------------------------------------------------------------
# Final Touch
#--------------------------------------------------------------------------
#

# Set Timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPOSE 80 443
