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
# Script: exemplo de script com funções, por exemplo a de ajuda/help
#
# Última atualização: 02/08/2017
#
start() {
    clear
    echo "start"
}

stop() {
    clear
    echo "stop"
}

help() {
    echo "########################"
    echo "Isto e o help"
}

case "$1" in
    'start')
        start
        ;;
    'stop')
        stop
        ;;
    '--help')
        help
        ;;
    *)
        echo "usage $0 start|stop|--help"
esac
