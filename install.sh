#!/bin/bash

# Função para baixar e mover arquivos
baixar_e_mover() {
    arquivo_url=$1
    destino=$2

    # Baixa o arquivo
    wget -O "$destino" "$arquivo_url"

    # Verifica se o download foi bem-sucedido
    if [ $? -eq 0 ]; then
        echo "Arquivo baixado com sucesso: $destino"
    else
        echo "Erro ao baixar o arquivo: $arquivo_url"
        exit 1
    fi
}

# Baixar e mover o arquivo zabbix_sudoers
baixar_e_mover "https://raw.githubusercontent.com/git-giantit/ZFSZabbixMonitoring/main/zabbix_sudoers" "/etc/sudoers.d/zabbix"

# Baixar e mover o arquivo userparameter_zfs.conf
baixar_e_mover "https://raw.githubusercontent.com/git-giantit/ZFSZabbixMonitoring/main/userparameter_zfs.conf" "/etc/zabbix/zabbix_agentd.d/userparameter_zfs.conf"

# Reiniciar o serviço zabbix-agente
systemctl restart zabbix-agent

echo "Serviço zabbix-agente reiniciado com sucesso."
