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
# Description: Exibe dados do Tesouro Direto do Brasil
#
# Last update: 22/11/2026
#
URL_tesouro_horario="https://www.tesourodireto.com.br/produtos/dados-sobre-titulos/rendimento-dos-titulos"
dados=$(wget -U "Mozilla" --header="Accept-Language: pt-BR" -q -O - "$URL_tesouro_horario")

dados=$(echo "$dados" | sed -E 's/<[^>]+>//g;') # Remove HTML, like <span>, <strong>
dados=$(echo "$dados" | tr -d '\t') # Remove tab spaces '\t'
echo -e -n "\n Tesouro Direto - "
echo "$dados" | grep -m 1 "Mercado" # Mercado aberto ou fechado
echo

part_1=$(echo "$dados" | grep -m 1 -A 2 "Horário de funcionamento")
part_2=$(echo "$dados" | grep -m 1 -A 2 "Última atualização")
echo " - $part_1" | paste -sd ':' - | sed 's/:/: /g'
echo " - $part_2" | paste -sd ' ' -
echo
URL_tesouro_dados="https://www.tesourodireto.com.br/documents/d/guest/rendimento-investir-csv"
dados=$(wget -U "Mozilla" --header="Accept-Language: pt-BR" -q -O - "$URL_tesouro_dados")

if [ "$dados" != '' ]; then
    dados_tabela=$(echo "$dados" | column -s ';' -t -o $'\t') # column com \t para alinhar os dados

    if [ "$1" != '' ]; then # Todos títulos, se $1 diferente de '', como "todos"
        echo "$dados_tabela"
    else # Apenas Prefixado 2032 e IPCA+ 2032
        titulos="Prefixado 2032|IPCA\+ 2032"
        dados_selec=$(echo "$dados_tabela" | grep -E "$titulos") # \+ to grep +"

        if [ "$dados_selec" != '' ]; then # Verifica se estão à venda
            echo "$dados_selec"
        else
            titulos_msg=$(echo $titulos | sed 's/|/ e /g; s/\\//g') # Troca '|' por 'e ' e remove '\' junto ao +
            echo -e "\n Títulos não estão à venda - $titulos_msg\n"
        fi
    fi
else
    echo -e "\n Erro no download da planilha com os dados\n"
fi
echo
