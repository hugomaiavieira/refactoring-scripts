REFACTORING SCRIPTS
===================

  Coleção de scripts escritos em shell para refatoração de código.


EXECUTANDO UM SCRIPT
--------------------

  Para executar o script find-replace.sh, por exemplo, execute o seguinte
  comando no terminal:

    $ ./bin/find-replace

  Outra possibilidade é adicionar a pasta Refactoring-scripts/bin ao path dos
  binários do sistema. Para isso basta apenas executar no terminal:

    $ sudo su
    $ echo "export PATH="$PATH:/local_onde_foi_feito_o_download/Refactoring-scripts/bin"" >> /etc/bash.bashrc
    $ exit

  Dessa forma, ao abrir novamente o terminal será possível rodar o script apenas
  executando no terminal:

    $ find-replace


AUTOR
-----

  Hugo Henriques Maia Vieira <hugomaiavieira@gmail.com>

