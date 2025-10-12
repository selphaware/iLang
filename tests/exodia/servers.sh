sudo nano /etc/pacman.d/mirrorlist

##
## Arch Linux mirrorlist (example reset)
##

Server = https://mirror.rackspace.com/archlinux/$repo/os/$arch
Server = https://mirror.osbeck.com/archlinux/$repo/os/$arch
Server = https://mirror.arizona.edu/archlinux/$repo/os/$arch
Server = https://mirror.mia11.us.leaseweb.net/archlinux/$repo/os/$arch
Server = https://mirror.pit.teraswitch.com/archlinux/$repo/os/$arch
Server = https://archlinux.uk.mirror.allworldit.com/archlinux/$repo/os/$arch

# Press Ctrl + O → Enter → Ctrl + X

sudo pacman -Syy

sudo pacman -Syu

sudo pacman -S reflector

sudo reflector --country 'United States,Canada' --age 12 --protocol https --sort rate \
  --save /etc/pacman.d/mirrorlist

sudo pacman -Syyu
