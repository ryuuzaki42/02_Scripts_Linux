#!/bin/bash
#
# Bash Labirinto versão 1.0
# Este jogo foi baseado no gerador aleatório de labirintos de
# Joe Wingbermuehle localizado em  https://raw.github.com/joewing/maze/master/maze.sh
# Acrescentei o conceito de movimento e colisões para criar o jogo.
# Naturalmente uma linguagem compilada deve ser mais eficiente para este tipo de uso,
# porém esse joguinho serve para mostrar o poder nem sempre reconhecido do shellscript.
# 
#
# Referências e códigos utilizados: 
# https://raw.github.com/joewing/maze/master/maze.sh
# http://lendscripts.blogspot.com.br/2012/10/licao-3-programacao-de-jogos-em.html
#
# Escrito por Fernando Bolonhezi Giannasi - junho/2013

# Validar versão do Bash
if [ $(echo $BASH_VERSION | awk -F"." '{ if ( ($1 >= 4) ) {print "0"} else {print "1"}}') -ne "0" ]; then
  echo "Este jogo só funciona com Bash 4.0 ou posterior"
  echo "Sua versão é $BASH_VERSION"
  exit 1
fi

# Menu inicial
setterm -cursor off

while true; do
clear
echo -e '\033[01;33m'
cat << EOF
    Labirinto Bash versão 1.0
*******************************************
Ajude a bolota vermelha a encontrar a saída
*******************************************
Comandos:
    a -> move a esquerda
    s -> move abaixo
    d -> move a direita
    w -> move acima
    q -> sai do jogo (a qualquer momento)
*******************************************
EOF
tput sgr0
echo -e '\033[01;31m'
cat << EOF
Selecione a dificuldade desejada:
    1-) Fácil
    2-) Médio
    3-) Difícil
    q-) Sair do Jogo
EOF
tput sgr0
read -n1 -s DIFICULDADE

case "$DIFICULDADE" in
"1")
  MAZE_WIDTH="39"
  MAZE_HEIGHT="21"
  break
  ;;
"2")
  MAZE_WIDTH="49"
  MAZE_HEIGHT="31"
  break
  ;;
"3")
  MAZE_WIDTH="59"
  MAZE_HEIGHT="41"
  break
  ;;
"q")
  exit 0
  ;;
esac
done

# Gerador de labirintos:

# Initialize the maze array.
function init_maze {
   for ((y=0; y<MAZE_HEIGHT; y++)) ; do
      for ((x=1; x<$((MAZE_WIDTH-1)); x++)) ; do
         maze[$((y * MAZE_WIDTH + x))]=0
      done
      maze[$((y * MAZE_WIDTH + 0))]=1
      maze[$((y * MAZE_WIDTH + (MAZE_WIDTH - 1)))]=1
   done
   for ((x=0; x<MAZE_WIDTH; x++)) ; do
      maze[$x]=1
      maze[$(((MAZE_HEIGHT - 1) * MAZE_WIDTH + x))]=1
   done
}

# Display the maze array.
function print_maze {
   for ((y=0; y<MAZE_HEIGHT; y++)) ; do
      for ((x = 0; x < MAZE_WIDTH; x++ )) ; do
         if [[ maze[$((y * MAZE_WIDTH + x))] -eq 0 ]] ; then
            echo -n "[]"
         else
            echo -n "  "
         fi
      done
      echo
   done
}

# Carve the maze starting at the specified offset.
function carve_maze {
   local index=$1
   local dir=$RANDOM
   local i=0
   maze[$index]=1
   while [ $i -le 4 ] ; do
      local offset=0
      case $((dir % 4)) in
         0) offset=1 ;;
         1) offset=-1 ;;
         2) offset=$MAZE_WIDTH ;;
         3) offset=$((-$MAZE_WIDTH)) ;;
      esac
      local index2=$((index + offset))
      if [[ maze[$index2] -eq 0 ]] ; then
         local nindex=$((index2 + offset))
         if [[ maze[$nindex] -eq 0 ]] ; then
            maze[$index2]=1
            carve_maze $nindex
            i=0
            dir=$RANDOM
            index=$nindex
         fi
      fi
      i=$((i + 1))
      dir=$((dir + 1))
   done
}

# Gera um labirinto:
TMP="/tmp"
if [ ! -d "$TMP" ]; then
  mkdir "$TMP"
fi
init_maze
carve_maze $((2 * MAZE_WIDTH + 2))
maze[$((MAZE_WIDTH + 2))]=1
maze[$(((MAZE_HEIGHT - 2) * MAZE_WIDTH + MAZE_WIDTH - 3))]=1
print_maze > $TMP/maze.txt
sed -i '1d' $TMP/maze.txt
sed -i 's/^  //g' $TMP/maze.txt

# Inicializando variáveis
INPUT="0" # Entrada de dados
m="0" # Movimento 1 
n="1" # Movimento 2
C="0" # Teste de colisões
x="3" # Coordenada x
y="0" # Coordenada y
counter="1" #Conta movimentos
GANHA="$(echo $MAZE_HEIGHT - 3 | bc)" # Detecta local da saída

#Funções para imprimir labirinto e a bola
function cat_maze() {
    echo -ne '\033[01;32m'
    cat $TMP/maze.txt
    tput sgr0
    echo "Coordenada X = $x"
    echo "Coordenada Y = $y"
    echo "Movimentos = $counter"
}

function cat_ball() {
    echo -ne '\033[01;31m'O
    tput sgr0
}

# Posição inicial
clear
tput cup 0 0
cat_maze
tput cup $y $x
cat_ball

#Movimentação da bola:
while [ $INPUT != "q" ];do
    read  -n1 -s INPUT

    if [ $INPUT = a ];then
        let "m = x"
        let "n = y + 1"
        C=$(cat $TMP/maze.txt | sed -n "$n"p 2> /dev/null | cut -c"$m" 2> /dev/null) # Se C não estiver vazio então atingimos uma parede
        if [ -z $C ];then
            let "x = x - 1"
        else
            let counter--
        fi
    fi

    if [ $INPUT = d ];then
        let "m = x + 2"
        let "n = y + 1"
        C=$(cat $TMP/maze.txt | sed -n "$n"p 2> /dev/null | cut -c"$m" 2> /dev/null) # Se C não estiver vazio então atingimos uma parede
        if [ -z $C ];then
            let "x = x + 1"
        else
            let counter--
        fi
    fi

    if [ $INPUT = w ];then
        let "m = x + 1"
        let "n = y"
        C=$(cat $TMP/maze.txt | sed -n "$n"p 2> /dev/null | cut -c"$m" 2> /dev/null) # Se C não estiver vazio então atingimos uma parede
        if [ -z $C ];then
            let "y = y - 1"
        else
        let counter--
        fi
    fi

    if [ $INPUT = s ];then
        let "m = x + 1"
        let "n = y + 2"
        C=$(cat $TMP/maze.txt | sed -n "$n"p 2> /dev/null | cut -c"$m" 2> /dev/null) # Se C não estiver vazio então atingimos uma parede
        if [ -z $C ];then
            let "y = y + 1"
        else
            let counter--
        fi
    fi

    if [ "$y" -lt "0" ]; then
        y=0; let counter--
    fi

# Checa se ganhou
    if [ "$y" -gt "$GANHA" ]; then
        tput cup $(echo $MAZE_HEIGHT + 3 | bc) 0
        echo -e '\033[01;31m'
        echo GANHOU!!!!!
        echo "Score: $counter movimentos realizados"
        tput sgr0
        echo
        setterm -cursor on
        exit 0
    fi

    clear
    cat_maze

    # Imprime a bola na nova localização
    tput cup $y $x
    cat_ball
    let counter++
done
clear

exit 0
#