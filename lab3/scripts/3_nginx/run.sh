sudo mkdir -p /home/www/html
sudo cp index.html /home/www/html/index.html
docker build -t lab3-web .
docker run -d --name lab3-nginx -p 8080:8080 -v /home/www/html:/usr/share/nginx/html:ro lab3-web
