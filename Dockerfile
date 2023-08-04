FROM node
RUN ls
COPY . .
RUN pwd
RUN ls
CMD ["/bin/bash", "./script.sh"]