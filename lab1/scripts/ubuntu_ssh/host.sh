# Настроить проброс портов (Ubuntu:22 -> Host:2222)
VBoxManage modifyvm "WS_AKK_ubuntu" --natpf1 "guestssh,tcp,,2222,,22"

# Запускаем Ubuntu в фоне
VBoxManage startvm "WS_AKK_ubuntu" --type headless

# Подключаемся по SSH
ssh -p 2222 -o PubkeyAuthentication=no kirill@127.0.0.1
# или
ssh ubuntu-vbox # (добавил в ~/.ssh/config)