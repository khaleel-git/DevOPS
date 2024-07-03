# Setting Up SSH Access for Ubuntu VM

## Enable SSH on Ubuntu Virtual Machine

1. **Install SSH Server:**
   If SSH server (`sshd`) is not already installed on your Fedora VM, you can install it using the following command:
```bash
   sudo apt update
   sudo apt install openssh-server
```

2. **Start and Enable SSH Service:**
```bash
    sudo systemctl start sshd
    sudo systemctl enable sshd
```

3. **Configure Firewall:**
```bash
    sudo ufw allow ssh
    sudo ufw enable
```

4. **Firewall for IP Tables**
```bash
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables-save > /etc/iptables/rules.v4
```

# Determine IP Address of Fedora VM
`ip a`

## check external (public) dynamic ip address:
```bash
    curl ifconfig.io
    curl ipinfo.io/ip
```



