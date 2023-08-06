#!/bin/bash

for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do apt-get remove $pkg; done

apt-get update
echo -e "\n\n -------------------------------------------------------- \n\n"

apt-get install ca-certificates curl gnupg -y
echo -e "\n\n -------------------------------------------------------- \n\n"

install -m 0755 -d /etc/apt/keyrings
echo -e "\n\n -------------------------------------------------------- \n\n"

curl -fSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo -e "\n\n -------------------------------------------------------- \n\n"

chmod a+r /etc/apt/keyrings/docker.gpg
echo -e "\n\n -------------------------------------------------------- \n\n"

echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
tee /etc/apt/sources.list.d/docker.list
echo -e "\n\n -------------------------------------------------------- \n\n"

apt-get update
echo -e "\n\n -------------------------------------------------------- \n\n"

apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
echo -e "\n\n -------------------------------------------------------- \n\n"

docker run hello-world
echo -e "\n\n -------------------------------------------------------- \n\n"

# install postgres from docker

# look for the file with the environment variables
echo -e "\n\n -------------------------------------------------------- \n\n"
if [[ -f .env ]];
then
  echo "The .env exists"
  env=.env
elif [[ -f /etc/secrets/.env ]];
then
  echo "The /etc/secrets/.env exists"
  env=/etc/secrets/.env
fi

echo -e "\n\n -------------------------------------------------------- \n\n"
echo "Echoing the cat command ----------------------------------"
cat $env

# if that file exists read it
echo -e "\n\n -------------------------------------------------------- \n\n"
if [[ $env ]];
then
  while IFS= read -r line
  do
    echo $(echo $line | awk -F '=' '{print $1}')
    if [[  $(echo $line | awk -F '=' '{print $1}') == "POSTGRES_PASSWORD" ]];
    then
      echo $(echo $line | awk -F '=' '{print $2}');
      # docker run --name some-postgres -e POSTGRES_PASSWORD=$(echo $line | awk -F '=' '{print $2}') -p 80:5432 -d postgres;
      docker ps;
    fi
  done < $env
else
  echo "Both .env and /etc/secrets/.env doesn't exists"
fi

echo -e "\n\n -------------------------------------------------------- \n\n"
uname -a;
