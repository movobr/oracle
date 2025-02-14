#!/bin/bash

# Função para exibir mensagens coloridas
print_message() {
    local color=$1
    local message=$2
    echo -e "\033[${color}m${message}\033[0m"
}

# Passo 1: Muda para o usuário root (sudo -s)
if [[ "$(id -u)" -ne 0 ]]; then
    print_message "1;31mErro:\033[0m Este script deve ser executado como root."
    exit 1
fi
print_message "1;32mPasso 1: Usuário root confirmado.\033[0m"

# Passo 2: Volta ao diretório home (cd)
cd
print_message "1;32mPasso 2: Diretório home acessado.\033[0m"

# Passo 3: Edita o arquivo /etc/ssh/sshd_config
print_message "1;33mPasso 3: Atualizando o arquivo /etc/ssh/sshd_config...\033[0m"

# Faz backup do arquivo original
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
if [[ $? -ne 0 ]]; then
    print_message "1;31mFalha ao criar backup do arquivo sshd_config.\033[0m"
    exit 1
fi
print_message "1;32mBackup criado em /etc/ssh/sshd_config.backup\033[0m"

# Atualiza o arquivo sshd_config conforme especificado
cat <<EOF > /etc/ssh/sshd_config
#LoginGraceTime 2m
ChallengeResponseAuthentication yes
PermitRootLogin yes
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

# To disable tunneled clear text passwords, change to no here!
PasswordAuthentication yes
#PermitEmptyPasswords no
EOF

# Verifica se a sintaxe do arquivo sshd_config está correta
sshd -t
if [[ $? -ne 0 ]]; then
    print_message "1;31mErro na sintaxe do arquivo /etc/ssh/sshd_config. Verifique o arquivo.\033[0m"
    exit 1
fi
print_message "1;32mArquivo /etc/ssh/sshd_config atualizado com sucesso.\033[0m"

# Passo 4: Define a senha do root
print_message "1;33mPasso 4: Definindo a senha do root...\033[0m"
while true; do
    passwd root
    if [[ $? -eq 0 ]]; then
        print_message "1;32mSenha do root definida com sucesso!\033[0m"
        break
    else
        print_message "1;31mFalha ao definir a senha. Tente novamente.\033[0m"
    fi
done

# Passo 5: Reinicia o serviço SSH
print_message "1;33mPasso 5: Reiniciando o serviço SSH...\033[0m"
systemctl restart ssh
if systemctl is-active --quiet ssh; then
    print_message "1;32mServiço SSH reiniciado com sucesso!\033[0m"
else
    print_message "1;31mFalha ao reiniciar o serviço SSH. Verifique os logs.\033[0m"
    exit 1
fi

# Mensagem final
print_message "1;32mConfiguração concluída! Agora você pode acessar o servidor como root usando a senha definida.\033[0m"
