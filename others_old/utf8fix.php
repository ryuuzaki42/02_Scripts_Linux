<?php
// Função gambiarra em php pra resolver problemas de dados não utf8 e converter corretamente.
//
// https://berseck.wordpress.com/2010/09/28/transformar-utf-8-para-acentos-iso-com-php/comment-page-1/
// https://wallacesilva.com/blog/2016/12/converter-para-utf-8-caracteres-iso-em-php/
// https://www.i18nqa.com/debug/utf8-debug.html
// Online
// https://onlineutf8tools.com/convert-ascii-to-utf8
//
$msg = "Cole a mensagem aqui";

function utf8Fix($msg){
  $accents = array("á", "à", "â", "ã", "ä", "é", "è", "ê", "ë", "í", "ì", "î", "ï", "ó", "ò", "ô", "õ", "ö", "ú", "ù", "û", "ü", "ç", "Á", "À", "Â", "Ã", "Ä", "É", "È", "Ê", "Ë", "Í", "Ì", "Î", "Ï", "Ó", "Ò", "Ô", "Õ", "Ö", "Ú", "Ù", "Û", "Ü", "Ç");
  $utf8 = array("Ã¡","Ã ","Ã¢","Ã£","Ã¤","Ã©","Ã¨","Ãª","Ã«","Ã­","Ã¬","Ã®","Ã¯","Ã³","Ã²","Ã´","Ãµ","Ã¶","Ãº","Ã¹","Ã»","Ã¼","Ã§","Ã","Ã€","Ã‚","Ãƒ","Ã„","Ã‰","Ãˆ","ÃŠ","Ã‹","Ã","ÃŒ","ÃŽ","Ã","Ã“","Ã’","Ã”","Ã•","Ã–","Ãš","Ã™","Ã›","Ãœ","Ã‡");
  $fix = str_replace($utf8, $accents, $msg);
  echo "$fix";
}

utf8Fix($msg);
