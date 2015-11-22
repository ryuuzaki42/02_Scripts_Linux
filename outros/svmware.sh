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
# Script: iniciar o kernel do vmware em /etc/rc.d/init.d/vmware
#
# Última atualização: 22/11/2015
#
echo "Script para iniciar VMWARE"
echo -e "(i)niciar \n(p)arar \n(s)tatus \n(n)ada \n"
read resposta
if [ $resposta = i ] 
then
su root -c "sh /etc/rc.d/init.d/vmware start"
fi
if [ $resposta = p ] 
then
su root -c "sh /etc/rc.d/init.d/vmware stop"
fi
if [ $resposta = s ] 
then
su root -c "sh /etc/rc.d/init.d/vmware status"
fi
if [ $resposta = n ] 
then
exit 0
fi
echo -e "fim do script \n"