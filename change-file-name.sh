#!/bin/bash
#
# change-file-name.sh - Busca recursivamente em um diretório por arquivos que
#                       contenham uma palavra em seu nome e a substitui por
#                       outra. O programa deferência maiúsculas e minúsculas.
#
# ------------------------------------------------------------------------------
#
# Histórico:
#
#  v1.0, 20-10-2009, Hugo Maia:
#   - Versão inicial buscando recursivamente em uma dada pasta por arquivos
#   que contenham uma PALAVRA em seu nome e a substitui por OUTRA.
#  v1.1, 15-11-2009, Hugo Maia:
#   - Adicionadas as opções -h, --help, -v e --version.
#  v1.2, 15-11-2009. Hugo Maia:
#   - Separados os parâmetros para serem passados assim como as opções.
#  v1.3, 15-11-2009. Hugo Maia:
#   - Adicionada mensagem de erro generalizada. Adicionados vários tratamentos
#   de exceções. Adicionado contador de arquivos alterados.
#  v1.4, 15-11-2009. Hugo Maia:
#   - Adicionada as opções -q e --quiet.
#
# ------------------------------------------------------------------------------
#
# Autor: Hugo Henriques Maia Vieira <hugouenf@gmail.com>
#
# Licença: GPL.
#
# TODO: Adicionar opção de excluir diretórios e arquivos da busca.
# TODO: Fazer parametros serem passados diretamente, sem -"alguma coisa"

#=======================    Variáveis e chaves    ==============================

MENSSAGEM_USO="
$(basename "$0") - Busca recursivamente em um diretório por arquivos que
                      contenham uma palavra em seu nome e a substitui por outra.
                      O programa deferência maiúsculas e minúsculas.


USO: "$0" PARÂMETROS [OPÇÕES]


PARÂMETROS:
  -f, --file      Diretório a partir do qual a busca será feita recursivamente.

  -o, --old-word  Palavra que será substituída no nome dos arquivos.

  -n, --new-word  Palavra que substituirá a palavra informada no parâmetro -n.


OPÇÕES:
  -q, --quiet     Executa em modo silencioso, não imprimindo na tela os arquivos
                  que foram alterados.

  -h, --help      Mostra esta tela de ajuda e sai
  -v, --version   Mostra a versão do programa e sai


EXEMPLO:

  $ ls ~/diretorio
  fulanoAntiga.txt   ANTIGAblabla.sh   testeANTIGAteste.rb

  $ "$0" -f ~/diretorio -o ANTIGA -n NOVA

  $ ls LOCAL
  fulanoAntiga.txt   NOVAblabla.sh   testeNOVAteste.rb
"

MENSSAGEM_ERRO="
USO: "$0" PARÂMETROS [OPÇÕES]
Utilize a opção --help para mais informações.
"
f=0
o=0
n=0
quiet=0

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

      if ! test -e "$diretorio"
      then
        echo "O diretório atribuído ao parâmetro -f não existe."
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

find $diretorio -name *$antiga* > /tmp/antigas

sed "s/$antiga/$nova/g" /tmp/antigas > /tmp/novas

Z=0
for i in $(cat /tmp/antigas)
do
    antigas[$Z]=$i
    Z=$((Z+1))
done

W=0
for j in $(cat /tmp/novas)
do
    mv ${antigas[$W]} $j
    test "$quiet" = 0 && echo ${antigas[$W]} "-" $j
    W=$((W+1))
done

echo "Foram alterados $W arquivos."

