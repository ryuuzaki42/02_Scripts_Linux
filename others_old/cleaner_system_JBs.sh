#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Críticas "construtivas"
# me envie um e-mail. Ficarei Grato!
# e-mail: joao42lbatista@gmail.com
#
# Este programa é um software livre: você pode redistribuí-lo e/ou
# modificá-lo sob os termos da Licença Pública Geral GNU (GPL)
# conforme publicada pela Free Software Foundation, tanto a versão 3
# da licença, como (a seu critério) qualquer versão posterior.
#
# Este programa é distribuído na esperança de que seja útil,
# mas SEM NENHUMA GARANTIA; nem mesmo a garantia implícita de
# COMERCIABILIDADE ou ADEQUAÇÃO A UM PROPÓSITO ESPECÍFICO.
# Consulte a Licença Pública Geral do GNU para mais detalhes.
#
# Script: Clean up the system (need Bleachbit installed) and reboot/halt
#
# Last update: 14/11/2017
#
if [ "$LOGNAME" == "root" ]; then
    echo -e "\\n\\tErro, execute como usuário comum!\\n"
else
    echo -e "\\nEste script (para Slackware) vai Limpar o seu sistema!"
    echo -e "\\nNecessário ter Bleachbit instalado e configurado!"
    echo "Irá executar o Bleachbit como root e como usuário corrente."
    echo "Além de apagar algumas pastas e arquivos."

    echo -en "\\nApós a limpar o sistema, deseja (d)esligar ou (r)einiciar: "
    read -r rebootOrHalt

    if [ "$rebootOrHalt" == 'd' ] || [ "$rebootOrHalt" == 'r' ]; then
        if [ "$rebootOrHalt" == 'd' ]; then
            rebootOrHalt="halt"
        elif [ "$rebootOrHalt" == 'r' ]; then
            rebootOrHalt="reboot"
        fi
        export rebootOrHalt

        echo -e "\\nUsuário corrente:$LOGNAME"
        echo -e "\\nComandos a serem executados:"
        echo "bleachbit -c --preset"
        echo "su - root -c \"bleachbit -c --preset"
        echo "rm -rfv /tmp/*"
        echo "rm -rfv /tmp/.*"
        echo "rm -rfv /var/tmp/*"
        echo "rm -rfv /var/tmp/.*"
        echo "rm /home/$LOGNAME/.bash_history"
        echo "rm /root/.bash_history"
        echo "$rebootOrHalt\""

        echo -en "\\nDeseja continuar: \\n(y)es - (n)o: "
        read -r continueOrNot

        if [ "$continueOrNot" == 'y' ]; then
            bleachbit -c --preset
            echo -e "\\nTerminou de executar o bleachbit como usuário comum logado"
            echo "Agora digite a senha do usuário root para executar como ele"
            su - root -c "bleachbit -c --preset
            rm -rfv /tmp/*
            rm -rfv /tmp/.*
            rm -rfv /var/tmp/*
            rm -rfv /var/tmp/.*
            echo \"REBOOT!\"
            rm /home/'$LOGNAME'/.bash_history
            rm /root/.bash_history
            $rebootOrHalt"
        fi
     else
        echo -e "\\n\\tNenhuma mudança foi feita"
    fi
fi
echo -e "\\nFim do script\\n"
