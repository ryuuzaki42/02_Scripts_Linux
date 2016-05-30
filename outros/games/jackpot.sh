#!/bin/bash

# JACKPOT
# O objetivo deste jogo é adivinhar um número. Você tem 5 tentativas e
# Jackpot avisará se o número digitado é muito alto ou muito baixo comparado ao número secreto.

# Giulliano G. Minuzzi

Iniciar() {
    vidas=5
    clear
    echo  "** Jackpot **"
    echo
    echo Selecione a dificuldade:
    echo "1: Facil (1-15)"
    echo "2: Medio (1-30)"
    echo "3: Dificil (1-50)"
    read c
    case $c in
        1) maxrand=15; j=$((RANDOM%15+1));;
        2) maxrand=30; j=$((RANDOM%30+1));;
        3) maxrand=50; j=$((RANDOM%50+1));;
        *) echo Opcao invalida!; read; Iniciar;;
    esac
    Jogar
}

Jogar() {
    if test $vidas -eq 0; then
        echo Voce perdeu!
        read
        Iniciar
    fi
    echo
    echo -n "Digite um numero: "
    read i
    if test $i -gt $maxrand -o $i -lt 0; then
        echo Numero deve ser entre 1 e $maxrand
        Jogar
    fi
    if test $i -eq $j; then
        echo Voce venceu!
        read
        Iniciar
    elif test $i -gt $j; then
        echo Muito ALTO
        vidas=$(($vidas-1))
        echo Numero de vidas restantes: $vidas
        Jogar
    elif test $i -lt $j; then
        echo Muito BAIXO
        vidas=$(($vidas-1))
        echo Numero de vidas restantes: $vidas
        Jogar
    fi
}

Iniciar

exit 0
#