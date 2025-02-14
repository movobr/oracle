#!/bin/bash
# Noob sofre
# nego não sabe entrar como Usuário root
clear
[[ "$(whoami)" != "root" ]] && {
    clear
    echo -e "\033[1;31me lá vamos nós, usuário root, \033[1;32m(\033[1;33msudo -i\033[1;32m)\033[0m"
    exit
}

# Editar arquivo de configuração SSH
sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/#ChallengeResponseAuthentication.*/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/ChallengeResponseAuthentication.*/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/#PubkeyAuthentication.*/PubkeyAuthentication no/' /etc/ssh/sshd_config
sed -i 's/PubkeyAuthentication.*/PubkeyAuthentication no/' /etc/ssh/sshd_config

# Reiniciar serviço SSH
sudo systemctl restart ssh > /dev/null

# Configurar firewall iptables (opcional)
iptables -F
iptables -A INPUT -p tcp --dport 81 -j REJECT
iptables -A INPUT -p tcp --dport 80 -j REJECT
iptables -A INPUT -p tcp --dport 443 -j REJECT
iptables -A INPUT -p tcp --dport 8799 -j REJECT
iptables -A INPUT -p tcp --dport 8080 -j REJECT
iptables -A INPUT -p tcp --dport 1194 -j REJECT

# Definir nova senha root
clear && echo -ne "\033[1;32mDigite sua nova senha root\033[1;37m: "; read -s senha
[[ -z "$senha" ]] && {
    echo -e "\n\033[1;31mCalma barboleta, vê se não erra de novo\033[0m"
    exit 0
}
echo "root:$senha" | chpasswd
echo -e "\n\033[1;31m[ \033[1;33mSucesso \033[1;31m]\033
