#!/bin/bash
# Lab 1 - PC side: LAN IP, DHCP server, IP forwarding and NAT.
# Replace WAN/LAN with your own interface names (find them with `ip a`).
WAN=eno2
LAN=enxc8a362e30306

# Give the PC's LAN port its IP (resets every session)
sudo nmcli device set $LAN managed no
sudo ip addr add 192.168.1.100/24 dev $LAN

# DHCP server (only needed until the Pis have static IPs - Task 4 disables it)
sudo apt-get install -y isc-dhcp-server
sudo systemctl restart isc-dhcp-server
sudo systemctl enable isc-dhcp-server

# IP forwarding (also uncomment net.ipv4.ip_forward=1 in /etc/sysctl.conf)
sudo sysctl -w net.ipv4.ip_forward=1

# NAT so the Pis can reach the internet through the PC
sudo iptables -t nat -A POSTROUTING -o $WAN -j MASQUERADE
sudo iptables -A FORWARD -i $WAN -o $LAN -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i $LAN -o $WAN -j ACCEPT
sudo apt install -y iptables-persistent      # answer Yes to save rules
