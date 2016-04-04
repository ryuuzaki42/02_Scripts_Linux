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
# Descrição: Arquivo-bashrc para carregar configuração do bash
#
# Última atualização: 04/04/2016
#
# Dica: Copie (cp .bash* ~) tanto para root como para o usuário corrente
#
# tput setaf * ==> 0 black,1 red,2 green,3 yellow,4 blue,5 magenta,6 cyan,7 white
if [ $(id -u) -eq 0 ]; then # root
    PS1="\\[$(tput setaf 1)\\][\\u@\\h:\\w]# "
else # user normal
    PS1="\\[$(tput setaf 7)\\][\\u@\\h:\\w]$ "
    echo '*** Bem-vindo ao host '`hostname`' ***'
    /usr/games/fortune
    echo '  *v* '
    echo ' /(_)\ '
    echo '  ^ ^ '
    date '+Date:%F %A %B Day:%j Week:%W'
    screenfetch -E
fi
#
alias ls='ls --color'
alias sl='ls --color'
alias ext='exit'
alias exot='exit'
alias exti='exit'
alias grep='grep --color=auto'
export HISTCONTROL=ignoreboth:ignoredups:erasedups
#