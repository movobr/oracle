#!/bin/bash

# Script para configurar SSH e definir senha do root

# Verifica se o usuário é root
if [[ "$(whoami)" != "root" ]]; then
    echo -e "\033[1;31mEste script deve ser executado como root. Use \033[1;33msudo -i\033[1;31m e tente novamente.\033[0m"
    exit 1
fi

# Função para exibir mensagens coloridas
print_message() {
    local color=$1
    local message=$2
    echo -e "\033[${color}m${message}\033[0m"
}

# Configura o SSH
print_message "1;32mConfigurando o SSH...\033[0m"

# Backup do arquivo de configuração original
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
print_message "1;33mBackup do arquivo sshd_config criado em /etc/ssh/sshd_config.backup\033[0m"

# Atualiza as configurações no arquivo sshd_config
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#\?ChallengeResponseAuthentication.*/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config

# Adiciona comentários adicionais (se necessário)
grep -q "^# Authentication:" /etc/ssh/sshd_config || echo -e "\n# Authentication:\n#LoginGraceTime 2m\nChallengeResponseAuthentication yes\nPermitRootLogin yes\n#StrictModes yes\n#MaxAuthTries 6\n#MaxSessions 10\nPubkeyAuthentication no\nPasswordAuthentication yes" >> /etc/ssh/sshd_config

print_message "1;32mSSH configurado com sucesso!\033[0m"

# Define a senha do root
print_message "1;32mDefinindo uma nova senha para o root...\033[0m"
while true; do
    echo -ne "\033[1;37mDigite a nova senha root: \033[0m"
    read -s senha
    echo
    echo -ne "\033[1;37mConfirme a nova senha root: \033[0m"
    read -s senha_confirmacao
    echo
    if [[ "$senha" == "$senha_confirmacao" && -n "$senha" ]]; then
        echo "root:$senha" | chpasswd
        print_message "1;32mSenha do root alterada com sucesso!\033[0m"
        break
    else
        print_message "1;31mAs senhas não coincidem ou estão vazias. Tente novamente.\033[0m"
    fi
done

# Reinicia o serviço SSH
print_message "1;32mReiniciando o serviço SSH...\033[0m"
systemctl restart ssh

# Verifica se o serviço SSH foi reiniciado com sucesso
if systemctl is-active --quiet ssh; then
    print_message "1;32mServiço SSH reiniciado com sucesso!\033[0m"
else
    print_message "1;31mFalha ao reiniciar o serviço SSH. Verifique os logs.\033[0m"
    exit 1
fi

# Mensagem final
print_message "1;32mConfiguração concluída! Agora você pode se conectar como root usando a senha definida.\033[0m"
print_message "1;32mUse o comando: ssh root@<server-ip-address>\033[0m"
