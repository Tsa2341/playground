FROM debian
COPY . /src
WORKDIR /src
CMD ["/bin/bash", "/src/postgres_setup.sh"]
EXPOSE 80
