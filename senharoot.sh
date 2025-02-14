```bash
#!/bin/bash
# Script para configurar o SSH e permitir o login do root com autenticação por senha

# Verifica se o usuário é root
if [[ "$(whoami)" != "root" ]]; then
    echo -e "\033[1;31mEste script deve ser executado como root. Use \033[1;33msudo -i\033[1;31m e tente novamente.\033[0m"
    exit 1
fi

# Atualiza o arquivo de configuração do SSH
echo -e "\033[1;32mConfigurando o SSH...\033[0m"
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#*ChallengeResponseAuthentication.*/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config

# Reinicia o serviço SSH para aplicar as alterações
echo -e "\033[1;32mReiniciando o serviço SSH...\033[0m"
systemctl restart ssh

# Define uma nova senha para o usuário root
echo -e "\033[1;32mDefinindo uma nova senha para o usuário root...\033[0m"
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
```

### Explicação do Script:
1. **Verificação de Root**:
   - O script verifica se está sendo executado como root. Caso contrário, ele exibe uma mensagem de erro e encerra.

2. **Configuração do SSH**:
   - O script usa o comando `sed` para modificar o arquivo `/etc/ssh/sshd_config`:
     - Habilita a autenticação por senha (`PasswordAuthentication yes`).
     - Habilita a autenticação por desafio-resposta (`ChallengeResponseAuthentication yes`).
     - Desabilita a autenticação por chave pública (`PubkeyAuthentication no`).
     - Permite o login do root (`PermitRootLogin yes`).

3. **Reinício do SSH**:
   - O serviço SSH é reiniciado para aplicar as alterações.

4. **Definição da Senha do Root**:
   - O script solicita ao usuário que digite e confirme a nova senha do root. Se as senhas coincidirem e não estiverem vazias, a senha é alterada usando o comando `chpasswd`.

5. **Conclusão**:
   - Uma mensagem de sucesso é exibida ao final do processo.

### Como Usar:
1. Salve o script em um arquivo, por exemplo, `configurar_ssh.sh`.
2. Torne o script executável:
   ```bash
   chmod +x configurar_ssh.sh
   ```
3. Execute o script como root:
   ```bash
   sudo ./configurar_ssh.sh
   ```
