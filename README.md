# Monitoramento ZFS Zabbix

Template desenvolvido por: pbergdolt [(Saiba Mais)](https://www.zabbix.com/forum/zabbix-cookbook/35336-zabbix-zfs-discovery-monitoring)

## Autoconfiguração:

Para configurar os recursos necessários para utilizar o template, empregue o script de autoconfiguração disponível em [https://github.com/git-giantit/ZFSZabbixMonitoring](https://github.com/git-giantit/ZFSZabbixMonitoring). Este script é responsável por baixar, mover os arquivos essenciais, conceder as permissões necessárias para o zabbix-agent e configurar os parâmetros personalizados.
> [!IMPORTANT]
> A instalação e configuração prévia do Zabbix Agente é necessária.

### Passos:

1. Baixe o template correspondente à versão do seu Zabbix, disponível no repositório [aqui](https://github.com/git-giantit/ZFSZabbixMonitoring), e importe no seu servidor, bem como no host que deseja monitorar.
2. Para executar o script de autoconfiguração, utilize o comando abaixo:
    
    ```bash
    bash -c "$(curl -fsSL <https://raw.githubusercontent.com/git-giantit/ZFSZabbixMonitoring/main/install.sh>)"
    ```
    

## Configuração manual:

Caso prefira configurar o monitoramento manualmente, siga os passos abaixo:

> [!IMPORTANT]
> A instalação e configuração prévia do Zabbix Agente é necessária.
1. Baixe o template correspondente à versão do seu Zabbix, disponível no repositório [aqui](https://github.com/git-giantit/ZFSZabbixMonitoring), e importe no seu servidor, bem como no host que deseja monitorar.

2. Edite o arquivo sudoers:
    
    ```bash
    nano /etc/sudoers.d/zabbix
    ```
    
3. Adicione a seguinte linha:
    
    ```
    zabbix ALL=NOPASSWD: /usr/bin/traceroute,/bin/ping,/usr/bin/nmap,/usr/bin/fping,/usr/sbin/fping,/sbin/zpool,/sbin/zfs,/bin/sed
    ```
    
4. Crie o arquivo userparameter_zfs.conf:
    
    ```
    nano /etc/zabbix/zabbix_agentd.d/userparameter_zfs.conf
    ```
    
5. Insira o conteúdo a seguir no arquivo criado:
    
    ```
    #ZFS parameter
    UserParameter=zfs.pool.discovery,/sbin/zpool list -H -o name | /bin/sed -e '$ ! s/\\(.*\\)/{"{#POOLNAME}":"\\1"},/' | /bin/sed -e '$  s/\\(.*\\)/{"{#POOLNAME}":"\\1"}]}/' | /bin/sed -e '1 i { \\"data\\":['
    UserParameter=zfs.fileset.discovery,/sbin/zfs list -H -o name | /bin/sed -e '$ ! s/\\(.*\\)/{"{#FILESETNAME}":"\\1"},/' | sed -e '$  s/\\(.*\\)/{"{#FILESETNAME}":"\\1"}]}/' | /bin/sed -e '1 i { \\"data\\":['
    UserParameter=zfs.zpool.health[*],/sbin/zpool list -H -o health $1
    UserParameter=zfs.get.fsinfo[*],/usr/bin/sudo /sbin/zfs get -o value -Hp $2 $1
    UserParameter=status,/sbin/zpool list -H -o health
    
    #Mdadm raid parameter
    UserParameter=mdraid[*],/etc/zabbix/bin/zabbix_mdraid -m'$1' -$2'$3'
    UserParameter=mdraid.discovery,/etc/zabbix/bin/zabbix_mdraid -D
    ```
    
6. Reinicie o agente Zabbix:
    
    ```bash
    systemctl restart zabbix-agent
    
    ```
    

Por fim, se houver problemas durante o processo, verifique as configurações e tente novamente. Se o problema persistir, consulte a documentação do Zabbix para obter mais orientações.
