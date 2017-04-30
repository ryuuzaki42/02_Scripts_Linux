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
# Script: Focus - warning you about a $timeToFocus in work and 15 min of rest
#
# Last update: 30/04/2017
#
timeToFocus=$1
if echo "$timeToFocus" | grep -q -v "[[:digit:]]"; then
    timeToFocus='1'
fi

echo "Begin focus of $timeToFocus hour... $(echo; date)" > /dev/pts/0
sleep "$timeToFocus"h
echo "Break of 15 minutes... $(echo; date)" > /dev/pts/0
sleep 15m
echo "Break End... $(echo; date)" > /dev/pts/0
