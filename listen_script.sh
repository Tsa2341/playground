#! /bin/bash

echo "root" | su - root


pwd
cat /etc/shadow

echo -e "\n"

netstat -an | grep LISTEN

echo -e "\n"

ls /etc

echo -e "\n"

ls /usr/bin