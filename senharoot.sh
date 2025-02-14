Entendi. Vamos ver a diferença principal entre os dois scripts e o motivo pelo qual você não foi solicitado a fornecer a senha de root no segundo script.

### Diferença Principal:

1. **Verificação da Senha Root:**
   - No **segundo script**, a verificação para determinar se a senha root foi solicitada está ausente:
     ```bash
     [[ "$(whoami)" != "root" ]] && {
         clear
         echo -e "\033[1;31me lá vamos nós, usuário root, \033[1;32m(\033[1;33msudo -i\033[1;32m)\033[0m"
         exit
     }
     ```

2. **Definir Nova Senha Root:**
   - No **segundo script**, o pedido de senha não foi implementado corretamente. Ele foi interrompido devido ao comando `chpasswd` não sendo executado ou o comando `chpasswd` não sendo bem formatado:
     ```bash
     clear && echo -ne "\033[1;32mDigite sua nova senha root\033[1;37m: "; read -s senha
     [[ -z "$senha" ]] && {
         echo -e "\n\033[1;31mCalma barboleta, vê se não erra de novo\033[0m"
         exit 0
     }
     echo "root:$senha" | chpasswd
     echo -e "\n\033[1;31m[ \033[1;33mSucesso \033[1;31m]\033
     ```

### Melhorias:

1. **Certifique-se de que `read` esteja configurado corretamente para ocultar a senha:**
   ```bash
   clear && echo -ne "\033[1;32mDigite sua nova senha root\033[1;37m: "; read -s senha
   [[ -z "$senha" ]] && {
       echo -e "\n\033[1;31mCalma barboleta, vê se não erra de novo\033[0m"
       exit 0
   }
   echo "root:$senha" | chpasswd
   echo -e "\n\033[1;31m[ \033[1;33mSucesso \033[1;31m]\033
   ```

2. **Reiniciar o Serviço SSH:**
   ```bash
   sudo systemctl restart ssh > /dev/null
   ```

Se o segundo script não pediu a senha, é possível que ele tenha pulado essa etapa. Certifique-se de que o script seja executado corretamente e que o comando `chpasswd` esteja formatado corretamente para definir a senha root.

Se precisar de mais assistência ou tiver dúvidas, estarei aqui para ajudar!
