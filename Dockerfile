FROM busybox
RUN pwd
RUN ls
COPY script.sh ./src/scrript
CMD [ "/bin/bash", "./script.sh" ]
RUN sleep 10000