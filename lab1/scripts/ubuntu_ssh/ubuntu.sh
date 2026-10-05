# Ставим openssh сервер
sudo apt update
sudo apt install -y openssh-server

# Включаем ssh сервер
sudo systemctl enable --now ssh
sudo systemctl status ssh