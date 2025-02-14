#!/bin/bash

# Função para exibir mensagens coloridas
print_message() {
    local color=$1
    local message=$2
    echo -e "\033[${color}m${message}\033[0m"
}

# Verifica se o usuário é root
if [[ "$(id -u)" -ne 0 ]]; then
    print_message "1;31mErro:\033[0m Este script deve ser executado como root."
    exit 1
fi

# Faz backup do arquivo sshd_config
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
print_message "1;33mBackup do arquivo sshd_config criado em /etc/ssh/sshd_config.backup\033[0m"

# Atualiza o arquivo sshd_config
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i '/^PasswordAuthentication no/d' /etc/ssh/sshd_config
sed -i '/^#PasswordAuthentication no/d' /etc/ssh/sshd_config

# Reinicia o serviço SSH
systemctl restart ssh
if systemctl is-active --quiet ssh; then
    print_message "1;32mServiço SSH reiniciado com sucesso!\033[0m"
else
    print_message "1;31mFalha ao reiniciar o serviço SSH. Verifique os logs.\033[0m"
    exit 1
fi

# Configuração de firewall (permite apenas portas 80 e 443)
iptables -F
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -P INPUT DROP
print_message "1;32mRegras de firewall configuradas: Portas 80 e 443 habilitadas.\033[0m"

# Define a nova senha do root
while true; do
    print_message "1;32mDigite sua nova senha root:\033[0m "
    read -s senha
    echo
    if [[ -n "$senha" ]]; then
        echo "root:$senha" | chpasswd
        print_message "1;32mSenha do root alterada com sucesso!\033[0m"
        break
    else
        print_message "1;31mA senha não pode estar vazia. Tente novamente.\033[0m"
    fi
done

# Mensagem final
print_message "1;32mConfiguração concluída! Agora você pode se conectar como root usando a senha definida.\033[0m"
