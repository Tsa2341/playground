FROM debian
COPY . /src
WORKDIR /src
CMD ["/bin/bash", "/src/script.sh"]
EXPOSE 80
