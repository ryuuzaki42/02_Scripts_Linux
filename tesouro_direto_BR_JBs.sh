tesouro_direto(){ # Exibe dados do Tesouro Direto do Brasil
    # https://www.tesourodireto.com.br/produtos/dados-sobre-titulos/rendimento-dos-titulos
    URL_tesouro="https://www.tesourodireto.com.br/documents/d/guest/rendimento-investir-csv"
    dados=$(wget -U "Mozilla" --header="Accept-Language: pt-BR" -q -O - "$URL_tesouro")

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
}
