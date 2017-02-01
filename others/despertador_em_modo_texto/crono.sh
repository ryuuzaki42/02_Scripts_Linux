#!/bin/bash
# crono.sh
#
# Cronometro em shell
#
# Vers�o 1.0: Marca��o do tempo de forma progressiva
# Vers�o 1.1: Adicionado op��o para tempo regressivo
# Vers�o 1.2: Adicionado op��o para tempo limite na contagem progressiva
# Vers�o 1.3: Adicionado op��o para pausa do tempo
# Vers�o 1.4: Adicionado efeitos na forma como o tempo � exibido na tela
# Vers�o 1.5: Adicionado fun��o sair, modificado a par�metro (-v --vers�o), modificado a fun��o conta_tempo e  calcula_tempo
# Joanes Duarte, Janeiro 2013
# Rumbler Soppa, Julho 2013
# Jo�o Batista, Janeiro 2016

###############################[ FUN��ES ]#################################

### Fun��o para mostras as op��es de uso do programa
opcoes_de_uso() {
echo "Uso: $(basename "$0") [OP��ES]

OP��ES
  -p, --progressive   Inicia o cronometro em ordem progressiva
         Obs.:Para limitar o tempo na contagem progressiva,
         � necess�rio informar o tempo final no formato
         hh:mm:ss.

  -r, --regressive   Inicia o cronometro em ordem regressiva.
         Obs.: Necess�rio informar tempo inicial
         no formato hh:mm:ss.

  -h, --help      Mostra esta tela de ajuda e sai

  -v, --version      Mostra a vers�o do programa e sai

EXEMPLOS DE USO:
   $./crono -p.................contagem progressiva infinita
   $./crono -p 01:00:00........contagem progressiva de 1 hora
   $./crono -r 01:00:00........contagem regressiva de 1 hora
" && exit 1
}

### Fun��o que faz a convers�o do tempo de segundos para o formato hh:mm:ss
calcula_tempo(){

if [ $TEMPO -lt 60 ] ; then
HORAS=0
MINUTOS=0
SEGUNDOS=$TEMPO

elif [ $TEMPO -lt 3600 ] ; then
HORAS=0
MINUTOS=$(($TEMPO / 60))
SEGUNDOS=$(($TEMPO % 60))

else
HORAS=$(($TEMPO / 3600))
RESTO=$(($TEMPO % 3600))
MINUTOS=$(($RESTO / 60))
SEGUNDOS=$(($RESTO % 60))

fi

# Ap�s calculado o tempo, formata a sa�da para o padr�o de 2 d�gitos
HORASF=$(printf '%.2d' $HORAS)
MINUTOSF=$(printf '%.2d' $MINUTOS)
SEGUNDOSF=$(printf '%.2d' $SEGUNDOS)
}

### Fun��o principal que atualiza o tempo na tela automaticamente
conta_tempo(){
clear

# Se o operador n�o for negativo, define vari�vel $TEMPO como -1
[ "$OP" = '-' ] || { TEMPO=-1 ; }

# In�cio do la�o que atualiza o tempo na tela
while [ "$TECLA" != '(s|p)' ] && [ "$TEMPO_FINAL" -gt 0 ]
do
clear

TEMPO=$(($TEMPO $OP 1))
TEMPO_FINAL=$(($TEMPO_FINAL - 1))

# Chamada da fun��o que converte o tempo para o formato hh:mm:ss a cada ciclo
# do loop.
calcula_tempo

# Feito os calculos, imprime na tela
   echo -e "\033[40;37;1m.........................\033[m"
   echo -e "\033[40;37;1m|    START: $HORASF:$MINUTOSF:$SEGUNDOSF    |\033[m"
   echo -e "\033[40;37;1m.........................\033[m"
   echo -e "\033[40;37;1m|\033[m\033[40;37m [s]sair      \
[p]ausar \033[m\033[40;37;1m|\033[m"
   echo -e "\033[40;37;1m.........................\033[m"
read -n1 -t 1 TECLA  # Aguarda 1 segundo pela tecla, se n�o, continua

   # Conforme a tecla digitada, direciona para a fun��o espec�fica
   case "$TECLA" in
   s) sair ;;
   p) pausar ;;
   [[:alnum:]]) sleep 1 && continue ;; # Qualquer tecla exceto s e p,
                   # aguarda 1 segundo e continua
    esac
    done
    finalizar
}

### Fun��o que mostra a tela final depois de encerrado o script
finalizar(){
    clear

    echo -e "\033[40;33;1m    FINISH: $HORASF:$MINUTOSF:\
    $SEGUNDOSF    \033[m"

    ##Rumbler
    #alsactl restore
    #mplayer $MPP/*.mp3

    #Jonh
    aumix -v 100 #aumentar volume do canal master
    aumix -p 100 #aumentar volume do canal pcm
    vlc -Z /media/sda1/videos/* # reproduzir aleatoriamente o conte�do da pasta /media/files/videos

    exit 0
}

sair() {
    exit 0
}
### Fun��o que faz pausa no tempo
pausar(){

    while [ "$TECLA" != 'c' ] ; do
        clear
        echo -e "\033[40;37;1m.........................\033[m"
        echo -e "\033[40;37;1m|    PAUSE: $HORASF:$MINUTOSF:$SEGUNDOSF    |\033[m"
        echo -e "\033[40;37;1m.........................\033[m"
        echo -e "\033[40;37;1m|\033[m\033[40;37m[c]continuar \
        [s]sair   \033[m\033[40;37;1m|\033[m"
        echo -e "\033[40;37;1m.........................\033[m"
        read -n1 -t 1 TECLA
        case "$TECLA" in
            s) sair ;;
        esac
done
}

### Fun��o que mostra a vers�o atual do programa
versao() {
    echo -n $(basename "$0")
    # Extrai vers�o diretamente do cabe�alho do programa
    grep '^# Vers�o ' "$0" | tail -1 | cut -d : -f 1 | tr -d \#
    exit 0
}

### Fun��o que testa e converte o par�metro '$2' para segundos
teste_par2() {
# Testa formato de tempo passado no par�metro 2. Deve ser hh:mm:ss
[[ "$TEMPO_LIMITE" != [0-9][0-9]:[0-5][0-9]:[0-5][0-9] ]] && \
echo "Tempo deve ser passado no formado hh:mm:ss" && exit 1

# Passado no teste do par�metro '$2' faz a convers�o para segundos
HORAS=$(echo $TEMPO_LIMITE | cut -d : -f 1) && HORAS=$(($HORAS * 3600))
MINUTOS=$(echo $TEMPO_LIMITE | cut -d : -f 2) && MINUTOS=$(($MINUTOS * 60))
SEGUNDOS=$(echo $TEMPO_LIMITE | cut -d : -f 3)
TEMPO=$(($HORAS+$MINUTOS+$SEGUNDOS+1))

TEMPO_FINAL=$TEMPO
conta_tempo
}

#################[ Tratamento das op��es de linha de comando ]###############

# Testa se foi passado par�metro '$1'
[ "$1" ] || { opcoes_de_uso ; }

# Passado par�metro '$1', faz o tratamento do mesmo
while test -n "$1"; do
    case "$1" in
    -p | --progressive)
        OP=+ ; TEMPO=-1
        # Se tiver par�metro 2, chama a fun�ao para teste do mesmo, caso n�o
        # tenha, define as vari�veis e chama direto a fun��o conta_tempo
        [ "$2" ] || { TEMPO_FINAL=999999 ; conta_tempo ; }
        TEMPO_LIMITE=$2 && teste_par2
        ;;
    -r | --regressive)
        # Testa se foi passado o par�metro $2, que neste caso � obrigat�rio
        [ "$2" ] || { echo "Necess�rio informar o tempo inicial para \
        in�cio da contagem regressiva" ; exit 1 ; }
        TEMPO_LIMITE=$2 ; OP=- && teste_par2
        ;;
    -h | --help) opcoes_de_uso
        ;;
   -v | --version) versao
        ;;
    *) opcoes_de_uso
    ;;

   esac
done
