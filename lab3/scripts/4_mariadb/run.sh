sudo mkdir -p /home/DB
docker run -d --name lab3-mariadb \
-e MARIADB_ROOT_PASSWORD=lab3-root \
-p 3306:3306 \
-v /home/DB:/var/lib/mysql \
mariadb

docker exec lab3-mariadb mariadb -uroot -plab3-root -e "CREATE DATABASE ankudinov; SHOW DATABASES;"
sudo ls -la /home/DB
