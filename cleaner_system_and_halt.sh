#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Criticas "construtiva"
# Mande me um e-mail. Ficarei Grato!
# e-mail  joao42lbatista@gmail.com
#
# Este programa é um software livre; você pode redistribui-lo e/ou 
# modifica-lo dentro dos termos da Licença Pública Geral GNU como 
# publicada pela Fundação do Software Livre (FSF); na versão 2 da 
# Licença, ou (na sua opinião) qualquer versão.
#
# Este programa é distribuído na esperança que possa ser  útil, 
# mas SEM NENHUMA GARANTIA; sem uma garantia implícita de ADEQUAÇÃO a 
# qualquer MERCADO ou APLICAÇÃO EM PARTICULAR. 
#
# Veja a Licença Pública Geral GNU para maiores detalhes.
# Você deve ter recebido uma cópia da Licença Pública Geral GNU
# junto com este programa, se não, escreva para a Fundação do Software
#
# Livre(FSF) Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
#
# Script: limpeza no sistema (irá precisar do bleachbit estar instalado) e deligar
#
# Última atualização: 22/11/2015
#
user_current=`whoami`
if [ $user_current = root ]
 then
 echo -e "\t\terro, execute como usuário comum!\n"
 exit 0
fi
echo "Este script(para slackware) vai Limpar o seu sistema e Desligar!"
echo "Necessário ter bleachbit instalado e configurado."
echo "Irá executar o bleachbit como root e como usuário corrente."
echo "Além de apagar algumas pastas e arquivos."
echo "Usuário corrente:$user_current"
echo "Comandos a serem executados:"
echo "'su - root -c su - $user_current -c \"bleachbit -c --preset\""
echo "bleachbit -c --preset"
echo "rm -rfv /tmp/*"
echo "rm -rfv /tmp/.*"
echo "rm -rfv /var/tmp/*"
echo "rm -rfv /var/tmp/.*"
echo "rm /home/$user_current/.bash_history"
echo "rm /root/.bash_history"
echo "halt'"
echo -e "   Deseja continuar \n   (y)es \n   (n)o!"
read resposta
if [ $resposta = y ]
  then
  echo -e "Digite a senha do usuário root"
  su - root -c 'su - $user_current -c "bleachbit -c --preset"
  bleachbit -c --preset
  rm -rfv /tmp/*
  rm -rfv /tmp/.*
  rm -rfv /var/tmp/*
  rm -rfv /var/tmp/.*
  echo "halt"
  rm /home/'$user_current'/.bash_history
  rm /root/.bash_history
  halt'
fi
if [ $resposta = n ] 
  then
  echo -e "fim do script \n"
  exit 0
fi
#