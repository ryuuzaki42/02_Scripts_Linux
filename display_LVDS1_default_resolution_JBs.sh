#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Críticas "construtivas"
# me envie um e-mail. Ficarei Grato!
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
# Script: Define a resolução padrão do monitor do notebook (LVDS1)
# para o padrão, caso o cabo do VGA1 ou HDMI1 seja removido
#
# Last update: 19/06/2023
#
echo -e "\nDefine o LVDS1 (notebook display) para resolução padrão, caso a saída VGA1 ou HDMI1 seja removida\n"

LVDS1_resolution=$(xrandr | grep "\\+" | grep -v "+0" | cut -d ' ' -f4 | sed -n "1p")

while true; do
    value=$(xrandr | grep "\\*+")
    if [ "$value" == '' ]; then
        xrandr --output LVDS1 --mode "$LVDS1_resolution" --primary
        xrandr --output VGA1 --off
        xrandr --output HDMI1 --off
    fi
    sleep 5s
done
