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
