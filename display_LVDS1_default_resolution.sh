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
# Script: script para definir a resolução padrão do monitor do notebook (LVDS1)
# para o padrão, caso o cabo do VGA1 ou HDMI1 seja removido
#
# Última atualização: 28/03/2016
#
echo -e "\nEste script setar o monitor (LVDS1) para resolução padrão, caso a saída VGA1 ou HDMI1 seja removida \n"

LVDS1_resolution=`xrandr  | grep \+ | grep -v +0 | cut -d' ' -f4 | sed -n "1p"`

while [[ true ]]; do
    value=$(xrandr | grep "*+")
    if [ "$value" == '' ]; then
        xrandr --output LVDS1 --mode $LVDS1_resolution --primary
        xrandr --output VGA1 --off
        xrandr --output HDMI1 --off
    fi
    sleep 1s
done
#