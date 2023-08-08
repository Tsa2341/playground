#!/bin/bash
echo -e "\n\n -------------------------------------------------------- \n\n"
apt-get update
apt-get install -y lsb-release wget gnupg2 vim

echo -e "\n\n -------------------------------------------------------- \n\n"
release=$(lsb_release -c| awk '{ print $2 }')
echo "deb http://apt.postgresql.org/pub/repos/apt $release-pgdg main" > /etc/apt/sources.list.d/pgdg.list
wget -O ACCC4CF8.asc https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add ACCC4CF8.asc

echo -e "\n\n -------------------------------------------------------- \n\n"
apt-get update
apt-get -y install postgresql

echo -e "\n\n -------------------------------------------------------- \n\n"
service postgresql start
service postgresql status

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

if [[ $env ]];
then
  while IFS= read -r line;
  do
    if [[ $(echo $line | awk -F '=' '{print $1}') == "POSTGRES_USER_PASSWORD" ]];
    then
      password=$(echo $line | awk -F '=' '{print $2}')
      su - postgres -c "psql -U postgres -d postgres -c \"alter user postgres with password '$(echo $password)';\""
      echo -e "updated password successfully -----------------------------"
    fi
  done < $env;
fi

su - postgres # Enter postgres user executions

echo -e "\n\n ---------------------- change postgres port to 80 ---------------------------------- \n\n"
cd /etc/postgresql/15/main
sed -i '/port.\+=.\+[[:digit:]]\+/ s/[[:digit:]]\+/80/g' postgresql.conf
sed -i "/listen_addresses/ s/.\+listen_addresses.\+'.\+'/listen_addresses = '*'/g" postgresql.conf
cat postgresql.conf | grep -E port\\s\+=\\s\+[[:digit:]]\+\|listen_addresses

echo -e "\n\n ------------------------ Enable remote connections -------------------------------- \n\n"
sed -i "/^host\s\+all\s\+all\s\+[[:digit:]]\+.\+\/[[:digit:]]\+/ s/[[:digit:]]\+.\+\/[[:digit:]]\+/0.0.0.0\/0/g" pg_hba.conf
sed -n "/^host\s\+all\s\+all\s\+[[:digit:]]\+.\+\/[[:digit:]]\+/p" pg_hba.conf

su -  # Exit postgres user executions

echo -e "\n\n ------------------------ Restart postgres service -------------------------------- \n\n"
service postgresql restart
service postgresql status

# # if that file exists read it
# echo -e "\n\n -------------------------------------------------------- \n\n"
# if [[ $env ]];
# then
#   while IFS= read -r line
#   do
#     echo $(echo $line | awk -F '=' '{print $1}')
#     if [[  $(echo $line | awk -F '=' '{print $1}') == "POSTGRES_PASSWORD" ]];
#     then
#       echo $(echo $line | awk -F '=' '{print $2}');
#       # docker run --name some-postgres -e POSTGRES_PASSWORD=$(echo $line | awk -F '=' '{print $2}') -p 80:5432 -d postgres;
#       # docker ps;
#     fi
#   done < $env
# else
#   echo "Both .env and /etc/secrets/.env doesn't exists"
# fi

echo -e "\n\n -------------------------------------------------------- \n\n"
uname -a;

sleep infinity;