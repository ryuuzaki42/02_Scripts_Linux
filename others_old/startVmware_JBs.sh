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
# Script: iniciar o kernel do vmware em /etc/rc.d/init.d/vmware
#
# Última atualização: 05/01/2016
#
echo "Script para iniciar VMWARE"
echo -e "(i)niciar \n(p)arar \n(s)tatus \n(n)ada \n"
read resposta
if [ $resposta = i ]; then
    su root -c "sh /etc/rc.d/init.d/vmware start"
fi

if [ $resposta = p ]; then
    su root -c "sh /etc/rc.d/init.d/vmware stop"
fi

if [ $resposta = s ]; then
    su root -c "sh /etc/rc.d/init.d/vmware status"
fi

if [ $resposta = n ]; then
    exit 0
fi

echo -e "fim do script \n"
