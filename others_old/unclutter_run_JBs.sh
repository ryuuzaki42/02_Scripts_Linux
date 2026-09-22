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
# Script: apenas para iniciar o unclutter, que esconder o cursor do mouse
# a cada 1 segundo se nenhum evento de movimento no mouse for detectado
#
# Last update: 15/04/2017
#
# Dica: Adicione este script para iniciar depois do X (pre-KDE startup)
#
# altere o valor de -idle, que é o tempo (em segundos) de espera
# por um evento no mouse para o que lhe for melhor
#
/usr/bin/unclutter -idle 1 -root &
