#!/bin/bash
# Script para configurar SSH e definir senha do root

# Verifica se o usuário é root
if [[ "$(whoami)" != "root" ]]; then
    echo -e "\033[1;31mEste script deve ser executado como root. Use \033[1;33msudo -i\033[1;31m e tente novamente.\033[0m"
    exit 1
fi

# Configura o SSH
echo -e "\033[1;32mConfigurando o SSH...\033[0m"
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart ssh

# Define a senha do root
echo -e "\033[1;32mDefinindo uma nova senha para o root...\033[0m"
while true; do
    echo -ne "\033[1;37mDigite a nova senha root: \033[0m"
    read -s senha
    echo
    echo -ne "\033[1;37mConfirme a nova senha root: \033[0m"
    read -s senha_confirmacao
    echo

    if [[ "$senha" == "$senha_confirmacao" && -n "$senha" ]]; then
        echo "root:$senha" | chpasswd
        echo -e "\033[1;32mSenha do root alterada com sucesso!\033[0m"
        break
    else
        echo -e "\033[1;31mAs senhas não coincidem ou estão vazias. Tente novamente.\033[0m"
    fi
done

echo -e "\033[1;32mConfiguração concluída! Agora você pode se conectar como root usando a senha definida.\033[0m"
