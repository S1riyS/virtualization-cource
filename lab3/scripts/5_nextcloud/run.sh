sudo mkdir -p /home/www/NextCloud
docker run -d --name lab3-nextcloud -p 8088:80 -v /home/www/NextCloud:/var/www/html nextcloud
