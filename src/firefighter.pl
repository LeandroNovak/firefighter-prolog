
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Firefighter Prolog
% Inteligência Artificial - Turma A - 2019/2
%
% Professor: 
%   - Murilo Naldi
% Alunos: 
%   - Leandro Novak                 586927
%   - Guilherme Neves		    586986
%   - Gustavo Bastos		    551597
%
% Uso: apaga_todos_os_incendios('ambientex.pl', Caminho).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Habilita remoção das cláusulas conteudo e carga_extintor
:- dynamic conteudo/3.
:- dynamic carga_extintor/1.

% Métodos para manipulação de listas (Aula Prolog e exercícios)
pertence(Elem,[Elem|_ ]).
pertence(Elem,[ _| Cauda]) :- pertence(Elem,Cauda).

concatena([ ],L,L).
concatena([Cab|Cauda],L2,[Cab|Resultado]) :- concatena(Cauda,L2,Resultado).

inverter([],L,L).
inverter([Cab|Cauda],L2,Aux) :- inverter(Cauda,L2,[Cab|Aux]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Regras para movimentação do bombeiro
% Sobe escada
permitido(X,Y,cima) :- conteudo(X,Y,escada_inferior), Y2 is Y+1, 
    conteudo(X,Y2,escada_superior).

% Desce escada
permitido(X,Y,baixo) :- conteudo(X,Y,escada_superior), Y2 is Y-1, 
    conteudo(X,Y2,escada_inferior).

% Verifica parede ou incêndio
permitido(X,Y,direita) :- X1 is X+1, not(conteudo(X1,Y,entulho)), 
    not(conteudo(X1,Y,parede)), not(conteudo(X1,Y,incendio)), X < 10.
permitido(X,Y,esquerda) :- X1 is X-1, not(conteudo(X1,Y,entulho)), 
    not(conteudo(X1,Y,parede)), not(conteudo(X1,Y,incendio)), X > 1.

% Anda sobre entulho
permitido(X,Y,direita) :- X1 is X+1, conteudo(X1,Y,entulho), 
    not(conteudo(X,Y,_)), X2 is X+2, not(conteudo(X2,Y,_)).
permitido(X,Y,esquerda) :- X1 is X-1, conteudo(X1,Y,entulho), 
    not(conteudo(X,Y,_)), X2 is X-2, not(conteudo(X2,Y,_)).

% Passa por incêndio se possuir carga no extintor
permitido(X,Y,direita) :- X1 is X+1, conteudo(X1,Y,incendio),
    carga_extintor(Carga), Carga > 0.
permitido(X,Y,esquerda) :- X1 is X-1, conteudo(X1,Y,incendio), 
    carga_extintor(Carga), Carga > 0.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gera os sucessores as movimentações (cima, baixo, direita e esquerda)
s([X,Y],[X,Y2]) :- permitido(X,Y,cima), Y2 is Y+1.
s([X,Y],[X,Y2]) :- permitido(X,Y,baixo), Y2 is Y-1.
s([X,Y],[X2,Y]) :- permitido(X,Y,direita), X2 is X+1.
s([X,Y],[X2,Y]) :- permitido(X,Y,esquerda), X2 is X-1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Adaptacao do código de Busca em Largura (bl) disponibilizado no material de
% resolução de problemas por meio de busca. Alterou-se para permitir a busca
% para mais de um tipo de item (incendio, extintor).
solucao_bl(Inicial,Item,Solucao) :- bl([[Inicial]],Solucao,Item).

% Se o primeiro estado de F for meta, então o retorna com o caminho
bl([[Estado|Caminho]|_],[Estado|Caminho],Item) :- meta(Estado,Item).

% Falha ao encontrar a meta, então estende o primeiro estado até seus sucessores 
% e os coloca no final da lista de fronteira
bl([Primeiro|Outros], Solucao, Item) :- 
    estende(Primeiro,Sucessores), 
    concatena(Outros,Sucessores,NovaFronteira), 
    bl(NovaFronteira,Solucao, Item).

% Metodo que faz a extensao do caminho até os nós filhos do estado
estende([Estado|Caminho],ListaSucessores):- 
    bagof([Sucessor,Estado|Caminho], (s(Estado,Sucessor), 
    not(pertence(Sucessor,[Estado|Caminho]))), 
    ListaSucessores),!.

% Se o estado não tiver sucessor, falha e não procura mais (corte)
estende( _ ,[]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define o estado meta, se a posição atual contém o item procurado
meta(Estado,Item) :- 
    bagof([X,Y],conteudo(X,Y,Item),Lista), pertence(Estado,Lista).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extintor ainda possui carga, então não efetua a busca
busca_extintor([X,Y,Caminho],[X,Y,Caminho]) :-
    carga_extintor(Carga),
    Carga > 0,!.

% Extintor vazio, inicia busca por um novo extintor
busca_extintor([X,Y,Caminho],[X2,Y2,[[X2,Y2]|Caminho2]]) :- 
    solucao_bl([X,Y],extintor,C),
    concatena(C,Caminho,[[X2,Y2]|Caminho2]),
    atualiza_extintor(2),
    retract(conteudo(X2,Y2,extintor)),!.

% Atualiza a carga do extintor
atualiza_extintor(Carga) :-
    retractall(carga_extintor(_)),
    assert(carga_extintor(Carga)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sem incêndios para apagar
busca_incendio([X,Y,Caminho], [X,Y,Caminho]) :- 
    aggregate_all(count, conteudo(_,_,incendio), Count),
    Count == 0,!.

% Tenta encontrar um incêndio e apagá-lo
busca_incendio([X,Y,Caminho], [X2,Y2,[[X2,Y2]|Caminho2]]) :- 
    solucao_bl([X,Y],incendio,C),
    carga_extintor(Carga), 
    NovaCarga is Carga-1,
    atualiza_extintor(NovaCarga),
    concatena(C,Caminho,[[X2,Y2]|Caminho2]),
    retract(conteudo(X2,Y2,incendio)),!.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sem incêndios para apagar
apaga_incendios([X,Y,Caminho], [X,Y,Caminho]) :-
    aggregate_all(count, conteudo(_,_,incendio), Count),
    Count == 0,!.

% Busca extintor e apaga até dois incêndios
apaga_incendios([X,Y,Caminho], [XF,YF,CaminhoF]) :-
    busca_extintor([X,Y,Caminho],[X2,Y2,Caminho2]),
    carga_extintor(Carga), Carga > 0,
    busca_incendio([X2,Y2,Caminho2],[X3,Y3,Caminho3]),
    busca_incendio([X3,Y3,Caminho3],[X4,Y4,Caminho4]),
    apaga_incendios([X4,Y4,Caminho4], [XF,YF,CaminhoF]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
apaga_todos_os_incendios(Arquivo, Caminho) :-
    carrega_ambiente(Arquivo),
    conteudo(X,Y,bombeiro),
    retract(conteudo(X,Y,bombeiro)),
    apaga_incendios([X,Y,[]],[_,_,CaminhoInv]),
    inverter(CaminhoInv,Caminho,[]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Carrega o ambiente de um arquivo externo
% base: https://www.swi-prolog.org/FAQ/ReadDynamicFromFile.html
carrega_ambiente(File) :- 
    retractall(conteudo(_,_,_)),
    retractall(carga_extintor(_)),
    assert(carga_extintor(0)),
    set_prolog_flag(answer_write_options,[max_depth(0)]),
    open(File, read, Stream),
    call_cleanup(carrega_ambiente(Stream, _, _),
    close(Stream)).

carrega_ambiente(_, [], T) :- T == end_of_file, !.

carrega_ambiente(Stream, [T|X], _) :-
	read(Stream, T),
	assert(T),
	carrega_ambiente(Stream,X,T).
