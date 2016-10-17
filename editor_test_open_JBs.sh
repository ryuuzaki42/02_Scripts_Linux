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
# Script: testa o tamanho do arquivo antes de abrir no em algum editor de texto
# Obs: Arquivos com mais de 100 MiB não serão abertos, com um aviso de arquivo muito grande
#
# Dica: pela interface do KDE-menu (ou outros) altere para o icone do seu editor padrão
# por este script em vez de executar o "programName"
#
# Última atualização: 17/10/2016
#
# To use, set in icon command:
# /usr/bin/editor_test_open_JBs.sh programName, for example:
# /usr/bin/editor_test_open_JBs.sh kwrite
#
editorText=$1 # Like kwrite and gedit
if [ $# -lt 2 ]; then # text the count of parramters, 1 "editor" 2 "fileName"
    $editorText # Just open the text editor
else
    fileName="$2" # Nome do arquivo que irá abrir
    fileSizeMB=`du -m "$fileName" | cut -f1` # Tamanho deste aquivo em kibibyte

    # Testa de tamanho do arquivo é maior que 100 MiB
    if [ "$fileSizeMB" -gt 100 ]; then # = 100 MiB (mebibyte)
        tmpFile=`mktemp`
        echo "Aquivo muito grande para ser aberto no $editorText." > $tmpFile
        echo "Abra com outro programa." >> $tmpFile
        $editorText $tmpFile
        rm $tmpFile
    else
        $editorText $fileName
    fi
fi
