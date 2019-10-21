%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bombeiro:
% Define a posição inicial do problema de busca;
% Qualquer posição do ambiente;
% Preferencialmente no primeiro andar (1).

% Focos de incêndio:
% Define as posições intermediárias e final do problema de busca;
% Qualquer posição do ambiente;
% Qualquer quantidade positiva (> 0).

% Movimentação:
% É livre em um mesmo andar (horizontal);
% Movimentação entre andares só é possível se houver uma escada (vertical), 
% que é um objeto que ocupa dois quadrados (origem e destino);
% O bombeiro não é capaz de passar por espaços em que existam paredes
% ou por focos de incêndio que não foram apagados;
% O bombeiro é capaz de passar por lugares onde há uma pilha de entulho 
% saltando por ela,
% ele só poderá passar por uma pilha se os dois quadrados adjacentes à pilha 
% não possuírem nenhum objeto.

% Extintor:
% Antes de apagar um foco de incêndio, o bombeiro deve passar por um extintor;
% Assume-se que ele pega o extintor se não estiver carregando outro;
% Cada extintor é capaz de apagar até dois focos de incêndio;
% Bombeiro para passar livremente por um extintor.

% Objetivo:
% O agente bombeiro deve usar os extintores para apagar todos os incêndios;
% O resultado é caminho percorrido pelo agente;
% O tamanho do cenário deve ser configurável, bem como o número de objetos e 
% suas localizações;
% O algoritmo deve ser capaz de resultar em falha para cenários impossíveis.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Regras para movimentação do bombeiro
% Sobe escada
permitido(X,Y,cima) :- conteudo(X,Y,escada), conteudo(X,Y+1,escada).
% Desce escada
permitido(X,Y,baixo) :- conteudo(X,Y,escada), conteudo(X,Y-1,escada).
% Anda sobre entulho
permitido(X,Y,direita) :- conteudo(X+1,Y,entulho), not(conteudo(X+2,Y,_)).
permitido(X,Y,esquerda) :- conteudo(X-1,Y,entulho), not(conteudo(X-2,Y,_)).
% Verifica parede ou incêndio
permitido(X,Y,direita) :- not(conteudo(X+1,Y,parede)), not(conteudo(X+1,Y,incendio)), X < 10.
permitido(X,Y,esquerda) :- not(conteudo(X-1,Y,parede)), not(conteudo(X-1,Y,incendio)), X > 1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Métodos para manipulação de listas (Aula Prolog)
pertence(Elem,[Elem|_ ]).
pertence(Elem,[ _| Cauda]) :- pertence(Elem,Cauda).

concatena([ ],L,L).
concatena([Cab|Cauda],L2,[Cab|Resultado]) :- concatena(Cauda,L2,Resultado).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define o estado meta (Estado contém 0 incêndios)
meta(Estado) :- pertence(0,Estado).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define possíveis movimentações
movimenta(posicao(_,_), cima).
movimenta(posicao(_,_), baixo).
movimenta(posicao(_,_), direita).
movimenta(posicao(_,_), esquerda).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
apaga_todos_os_incendios(Arquivo, _) :-
    carrega_ambiente(Arquivo).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Carrega o ambiente de um arquivo externo
% base: https://www.swi-prolog.org/FAQ/ReadDynamicFromFile.html
carrega_ambiente(File) :- 
    retractall(conteudo(_,_,_)), 
    open(File, read, Stream),
    call_cleanup(carrega_ambiente(Stream, _, _),
    close(Stream)).

carrega_ambiente(_, [], T) :- T == end_of_file, !.

carrega_ambiente(Stream, [T|X], _) :-
	read(Stream, T),
	assert(T),
	carrega_ambiente(Stream,X,T).