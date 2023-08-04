#!/bin/bash

echo "Echoing the pwd command ----------------------------------"
pwd
echo "Echoing the ls command ----------------------------------"
ls

# look for the file with the environment variables
if [[ -f .env ]];
then
  echo "The .env exists"
  env=.env
elif [[ -f /etc/secrets/.env ]];
then
  echo "The /etc/secrets/.env exists"
  env=/etc/secrets/.env
fi

# if that file exists read it
if [[ $env ]];
then
  while IFS= read -r line
  do
    # echo $(echo $line | awk -F '=' '{print $1}')
    if [[  $(echo $line | awk -F '=' '{print $1}') == "POSTGRES_PASSWORD" ]];
    then
      echo $(echo $line | awk -F '=' '{print $2}')
      docker run --name some-postgres -e POSTGRES_PASSWORD=$(echo $line | awk -F '=' '{print $2}') -p 80:5432 -d postgres
      docker ps
    fi
  done < $env
else
  echo "Both .env and /etc/secrets/.env doesn't exists"
fi

# uname -a;
