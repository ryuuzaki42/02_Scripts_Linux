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
# Descrição: .bashrc para carregar configuração do bash
#
# Última atualização: 23/10/2016
#
# Dica: Copie (cp .bash* ~) tanto para root como para o usuário corrente
#
export HISTCONTROL=ignoreboth:ignoredups:erasedups # to ignore dups in history
export PAGER='/usr/bin/most -s' # to display color man pages, using most instead less

# tput setaf * ==> 0 black, 1 red, 2 green, 3 yellow, 4 blue, 5 magenta, 6 cyan, 7 white
if [ $(id -u) -eq 0 ]; then # root
    PS1="\\[$(tput setaf 3)\\][\\u@\\h:\\w]# "
    #PS1="\\[\\][\\u@\\h:\\w]# "
else # user normal
    PS1="\\[$(tput setaf 2)\\][\\u@\\h:\\w]$ "
    #PS1="\\[\\][\\u@\\h:\\w]$ "

    echo -e '\t*** Bem-vindo ao host '`hostname`' ***'
    echo; screenfetch -E; echo # Uncomment if you don't want to use screenfetch
    echo -e '\t\t              mm    '
    echo -e '\t\t  *v*      /^(  )^\ '
    echo -e '\t\t /(_)\     \,(..),/ '
    echo -e '\t\t  ^ ^        V~~V   '

    date '+ %t %A, %B %d, %Y (%d/%m/%y) at: %T%n'
    /usr/games/fortune -s; echo # Uncomment if you want to use the fortune (-s Short apothegms only)
fi

alias nano='nano -c'

alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'

alias ls='ls -h --color=auto'

echoBlankLines() { # Print blank lines on terminal
    lineNumber=$1
    if [ "$lineNumber" == "" ] || ! echo $lineNumber | grep -q [[:digit:]]; then
        lineNumber=10
    fi

    count=0
    while [ "$count" -lt "$lineNumber" ]; do
        echo
        ((count++))
    done
}
alias bl='echoBlankLines'

cdMultipleTimes () {
    count=$1
    if [ "$count" == "" ];then
        count=1
    fi

    for ((i=$count; i > 0; i--)); do
        cd ..
    done
}
alias cdm='cdMultipleTimes'
