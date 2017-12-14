FROM alpine:edge
LABEL maintainer "Ilya Glotov <contact@ilyaglotov.com>"
LABEL url "https://www.github.com/linkedin/qark"

ENV ANDROID_SDK_VERSION r24.3.4
ENV HOST_OS linux
ENV ANDROID_SDK_PACKAGE="android-sdk_${ANDROID_SDK_VERSION}-${HOST_OS}.tgz"

RUN apk --update --no-cache add openjdk7-jre-base \
                                python \
                                py-pip \
                                \
  && apk --virtual .deps add curl \
                             git \
                             \
  && curl -s https://dl.google.com/android/${ANDROID_SDK_PACKAGE} \
    -o ${ANDROID_SDK_PACKAGE} \
  && tar xzf ${ANDROID_SDK_PACKAGE} \
  \
  && git clone --branch=master \
               --depth=1 \
               https://github.com/linkedin/qark.git \
  && cd /qark \
  && python setup.py install \
  \
  && apk del .deps \
  && rm -rf /${ANDROID_SDK_PACKAGE} \
            /var/cache/apk/* \
            /root/.cache

RUN adduser -D qark \
  && chown -R qark /qark

VOLUME /apk

WORKDIR /qark/qark

USER qark

ENTRYPOINT ["python", "qarkMain.py", "--basesdk=/android-sdk-linux"]
