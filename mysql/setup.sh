mysql -u root --password=$MYSQL_ROOT_PASSWORD -e "CREATE USER devprom@localhost IDENTIFIED BY '$MYSQL_PASSWORD'"
mysql -u root --password=$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO 'devprom'@'%' WITH GRANT OPTION"
