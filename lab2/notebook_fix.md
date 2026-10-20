# Ноутбук: вложенная Fedora в Ubuntu (VirtualBox)

Сразу после загрузки Fedora, до запуска VirtualBox:

```bash
sudo modprobe -r kvm_amd kvm
```

Если модуль занят (`Module kvm_amd is in use`), сначала остановить libvirt и повторить выгрузку. Пока Ubuntu работает, на хосте не открывать virt-manager и Boxes.

ISO лежит в `/home/kirill/`, не в общей папке Soft. Целый файл — 2816727040 байт. Проверка: `sudo checkisomd5 …iso` → `PASS`. В GRUB выбирать **Start Fedora-Xfce-Live**, не Test this media.

Внутренняя машина: 2048 МБ, CDROM первым в загрузке (шина SCSI). Чёрный экран при состоянии «работает» — подождать несколько минут.
