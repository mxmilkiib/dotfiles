pacman -Sqn > pacman.packages
pacman -Qii | awk '/^MODIFIED/ {print $2}' | xargs -I cp {} ./config/
