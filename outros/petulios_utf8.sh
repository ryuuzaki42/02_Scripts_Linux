#!/bin/bash
#Autor= Rumbler nelson soppa
#Bugs, Agradecimentos, Criticas "construtivas"
#Mande me um e-mail. Ficarei Grato!
# e-mail  rumbler.soppa@gmail.com
#Script gráfico para auxiliar a montagem de arquivos .iso!

echo "começou a rodar em: " >> $HOME/petulios.log ; date >> $HOME/petulios.log

#verifica se existe uma iso montada no sistema!
verificamnt2=`mount > $HOME/.mnnt.txt ; cat $HOME/.mnnt.txt | grep iso | cut -d " " -f 3`

if [ -z $verificamnt2 ]; then
    echo "!!" &>/dev/null
else
    kdialog --passivepopup "O Script Encontrou uma iso montada no sistema:
    $verificamnt2
    Será preciso desmontala!" 2 &
    echo 1 > $HOME/.ter.txt
    ter=`cat $HOME/.ter.txt`
fi

if [ -f $ter ]; then
    echo $ter &>/dev/null
else
    kdesu umount $verificamnt2
    rmdir $verificamnt2
    kdialog --passivepopup "iso desmontada com sucesso! " 3 &
    rm -f $HOME/.mnnt.txt
    rm -f $HOME/.ter.txt
fi
rm -f $HOME/.mnnt.txt
rm -f $HOME/.ter.txt
#verifica se existe o diretorio petulios
if [ -e $HOME/petulios ]; then
    echo 1 &>/dev/null
else
    mkdir $HOME/petulios
fi
localdir="$HOME/petulios"

#Uma mensagem inicial 
kdialog --title Petulios --msgbox "Este programa é um software livre;
você pode redistribui-lo e/ou
modifica-lo dentro dos termos da Licença Pública Geral GNU como
publicada pela Fundação do Software Livre (FSF); na versão 2 da
Licença, ou (na sua opnião) qualquer versão.

Este programa é distribuído na esperança que possa ser  útil, 
mas SEM NENHUMA GARANTIA; sem uma garantia implícita de ADEQUAÇÃO a
qualquer MERCADO ou APLICAÇÃO EM PARTICULAR.

Veja a Licença Pública Geral GNU para mais detalhes.
Você deve ter recebido uma cópia da Licença Pública Geral GNU
junto com este programa, se não, escreva para a Fundação do Software

Livre(FSF) Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA"

#Funções principais


montar() {
    if [ -e $HOME/petulios ]; then
        kdialog --passivepopup "Diretorio Adicionado! " 3 &
    else
        mkdir $HOME/petulios
    fi

    if [ -d $localdir ]; then
        abreiso=`kdialog --title Escolher --getopenfilename "~/" "*.iso"`
        if [ -z $abreiso ]; then
            kdialog --passivepopup "Operação cancelada! " 3 &
            menuprincipal
        fi
    else
        kdialog --passivepopup "ERRO! " 3 &
        menuprincipal
    fi
    spacdir=`df /home | grep / | sed -r 's/ +/ /g' | cut -d " " -f 4`
    tmiso=`du $abreiso | sed -r 's/ +/ /g' | cut -d "    " -f 1`
    res=`echo "$tmiso - $spacdir" | bc | cut -c 2-`
    rescal=`echo "$spacdir - $res" | bc`
    if [ $tmiso -gt $spacdir ]; then
        kdialog --title Petulios --msgbox "Não ha espaço livre suficiente
        Você tem $spacdir mib na sua pasta home!
        Você precisa de $rescal Mib de espaço livre."
        menuprincipal
    else
        kdesu mount -o loop $abreiso $localdir
    fi
    if [ $? = "0" ]; then
        kdialog --passivepopup "Operação concluída com sucesso! " 3 &
        echo "Foi aberto a iso $abreiso " &>> $HOME/petulios.log
    else
        menuprincipal
    fi
    echo 1 &>/dev/null

    menu2=`kdialog --title Gerenciador-Arquivo --menu "Selecione uma opção!" \
    \ 1 "Dholphin" \
    \ 2 "Thunar" \
    \ 3 "Konqueror"`
    if [ -z $menu2 ]; then
        menuprincipal
    elif [ $menu2 = "1" ]; then
        dolphin $localdir
        menuprincipal
    elif [ $menu2 = "2" ]; then
        thunar $localdir
        menuprincipal
    elif [ $menu2 = "3" ]; then
        konqueror $localdir
        menuprincipal
    else
        menuprincipal
    fi
}

desmontar() {
    verificamnt3=`mount > $HOME/.mn3t.txt ; cat $HOME/.mn3t.txt | grep iso | cut -d " " -f 3`
    if [ -z $verificamnt3 ]; then
        kdialog --passivepopup "Não há nehuma iso montada no sistema! " 3 &
        menuprincipal
    else
        rm -f $HOME/.mn3t
        kdesu umount $localdir/
    if [ $? = "0" ]; then
        rmdir $localdir
        kdialog --passivepopup "Operação concluida com sucesso! " 3 &
        menuprincipal
    else
        menuprincipal
    fi
    echo 1 &>/dev/null
    fi
}

sairprog() {
    verificamnt=`mount > $HOME/.mnt.txt ; cat $HOME/.mnt.txt | grep iso | cut -d " " -f 3`
    if [ -z $verificamnt ]; then
        echo "O programa encerrou corretamente! Na DATA:"&>> $HOME/petulios.log
        date &>> $HOME/petulios.log
        rm -f $HOME/.mnt.txt
        rmdir $verificamnt
        kdialog --passivepopup "O Shell foi encerrado! " 6 &
        exit
    fi
    if [ -f $erificamnt ]; then
        kdialog --yesno "O Script Encontrou uma iso ainda no sistema:
        $verificamnt
        Você deseja desmontala?"
    fi
    if [ $? = "0" ]; then
        kdesu umount $verificamnt
        rm -f $HOME/.mnt.txt
        rmdir $verificamnt
        kdialog --passivepopup "O Shell foi encerrado com sucesso! " 3 &
        echo "O programa encerrou corretamente! Na DATA:"&>> $HOME/petulios.log
        date &>> $HOME/petulios.log
    else
        kdialog --passivepopup "O Shell foi encerrado! " 6 &
        echo "O programa encerrou corretamente! Na DATA:"&>> $HOME/petulios.log
        date &>> $HOME/petulios.log
        exit
    fi
    }

#Menu inicial e parte principal

menuprincipal() {
    menu1=`kdialog --title Menu-Inicial --menu "Selecione uma opção!" \
    \ 1 "Montar uma iso" \
    \ 2 "Desmontar uma iso" \
    \ 3 "Sair do programa"`
    echo "Saida do menu" &>> $HOME/petulios.log ; echo $menu1 &>> $HOME/petulios.log
    if [ -z $menu1 ]; then
        sairprog
    elif [ $menu1 = "1" ]; then
        montar
    elif [ $menu1 = "2" ]; then
        desmontar
    elif [ $menu1 = "3" ]; then
        sairprog
    else
       menuprincipal
    fi
}
# inicio !!!
if [ $? = "0" ]; then
    menuprincipal
else
    kdialog --error "Ocorreu um erro! Por Favor
    reinicie o script"
fi
#