#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Críticas "construtivas"
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
# Veja a Licença Pública Geral GNU para mais detalhes.
# Você deve ter recebido uma cópia da Licença Pública Geral GNU
# junto com este programa, se não, escreva para a Fundação do Software
#
# Livre(FSF) Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
#
# Script: foco - te avisa se já terminou as $1 hora(s) de trabalho
# depois 15 minutos de descanso
#
# Last update: 14/04/2017
#
timeToFoco=$1
if [ "$timeToFoco" == '' ]; then
    timeToFoco='1'
fi

echo "Begin Foco de $timeToFoco hora... $(echo; date)" > /dev/pts/0
sleep "$timeToFoco"h
echo "Break of 15 minutos... $(echo; date)" > /dev/pts/0
sleep 15m
echo "Break End... $(echo; date)" > /dev/pts/0
