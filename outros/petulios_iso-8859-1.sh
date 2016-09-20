#!/bin/bash
#Autor= Rumbler nelson soppa
#Bugs, Agradecimentos, Criticas "construtivas"
#Mande me um e-mail. Ficarei Grato!
# e-mail  rumbler.soppa@gmail.com
#Script grafico para auxiliar a montagen de arquivos .iso!

echo " comecou a rodar em: " >> $HOME/petulios.log ; date >> $HOME/petulios.log

#verifica se existe uma iso montada no sistema!
verificamnt2=`mount > $HOME/.mnnt.txt ; cat $HOME/.mnnt.txt | grep iso | cut -d " " -f 3`

if [ -z $verificamnt2 ]; then
    echo "!!" &>/dev/null
else
    kdialog --passivepopup "O Script Encontrou uma iso montada no sistema:
    $verificamnt2
    Ser� preciso desmontala!" 2 &
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
kdialog --title Petulios --msgbox "Este programa � um software livre;
voc� pode redistribui-lo e/ou
modifica-lo dentro dos termos da Licen�a P�blica Geral GNU como
publicada pela Funda��o do Software Livre (FSF); na vers�o 2 da
Licen�a, ou (na sua opni�o) qualquer vers�o.

Este programa � distribuido na esperan�a que possa ser  util,
mas SEM NENHUMA GARANTIA; sem uma garantia implicita de ADEQUA��O a
qualquer MERCADO ou APLICA��O EM PARTICULAR.

Veja a Licen�a P�blica Geral GNU para mais detalhes.
Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral GNU
junto com este programa, se n�o, escreva para a Funda��o do Software

Livre(FSF) Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA"

#Fun��es principais


montar() {
    if [ -e $HOME/petulios ]; then
        kdialog --passivepopup "Diretorio Adicionado! " 3 &
    else
        mkdir $HOME/petulios
    fi

    if [ -d $localdir ]; then
        abreiso=`kdialog --title Escolher --getopenfilename "~/" "*.iso"`
        if [ -z $abreiso ]; then
            kdialog --passivepopup "Opera��o cancelada! " 3 &
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
        kdialog --title Petulios --msgbox "N�o ha espa�o livre suficiente
        Voc� tem $spacdir mib na sua pasta home!
        Voc� precisa de $rescal Mib de espa�o livre."
        menuprincipal
    else
        kdesu mount -o loop $abreiso $localdir
    fi
    if [ $? = "0" ]; then
        kdialog --passivepopup "Opera��o concluida com sucesso! " 3 &
        echo "Foi aberto a iso $abreiso " &>> $HOME/petulios.log
    else
        menuprincipal
    fi
    echo 1 &>/dev/null

    menu2=`kdialog --title Gerenciador-Arquivo --menu "Selecione uma op��o!" \
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
        kdialog --passivepopup "N�o h� nehuma iso montada no sistema! " 3 &
        menuprincipal
    else
        rm -f $HOME/.mn3t
        kdesu umount $localdir/
    if [ $? = "0" ]; then
        rmdir $localdir
        kdialog --passivepopup "Opera��o concluida com sucesso! " 3 &
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
        Voc� deseja desmontala?"
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
    menu1=`kdialog --title Menu-Inicial --menu "Selecione uma op��o!" \
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
