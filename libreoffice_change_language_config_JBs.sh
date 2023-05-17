#!/bin/bash
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Críticas "construtivas"
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
# Descrição: Script to download the last version of Slackware Live, made by AlienBob
#
# Last update: 17/05/2023
#
echo -e "\\n # Libreoffice change language configuration en-US to pt-BR or vice versa #\\n"

# ~/.config/libreoffice/4/user/registrymodifications.xcu
cd ~/.config/libreoffice/4/user/ || exit

# en-US
# pt-BR
#
# <item oor:path="/org.openoffice.Office.Linguistic/General"><prop oor:name="UILocale" oor:op="fuse"><value></value></prop></item>
# <item oor:path="/org.openoffice.Office.Linguistic/General"><prop oor:name="UILocale" oor:op="fuse"><value>pt-BR</value></prop></item>
#
# <item oor:path="/org.openoffice.Setup/L10N"><prop oor:name="DateAcceptancePatterns" oor:op="fuse"><value>M/D/Y;M/D</value></prop></item>
# <item oor:path="/org.openoffice.Setup/L10N"><prop oor:name="DateAcceptancePatterns" oor:op="fuse"><value>D/M/Y;D/M</value></prop></item>
#
# <item oor:path="/org.openoffice.Setup/L10N"><prop oor:name="ooLocale" oor:op="fuse"><value>en-US</value></prop></item>
# <item oor:path="/org.openoffice.Setup/L10N"><prop oor:name="ooLocale" oor:op="fuse"><value>pt-BR</value></prop></item>
#
# <item oor:path="/org.openoffice.Setup/L10N"><prop oor:name="ooSetupSystemLocale" oor:op="fuse"><value>en-US</value></prop></item>
# <item oor:path="/org.openoffice.Setup/L10N"><prop oor:name="ooSetupSystemLocale" oor:op="fuse"><value>pt-BR</value></prop></item>

echo -n "    Current configuration: "
if grep -q 'oor:name="UILocale" oor:op="fuse"><value></value></prop></item>' registrymodifications.xcu; then
    echo "en-US"
    config_en_US=1
else # <value>pt-BR</value></prop></item>
    echo "pt-BR"
    config_en_US=0
fi

cp registrymodifications.xcu registrymodifications.xcu.back

echo -n "    changed to: "
if [ "$config_en_US" == '1' ]; then # en-US to pt-BR
    sed -i "s/\"UILocale\" oor:op=\"fuse\"><value><\/value><\/prop><\/item>/\"UILocale\" oor:op=\"fuse\"><value>pt-BR<\/value><\/prop><\/item>/g" registrymodifications.xcu

    sed -i "s/>M\/D\/Y;M\/D</>D\/M\/Y;D\/M</g" registrymodifications.xcu

    sed -i "s/<value>en-US<\/value><\/prop><\/item>/<value>pt-BR<\/value><\/prop><\/item>/g" registrymodifications.xcu

    echo "pt-BR"
else # "config_en_US" == '1' # pt-BR to en-US
    sed -i "s/\"UILocale\" oor:op=\"fuse\"><value>pt-BR<\/value><\/prop><\/item>/\"UILocale\" oor:op=\"fuse\"><value><\/value><\/prop><\/item>/g" registrymodifications.xcu

    sed -i "s/>D\/M\/Y;D\/M</>M\/D\/Y;M\/D</g" registrymodifications.xcu

    sed -i "s/<value>pt-BR<\/value><\/prop><\/item>/<value>en-US<\/value><\/prop><\/item>/g" registrymodifications.xcu

    echo "en-US"
fi
echo
