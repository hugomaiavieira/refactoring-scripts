#!/bin/bash
#
# html-characters.sh - Busca em um arquivo, ou recursivamente em todos
#                      os arquivos de um diretório, por vogais acentuadas e
#                      cedilha e as substitui por seu nome ou número equivalente
#                      em HTML.
#
#                      Os caracteres substituídos são:
#
#                         À Á Â Ã Ç É Ê Í Ó Ô Õ Ú à á â ã ç é ê í ó ô õ ú
#
#                      Tendo como exemplo o caractere 'á', os números
#                      equivalentes em HTML seguem o formato &#225; e os nomes
#                      equivalentes em HTML seguem o formato &aacute;
#
# ------------------------------------------------------------------------------
#
# Histórico:
#
#  v1.0, 27-02-2010, Hugo Maia:
#   - Versão inicial.
#
# ------------------------------------------------------------------------------
#
# Autor: Hugo Henriques Maia Vieira <hugouenf@gmail.com>
#
# Licença: GPL.
#

#=======================    Variáveis e chaves    ==============================

MENSAGEM_USO="
$(basename "$0") - Busca em um arquivo, ou recursivamente em todos os arquivos
                     de um diretório, por por vogais acentuadas e cedilha e as
                     substitui por seu nome (padrão) ou número equivalente em
                     HTML.

                     Os caracteres substituídos são:

                        À Á Â Ã Ç É Ê Í Ó Ô Õ Ú à á â ã ç é ê í ó ô õ ú

                     Tendo como exemplo o caractere 'á', os números equivalentes
                     em HTML seguem o formato &#225; e os nomes equivalentes em
                     HTML seguem o formato &aacute;


USO: "$0" PARÂMETROS [OPÇÕES]


PARÂMETROS:
  -f, --file            Arquivo ou diretório no qual a busca será feita. Sendo o
                        argumento um diretório, a busca será recursiva.


OPÇÕES:
  -ef, --exclude-file   Exclui da busca arquivos cujos nomes coincidam com o
                        argumento informado. O argumento pode conter * para
                        generalizações, porém desta forma, deve ser passado
                        entre aspas.

  -ed, --exclude-dir    Exclui da busca recursiva diretórios cujos nomes
                        coincidam com o argumento informado. O argumento pode
                        conter * para generalizações, porém desta forma, deve
                        ser passado entre aspas.

  -n, --numero          Substitui os caracteres por seu numero correspondente em
                        HTML.

  -q, --quiet           Executa em modo silencioso, não imprimindo na tela os
                        arquivos que foram alterados.

  -h, --help            Mostra esta tela de ajuda e sai
  -v, --version         Mostra a versão do programa e sai


EXEMPLOS:

  $ "$0" -f diretório

  $ "$0" -f ~/index.html -ed ".git"

  $ "$0" --numero -f ~/sgtran/app/ -ef view/show.erb
"

MENSAGEM_ERRO="
USO: "$0" PARÂMETROS [OPÇÕES]
Utilize a opção --help para mais informações.
"
f=0
quiet=0
numero=0
recursivo=""
exclude_file=''
exclude_dir=''
caracteres=(À Á Â Ã Ç É Ê Í Ó Ô Õ Ú à á â ã ç é ê í ó ô õ ú)
numero_html=(\&#192\; \&#193\; \&#194\; \&#195\; \&#199\; \&#201\; \&#202\; \&#205\; \&#211\; \&#212\; \&#213\; \&#218\; \&#224\; \&#225\; \&#226\; \&#227\; \&#231\; \&#233\; \&#234\; \&#237\; \&#243\; \&#244\; \&#245\; \&#250\;)
nome_html=(\&Agrave\; \&Aacute\; \&Acirc\; \&Atilde\; \&Ccedil\; \&Eacute\; \&Ecirc\; \&Iacute\; \&Oacute\; \&Ocirc\; \&Otilde\; \&Uacute\; \&agrave\; \&aacute\; \&acirc\; \&atilde\; \&ccedil\; \&eacute\; \&ecirc\; \&iacute\; \&oacute\; \&ocirc\; \&otilde\; \&uacute\;)

#===========    Tratamento de opções de linha de comando    ====================

while test -n "$1"
do
  case "$1" in

    -f | --file)
      shift

      diretorio="$1"
      f=1

      if test -z "$diretorio"
      then
        echo "Faltou argumento para -f."
        exit 1
      fi

      if test -d "$diretorio"
      then
        recursivo='-R'
      elif ! test -e "$diretorio"
      then
        echo "O arquivo ou diretório atribuído ao parâmetro -f não existe."
        exit 1
      fi
    ;;

    -ef | --exclude-file)
      shift

      exclude_file="--exclude="$1""

      if test -z "$1"
      then
        echo "Faltou argumento para --exclude-file."
        exit 1
      fi
    ;;

    -ed | --exclude-dir)
      shift

      exclude_dir="--exclude-dir="$1""

      if test -z "$1"
      then
        echo "Faltou argumento para --exclude-dir."
        exit 1
      fi
    ;;

    -v | --version)
      echo -n $(basename "$0" .sh) "- "
      #Extrai a versão diretamente do cabeçalho do programa
      grep '^#  v' "$0" | tail -1 | cut -d , -f 1 | tr -d \# | tr -d [:blank:]
      exit 0
    ;;

    -q | --quiet)  quiet=1 ;;

    -n | --numero)  numero=1 ;;

    -h | --help)  echo "$MENSAGEM_USO";  exit 0 ;;

              *)  echo "$MENSAGEM_ERRO"; exit 1 ;;
  esac
  shift
done

if ( test "$f" = 0 )
then
  echo "$MENSAGEM_ERRO"
  exit 1
fi

#=========================    Processamento    =================================

indice=0
for caractere in ${caracteres[*]}
do
    for i in $(grep -l $recursivo "$caractere" "$diretorio" $exclude_dir $exclude_file)
    do
      if test $numero -eq 0
      then
          sed "s/"$caractere"/"\\${nome_html[$indice]}"/g" $i > $i-temporario
      else
          sed "s/"$caractere"/"\\${numero_html[$indice]}"/g" $i > $i-temporario
      fi
      mv $i-temporario $i

    test "$quiet" = 0 && echo "Encontrados caracteres $caractere no arquivo $i"
    done
    ((indice++))
done

