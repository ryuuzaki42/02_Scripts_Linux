#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Criticas "construtiva"
# Mande me um e-mail. Ficarei Grato!
# e-mail: joao42lbatista@gmail.com
#
# Este programa é um software livre; você pode redistribui-lo e/ou
# modifica-lo dentro dos termos da Licença Pública Geral GNU como
# publicada pela Fundação do Software Livre (FSF); na versão 2 da
# Licença, ou (na sua opinião) qualquer versão.
#
# Este programa é distribuído na esperança que possa ser útil,
# mas SEM NENHUMA GARANTIA; sem uma garantia implícita de ADEQUAÇÃO a
# qualquer MERCADO ou APLICAÇÃO EM PARTICULAR.
#
# Veja a Licença Pública Geral GNU para maiores detalhes.
# Você deve ter recebido uma cópia da Licença Pública Geral GNU
# junto com este programa, se não, escreva para a Fundação do Software
#
# Livre(FSF) Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
#
# Script: limpeza no sistema (irá precisar do bleachbit estar instalado) e desligar
#
# Última atualização: 05/01/2016
#
if [ $LOGNAME = root ]; then
 echo -e "\n\terro, execute como usuário comum!\n"
 exit 0
fi

echo -e "\nEste script(para slackware) vai Limpar o seu sistema e Desligar!"
echo "Necessário ter bleachbit instalado e configurado."
echo "Irá executar o bleachbit como root e como usuário corrente."
echo "Além de apagar algumas pastas e arquivos."
echo "Usuário corrente:$LOGNAME"
echo "Comandos a serem executados:"
echo "bleachbit -c --preset"
echo "su - root -c \"bleachbit -c --preset"
echo "bleachbit -c --preset"
echo "rm -rfv /tmp/*"
echo "rm -rfv /tmp/.*"
echo "rm -rfv /var/tmp/*"
echo "rm -rfv /var/tmp/.*"
echo "rm /home/$LOGNAME/.bash_history"
echo "rm /root/.bash_history"
echo "halt\""
echo -e "Deseja continuar \n   (y)es \n   (n)o!"
read RESPOSTA

if [ $RESPOSTA = y ]; then
  bleachbit -c --preset
  echo -e "\n\nTerminou de executar o bleachbit como usuário comum logado"
  echo "Agora digite a senha do usuário root para executar como ele <root>:"
  su - root -c "bleachbit -c --preset
  rm -rfv /tmp/*
  rm -rfv /tmp/.*
  rm -rfv /var/tmp/*
  rm -rfv /var/tmp/.*
  echo \"REBOOT!\"
  rm /home/'$LOGNAME'/.bash_history
  rm /root/.bash_history
  halt"
fi

if [ $RESPOSTA = n ]; then
  echo -e "fim do script \n"
  exit 0
fi
#