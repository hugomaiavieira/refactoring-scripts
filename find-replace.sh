#!/bin/bash
#
# find-replace.sh - Busca em um arquivo, ou recursivamente em todos os arquivos
#                   de um diretório, por uma palavra e a substitui por outra.
#
# ------------------------------------------------------------------------------
#
# Histórico:
#
#  v1.0, 20-10-2009, Hugo Maia:
#   - Versão inicial buscando recursivamente em todos os arquivos de uma
#   dada pasta por uma palavra e a substitui por outra.
#  v1.1, 14-11-2009. Hugo Maia:
#   - Adicionadas as opções -h, --help, -v e --version.
#  v1.2, 14-11-2009. Hugo Maia:
#   - Separados os parâmetros para serem passados assim como as opções.
#   Adicionadas as opções -q e --quiet. Adicionado contador de arquivos
#   alterados.
#  v1.3, 14-11-2009. Hugo Maia:
#   - Adicionadas as opções -ef e --exclude-file.
#  v1.4, 14-11-2009. Hugo Maia:
#   - Adicionadas as opções -ed e --exclude-dir.
#  v1.5, 14-11-2009. Hugo Maia:
#   - Adicionada mensagem de erro generalizada. Adicionados vários tratamentos
#   de exceções.
#
# ------------------------------------------------------------------------------
#
# Autor: Hugo Henriques Maia Vieira <hugouenf@gmail.com>
#
# Licença: GPL.
#

#=======================    Variáveis e chaves    ==============================

MENSSAGEM_USO="
$(basename "$0") - Busca em um arquivo, ou recursivamente em todos os arquivos
                  de um diretório, por uma palavra e a substitui por outra.


USO: "$0" PARÂMETROS [OPÇÕES]


PARÂMETROS:
  -f, --file      Arquivo ou diretório no qual a busca será feita. Sendo o
                  argumento um diretório, a busca será recursiva.

  -o, --old-word  Palavra que será substituída nos arquivos.

  -n, --new-word  Palavra que substituirá a palavra informada no parâmetro -n.


OPÇÕES:
  --exclude-file  Exclui da busca arquivos cujos nomes coincidam com o argumento
                  informado. O argumento pode conter * para generalizações,
                  porém desta forma, deve ser passado entre aspas.

  --exclude-dir   Exclui da busca recursiva diretórios cujos nomes coincidam com
                  o argumento informado. O argumento pode conter * para
                  generalizações, porém desta forma, deve ser passado entre
                  aspas.

  -q, --quiet     Executa em modo silencioso, não imprimindo na tela os arquivos
                  que foram alterados.

  -h, --help      Mostra esta tela de ajuda e sai
  -v, --version   Mostra a versão do programa e sai


EXEMPLOS:

  $ "$0" -f diretório -o substituída -n substituta

  $ "$0" -f ~/sgtran -o viagems -n viagens -ed ".git"

  $ "$0" -f ~/sgtran/app/ -o Funcionário -n Solicitante -ef view/show.erb
"

MENSSAGEM_ERRO="
USO: "$0" PARÂMETROS [OPÇÕES]
Utilize a opção --help para mais informações.
"
f=0
o=0
n=0
quiet=0
recursivo=''
exclude_file=''
exclude_dir=''

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

    -o | --old-word)
      shift

      antiga="$1"
      o=1

      if test -z "$antiga"
      then
        echo "Faltou argumento para -o."
        exit 1
      fi
    ;;

    -n | --new-word)
      shift

      nova="$1"
      n=1

      if test -z "$nova"
      then
        echo "Faltou argumento para -n."
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

     -h | --help)  echo "$MENSSAGEM_USO";  exit 0 ;;

               *)  echo "$MENSSAGEM_ERRO"; exit 1 ;;
  esac
  shift
done

if ( test "$f" = 0 || test "$o" = 0 || test "$n" = 0 )
then
  echo "$MENSSAGEM_ERRO"
  exit 1
fi

#=========================    Processamento    =================================

contador=0
for i in $(grep -l "$recursivo" "$antiga" "$diretorio" $exclude_dir $exclude_file)
do
  sed "s/"$antiga"/"$nova"/g" $i > $i-temporario
  mv $i-temporario $i

  test "$quiet" = 0 && echo "$i"

  contador=$((contador+1))
done

echo "Foram alterados $contador arquivos."

