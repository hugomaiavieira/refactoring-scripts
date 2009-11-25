#!/bin/bash
#
# remove-temps.sh - Busca recursivamente em um diretório por arquivos
#                   temporários e os elimina.
#
# ------------------------------------------------------------------------------
#
# Histórico:
#
# v1.0, 20-10-2009, Hugo Maia:
# - Versão inicial
#
# ------------------------------------------------------------------------------
#
# Autor: Hugo Henriques Maia Vieira <hugouenf@gmail.com>
#
# Licença: GPL.
#
# TODO: Fazer parâmetros serem passados diretamente, sem -"alguma coisa"

#========================== Variáveis e chaves =================================

MENSAGEM_USO="
$(basename "$0") - Busca recursivamente em um diretório por arquivos
                  temporários e os elimina.


USO: "$0" PARÂMETROS [OPÇÕES]


PARÂMETROS:
-f, --file Diretório a partir do qual a busca será feita recursivamente.


OPÇÕES:
-q, --quiet Executa em modo silencioso, não imprimindo na tela os arquivos
que foram removidos.

-h, --help Mostra esta tela de ajuda e sai
-v, --version Mostra a versão do programa e sai


EXEMPLO:

$ ls ~/sgtran/app/models
usuario.rb usuario.rb~ usuario_session.rb usuario_session.rb~

$ "$0" -f ~/sgtran/app/models

$ ls ~/sgtran/app/models
usuario.rb usuario_session.rb
"

MENSAGEM_ERRO="
USO: "$0" PARÂMETROS [OPÇÕES]
Utilize a opção --help para mais informações.
"
f=0
quiet=0

#================= Tratamento de opções de linha de comando ====================

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

    -v | --version)
      echo -n $(basename "$0" .sh) "- "
      #Extrai a versão diretamente do cabeçalho do programa
      grep '^# v' "$0" | tail -1 | cut -d , -f 1 | tr -d \# | tr -d [:blank:]
      exit 0
    ;;

    -q | --quiet) quiet=1 ;;

     -h | --help) echo "$MENSAGEM_USO"; exit 0 ;;

               *) echo "$MENSAGEM_ERRO"; exit 1 ;;
  esac
shift
done

if ( test "$f" = 0 )
then
echo "$MENSAGEM_ERRO"
  exit 1
fi

#============================ Processamento ====================================

find $diretorio -name *~ > /tmp/temps

W=0
for i in $(cat /tmp/temps)
do
    rm $i
    W=$((W+1))
    test "$quiet" = 0 && echo $i
done

echo "Foram removidos $W arquivos temporários."

