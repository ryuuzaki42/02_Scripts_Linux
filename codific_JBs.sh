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
# Script: converter texto utf8 to iso-8859 e virse-versa
#
# Última atualização: 07/04/2016
#

if [ $# -ne 1 ]; then # Verifica se foi passado o nome do arquivo
    echo -e "\n$(basename "$0"): Erro de operandos"
    echo "Use $0 nome.extensão (do arquivo que deseja converter)"
    echo -e "Tente $0 --help para mais detalhes\n"
    exit 0
fi

ajuda () { # Função de Ajuda
    echo -e "\n# Use o nome do arquivo (com a extensão) que deseja converter #"
    echo -e "# Ex.: $0 file.srt                                  #\n"
    exit 0
}

case "$1" in # Case virifica chamada da função ajuda
'--help')
    ajuda
esac

nomeArquivo="$1" # Nome do arquivo $1
if [ ! -e "$nomeArquivo" ]; then
    echo -e "\nArquivo passado por parâmetro não existe\nTente \"$0 --help\" ou com outro arquivo\n"
    exit 1
fi

tamanhoNome=$(echo "$nomeArquivo" | wc -m) # Calcula o tamanho do Nome e retirando retorno do wc
tamanhoNome2=$((tamanhoNome - 5)) # Tamanho do nome do arquivo sem a extensão
nomeArquivo2=$(echo "$nomeArquivo" | cut -c1-$tamanhoNome2) # Nome do arquivo sem extensão
tamanhoNome2=$((tamanhoNome - 3)) # Tamanho do nome do arquivo sem a extensão pra pegar a extensão
extensao=$(echo "$nomeArquivo" | cut -c$tamanhoNome2-) # Extensão do arquivo
codificacao=$(cat "$nomeArquivo" | file -) # Verifica codificação do arquivo

if echo $codificacao | grep -q ISO-8859; then # Verifica codificação do arquivo é iso-8859
    codInicial=iso-8859
    codFinal=utf-8
    iconv -f iso-8859-1 -t utf-8 "$nomeArquivo" > "$nomeArquivo2"_"$codFinal"."$extensao" # Converte arquivo para utf-8 salvando em outro arquivo
elif echo $codificacao | grep -q UTF-8; then # Verifica codificacao do arquivo é iso-8859
    codInicial=utf-8
    codFinal=iso-8859
    iconv -f utf-8 -t iso-8859-1 "$nomeArquivo" > "$nomeArquivo2"_"$codFinal"."$extensao" # Converte arquivo para iso-8859 salvando em outro arquivo
else # Em último caso, se o arquivo não for de nenhuma das duas codificações, o sccrit termina
    echo -e "\nCodificação desconhecida\nArquivo não pode ser convertido\n"
    exit 1
fi

if [ $? -eq 1 ]; then
    echo -e "Erro encontrado na execução do iconv\nTente $0 --help"
    exit 1
else
    echo -e "\n## Arquivo convertido com sucesso ##\n\"$nomeArquivo\" de $codInicial para $codFinal"
    echo "$nomeArquivo --> $nomeArquivo2"_"$codFinal.$extensao"

    echo -en "\nSobrescrever o arquivo original?\n(y)es, (n)o: "
    read resposta
    if [ "$resposta" = 'y' ]; then
        mv "$nomeArquivo2"_"$codFinal.$extensao" "$nomeArquivo"
        echo -e "O arquivo foi sobrescrito\n Fim do script\n"
    else
        echo -e "O arquivo não foi sobrescrito\n Fim do script\n"
    fi
fi
