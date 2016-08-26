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
# Veja a Licença Pública Geral GNU para maiores detalhes.
# Você deve ter recebido uma cópia da Licença Pública Geral GNU
# junto com este programa, se não, escreva para a Fundação do Software
#
# Livre(FSF) Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
#
# Descrição: Arquivo-bashrc para carregar configuração do bash
#
# Última atualização: 25/08/2016
#
# Dica: Copie (cp .bash* ~) tanto para root como para o usuário corrente
#
export HISTCONTROL=ignoreboth:ignoredups:erasedups # to ignore dups in history
export PAGER='/usr/bin/most -s' # to display color man pages, using most instead less
#
# tput setaf * ==> 0 black, 1 red, 2 green, 3 yellow, 4 blue, 5 magenta, 6 cyan, 7 white
if [ $(id -u) -eq 0 ]; then # root
    PS1="\\[$(tput setaf 3)\\][\\u@\\h:\\w]# "
else # user normal
    PS1="\\[$(tput setaf 2)\\][\\u@\\h:\\w]$ "
    echo -e '\t*** Bem-vindo ao host '`hostname`' ***\n'
    #screenfetch -E; echo # Uncomment if you want to use the screenfetch
    echo -e '\t\t  *v*'
    echo -e '\t\t /(_)\'
    echo -e '\t\t  ^ ^'
    date '+ %t %A, %B %d, %Y (%d/%m/%y) at: %T%n'
    #echo -e "Fortune:\n"; /usr/games/fortune; echo # Uncomment if you want to use the fortune
    #echo -e "Fortune:\n"; /usr/games/fortune -so; echo # Uncomment if you want to use the fortune with (-s) Short apothegms only and (-o) offensive
fi
#
alias nano='nano -c'
#
alias exut='exit'
alias exot='exit'
alias exti='exit'
#
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
#
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias ls='ls --color=auto'
alias sl='ls --color=auto'
alias lcd="cd $1 ; ls -l -a -v -h --color"
#
#alias rm='rm -iv --preserve-root' # Uncomment if you want to use the all rm as rm -iv --preserve-root
alias space='i=0; while [ "$i" -lt 20 ]; do echo; ((i++)); done'
#