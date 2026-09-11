#!/bin/bash
WIN="WS_AKK_win"
UBUNTU="WS_AKK_ubuntu"

is_running() {
  VBoxManage list runningvms | grep -q "\"$1\""
}

start_vm() {
  local name="$1"
  if is_running "$name"; then
    echo "$name already running"
  else
    VBoxManage startvm "$name" --type gui
  fi
}

echo "1 - Windows"
echo "2 - Ubuntu"
echo "3 - All"
echo "0 - Exit"
read -r -p "Choose: " choice
case "$choice" in
  1) start_vm "$WIN" ;;
  2) start_vm "$UBUNTU" ;;
  3)
    start_vm "$WIN"
    start_vm "$UBUNTU"
    ;;
esac
