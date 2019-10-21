%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ambiente Completo 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% dynamic permite remover conhecimento da base
:- dynamic conteudo/3.

% Define a posição inicial do bombeiro
conteudo(1,1,bombeiro).

% Define os objetos e sua posições
conteudo(1,2,entulho).
conteudo(1,4,escada).
conteudo(1,5,incendio).
conteudo(1,6,parede).
conteudo(1,7,extintor).
conteudo(1,9,escada).

conteudo(2,1,escada).
conteudo(2,3,entulho).
conteudo(2,4,escada).
conteudo(2,7,escada).
conteudo(2,9,escada).
conteudo(2,10,entulho).

conteudo(3,1,escada).
conteudo(3,2,incendio).
conteudo(3,4,escada).
conteudo(3,5,parede).
conteudo(3,6,extintor).
conteudo(3,7,escada).
conteudo(3,10,escada).

conteudo(4,3,escada).
conteudo(4,4,escada).
conteudo(4,6,entulho).
conteudo(4,6,escada).
conteudo(4,10,escada).

conteudo(5,2,entulho).
conteudo(5,3,escada).
conteudo(5,6,entulho).
conteudo(5,8,incendio).
conteudo(5,9,escada).