FROM docker:latest

RUN apk -Uuv add python3 py3-pip bash && \
    python3 -m pip install awscli && \
	apk --purge -v del py-pip && \
	rm /var/cache/apk/* && \
	aws --version

COPY build_post_build.sh /bin/

COPY github_push.sh /bin/

ENTRYPOINT github_push.sh
