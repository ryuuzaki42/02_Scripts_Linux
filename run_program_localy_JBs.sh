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
# Script: Run a program using $HOME in working directory ($PWD)
#
# Last update: 13/02/2026
#

set -x

HERE=$(pwd) # Here
echo -e "\nLocal place: $HERE\n"

# Folder to use as $HOME (~/)
mkdir 1_home/

# Folder to use as $XDG_CONFIG_HOME (~/.config/)
mkdir 2_config/

prog_name="$1" # Program name
remaining_args=("${@:2}") # Assign the remaining arguments

# Run the program using the new configurations folders
if [ "$remaining_args" == "" ]; then
    HOME="$HERE/1_home/" XDG_CONFIG_HOME="$HERE/2_config/" "./$prog_name"
else
    HOME="$HERE/1_home/" XDG_CONFIG_HOME="$HERE/2_config/" "./$prog_name" "$remaining_args"
fi
