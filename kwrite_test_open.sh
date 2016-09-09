#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Criticas "construtivas"
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
# Script: testa o tamanho do arquivo antes de abrir no kwrite
# Obs: Arquivos com mais de 100 MiB não serão abertos, com um aviso de arquivo muito grande
#
# Dica: pela interface do KDE-menu altere para o icone do kwrite abrir este script
# em vez de executar o "kwrite"
#
# Última atualização: 29/04/2016
#
if [ $# -eq 0 ]; then # Verifica se foi passado o nome do arquivo
    echo -e "\nApenas abrindo o kwrite...\n"
    kwrite
else
    FILENAME="$1" # Nome do arquivo que irá abrir
    PWD=`pwd` # Caminho da pasta
    FILE_SIZE_MB=`du -m "$FILENAME" | cut -f1` # Tamanho deste aquivo em kibibyte

    # Apenas para teste
    echo -e "\nArquivo: $FILENAME"
    echo -e "Tamanho em MiB: $FILE_SIZE_MB\n"

    # Testa de tamanho do arquivo é maior que 100 MiB
    if [ "$FILE_SIZE_MB" -gt 100 ]; then # = 100 MiB (mebibyte)
        TMPFILE=`mktemp`
        echo "Aquivo muito grande para ser aberto no Kwrite." > $TMPFILE
        echo -n "Abra com outro programa." >> $TMPFILE
        kwrite $TMPFILE
        rm $TMPFILE
    else
        kwrite "$FILENAME"
    fi
fi
#