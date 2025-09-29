#!/bin/bash

apt update
apt install python3 -y
apt install python3-pip -y
apt install python3-requests -y

mkdir -p /etc/websocket

repo="https://scvpn.serv00.net/os/"

wget -q -O /etc/websocket/ws.py "${repo}sshws/ws.py"
chmod +x /etc/websocket/ws.py

# Installing Service
cat > /etc/systemd/system/ws.service << END
[Unit]
Description=Websocket
Documentation=https://google.com
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python3 -O /etc/websocket/ws.py 10015
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl enable ws.service
systemctl start ws.service
systemctl restart ws.service

# Installing Service
cat > /etc/systemd/system/ws-ovpn.service << END
[Unit]
Description=OpenVPN
Documentation=https://google.com
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python3 -O /etc/websocket/ws.py 10012
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl enable ws-ovpn
systemctl start ws-ovpn
systemctl restart ws-ovpn
