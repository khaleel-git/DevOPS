# Setting Up SSH Access for Ansible on Fedora VM

## Enable SSH on Fedora VM

1. **Install SSH Server:**
   If SSH server (`sshd`) is not already installed on your Fedora VM, you can install it using the following command:
   ```bash
   sudo dnf install openssh-server
    ```

2. **Start and Enable SSH Service:**
   ```bash
    sudo systemctl start sshd
    sudo systemctl enable sshd
    
