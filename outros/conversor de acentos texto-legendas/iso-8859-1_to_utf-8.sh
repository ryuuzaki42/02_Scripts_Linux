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
# Script: converte de iso-8859-1 to utf-8
#
# Última atualização: 05/01/2016
#
if [ $# -ne 1 ] # verifica se foi passado o nome do arquivo
then
   echo "$(basename "$0"): Error of the operands"
   echo "usage $0 name.extension about the file if you "
   echo "Try $0 --help"
   exit 0
fi

nomeDoArquivo="$1" #Nome do arquivo $1

ajuda () {
  echo "#                                                        #"
  echo "# use the file name (with extension) you want to convert #"
  echo "# i.e.: $0 file.srt                  #"
  echo "#                                                        #"
  exit 0
}

case "$1" in
'--help')
  ajuda
esac

tamString=$(echo "$nomeDoArquivo" | wc -m | sed 's/ '"$nomeDoArquivo"'//g') #Calcula o tamanho da string
tamString2=$((tamString - 5)) #Calcula o tamanho da string sem a extensao
#extensao=$(echo "$nomeDoArquivo" | rev | cut -c1-3) # extensao do arquivo
nome2=$(echo "$nomeDoArquivo" | cut -c1-$tamString2) #nome do arquivo sem extensao
tamString2=$((tamString2 +2)) #Calcula o tamanho da string sem a extensao
extensao=$(echo "$nomeDoArquivo" | cut -c$tamString2-) # extensao do arquivo

##Para teste
#echo $nomeDoArquivo
#echo $extensao
#echo $nome2
#echo $tamString
#echo $tamString2

#converter de utf-8 para iso-8859-1
iconv -f iso-8859-1 -t utf-8 "$nomeDoArquivo" > "$nome2"2".$extensao"
if [ $? == 1 ]
then
  echo -e "Erro encontrado na execução do iconv \nTente $0 --help"
else
  echo -e "Convertido com sucesso \"$nomeDoArquivo\" de utf-8 para iso-8859-1"
  echo "$nomeDoArquivo --> "$nome2"2".$extensao""
fi
#