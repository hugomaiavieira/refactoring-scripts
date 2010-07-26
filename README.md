#REFACTORING SCRIPTS

  Coleção de scripts escritos em shell para refatoração de código.


##INSTALANDO

Para instalar, basta executar no terminal:

    $ ./install.sh


##ATUALIZANDO

Para atualizar para uma versão mais nova, basta fazer o download executar no
terminal:

    $ ./install.sh


##SCRIPTS

###change-file-name

Busca recursivamente em um diretório por arquivos que contenham uma palavra em
seu nome e a substitui por outra. O programa diferência maiúsculas e minúsculas.

####Parâmetros

    -f, --file      Diretório a partir do qual a busca será feita recursivamente.

    -o, --old-word  Palavra que será substituída no nome dos arquivos.

    -n, --new-word  Palavra que substituirá a palavra informada no parâmetro -n.


####Opções

    -q, --quiet     Executa em modo silencioso, não imprimindo na tela os arquivos
                    que foram alterados.

    -h, --help      Mostra esta tela de ajuda e sai
    -v, --version   Mostra a versão do programa e sai

####Exemplos

    $ ls ~/diretorio
    fulanoAntiga.txt   ANTIGAblabla.sh   testeANTIGAteste.rb

    $ change-file-name -f ~/diretorio -o ANTIGA -n NOVA

    $ ls LOCAL
    fulanoAntiga.txt   NOVAblabla.sh   testeNOVAteste.rb


###find-replace

Busca em um arquivo, ou recursivamente em todos os arquivos de um diretório, por
uma palavra (ou expressão regular) e a substitui por outra; Cria arquivos .backup
para posteriormente poder desfazer as mudanças (através do comando undo) ou serem
removidos (através do comando clean).

####Comandos:

    clean D         Remove os arquivos .backup criados em D e seus sub-diretórios.

    undo D          Desfaz as mudanças realizadas em D.

####Parâmetros

    -f, --file      Arquivo ou diretório no qual a busca será feita. Sendo o
                    argumento um diretório, a busca será recursiva.

    -o, --old-word  Palavra que será substituída nos arquivos.

    -n, --new-word  Palavra que substituirá a palavra informada no parâmetro -n.

####Opções

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

####Exemplos

    $ find-replace -f diretório -o substituída -n substituta

    $ find-replace -f diretório -o "^Hugo.*Vieira" -n Hugo

    $ find-replace -f ~/sgtran -o viagems -n viagens -ed ".git"

    $ "$0" clean ~/sgtran/

    $ find-replace -f ~/sgtran/app/ -o Funcionário -n Solicitante -ef view/show.erb

    $ "$0" undo ~/sgtran/app/


###html-characters

Busca em um arquivo, ou recursivamente em todos os arquivos de um diretório, por
vogais acentuadas e cedilha e as substitui por seu nome ou número equivalente
em HTML.

Os caracteres substituídos são:

    À Á Â Ã Ç É Ê Í Ó Ô Õ Ú à á â ã ç é ê í ó ô õ ú

Tendo como exemplo o caractere 'á', os números equivalentes em HTML seguem o
formato `&#225;` e os nomes equivalentes em HTML seguem o formato `&aacute;`


####Parâmetros

    -f, --file            Arquivo ou diretório no qual a busca será feita. Sendo o
                          argumento um diretório, a busca será recursiva.


####Opções

    -ef, --exclude-file   Exclui da busca arquivos cujos nomes coincidam com o
                          argumento informado. O argumento pode conter * para
                          generalizações, porém desta forma, deve ser passado
                          entre aspas.

    -ed, --exclude-dir    Exclui da busca recursiva diretórios cujos nomes
                          coincidam com o argumento informado. O argumento pode
                          conter * para generalizações, porém desta forma, deve
                          ser passado entre aspas.

    --no-backup           Não cria os arquivos de backup.

    -n, --numero          Substitui os caracteres por seu numero correspondente em
                          HTML.

    -q, --quiet           Executa em modo silencioso, não imprimindo na tela os
                          arquivos que foram alterados.

    -h, --help            Mostra esta tela de ajuda e sai
    -v, --version         Mostra a versão do programa e sai


####Exemplos

    $ html-characters -f diretório

    $ html-characters -f ~/index.html -ed ".git"

    $ html-characters --numero -f ~/sgtran/app/ -ef view/show.erb


###remove-temps

Busca recursivamente em um diretório por arquivos temporários e os elimina.

####Parâmetros

    -f, --file      Diretório a partir do qual a busca será feita recursivamente.


####Opções

    -q, --quiet     Executa em modo silencioso, não imprimindo na tela os arquivos
                    que foram removidos.

    -g, --git       Executa o comando "git rm" para todos os arquivos temporários.
                    Para utilizar esta opção, deve-se estar na diretório root do
                    projeto e os arquivos ainda devem existir.

    -h, --help      Mostra esta tela de ajuda e sai
    -v, --version   Mostra a versão do programa e sai


####Exemplos


    $ ls ~/sgtran/app/models
    usuario.rb usuario.rb~ usuario_session.rb usuario_session.rb~

    $ remove-temps -f ~/sgtran/app/models

    $ ls ~/sgtran/app/models
    usuario.rb usuario_session.rb

Usando a opção -g, --git

    $ git status
    # On branch master
    nothing to commit (working directory clean)

    $ remove-temps -f . -g

    $ git status
    # On branch master
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #	deleted:    app/controllers/application_controller.rb~
    #	deleted:    app/controllers/usuario_sessions_controller.rb~


##AUTOR

 Hugo Henriques Maia Vieira <hugomaiavieira@gmail.com>

