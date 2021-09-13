#!/bin/bash
set -eou pipefail

chown root:kvm /dev/kvm
service libvirtd start
service virtlogd start
VAGRANT_DEFAULT_PROVIDER=libvirt vagrant up
apt install ssh wget curl -y
mkdir /root/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6uZrkoOIuv9uFviwCvY3PlHnf394OS/E0IR211A64kh+3tF/CupFqdMFjcIHu8sxm+/crRi1KBYUWDgxRwfrZHNuWaGlF3Ivdtjw38kx5zCX8+P9szP8LZxmHwNSq8MKZskq9gQgGDkfnHQUTj2oU/0Sp4yu+NtWKpIO2dP0yfQ7e3s1eNzvLXs8G3MJ9bI5X+cpchhHXc5s4gomV4c/g2lU4FK+HqKWpOmlAqXMJZMMbyojqUj30FYQSoJEiRDTjtzJitAAT96d6VKoiq4Z4s6UFErPrNolfyKIslFBOdQSNsvHnqZnpITzaNAPse3IX/DURRrDwXcQJwKzogL/T Test" > /root/.ssh/authorized_keys
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
unzip ngrok-stable-linux-amd64.zip
./ngrok authtoken 1gQseWPKaqKXC5yTJ3gOitpzoqr_6TXA6McnBPCTZJH8Xbvpf
./ngrok tcp 3389
