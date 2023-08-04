FROM busybox
RUN pwd
RUN ls
COPY script.sh ./src/scrript
RUN /bin/bash ./script.sh
CMD ["sleep", "10000"]