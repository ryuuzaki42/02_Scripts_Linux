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
# Última atualização: 03/11/2016
#
# Dica: Copie (cp .bash* ~) tanto para root como para o usuário corrente
#
. /etc/profile # Loading deafault configs (the file /etc/profile and
    # the files inside /etc/profile.d/ with permission to execute)

export HISTCONTROL=ignoreboth:ignoredups:erasedups # To ignore dups in history
export PAGER='/usr/bin/most -s' # To display color man pages, using most instead less

# Tput setaf * colors => 0 black, 1 red, 2 green, 3 yellow, 4 blue, 5 magenta, 6 cyan, 7 white

if [ $(id -u) -eq 0 ]; then # User root
    PS1="\\[$(tput setaf 3)\\][\\u@\\h:\\w]# " # With color
    #PS1="\\[\\][\\u@\\h:\\w]# "               # Without color
else # "Normal" User
    PS1="\\[$(tput setaf 2)\\][\\u@\\h:\\w]$ " # With color
    #PS1="\\[\\][\\u@\\h:\\w]$ "               # Without color

    echo -e "\n\t #__ Welcome in the host: `hostname` __#"

    #echo; screenfetch -E; echo # Uncomment if you want to use screenfetch

    echo -e "\t\t              mm    "
    echo -e "\t\t  *v*      /^(  )^\ "
    echo -e "\t\t /(_)\     \,(..),/ "
    echo -e "\t\t  ^ ^        V~~V   "

    date '+ %t %A, %B %d, %Y (%d/%m/%y) at: %T%n'

    /usr/games/fortune -s; echo # Comment if you want to use the fortune (-s Short apothegms only)
    # To disable the fortune in /etc/profile.d/ use:
    # chmod -x /etc/profile.d/bsd-games-login-fortune.*sh
fi

alias nano='nano -c'

alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'

alias ls='ls -h --color=auto'

echoBlankLines() { # Print x blank lines on terminal
    lineNumber=$1
    if [ "$lineNumber" == "" ] || ! echo $lineNumber | grep -q [[:digit:]]; then
        lineNumber=10
    fi

    countEcho=0
    while [ "$countEcho" -lt "$lineNumber" ]; do
        echo
        ((countEcho++))
    done
}
alias bl='echoBlankLines'

cdMultipleTimes () { # Move up x directories
    countCd=$1
    if [ "$countCd" == "" ] || ! echo $countCd | grep -q [[:digit:]]; then
        countCd=1
    fi

    for ((i=$countCd; i > 0; i--)); do
        cd ..
    done
}
alias cdm='cdMultipleTimes'
