%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ambiente Completo 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% dynamic permite remover conhecimento da base
:- dynamic conteudo/3.

% Define a posição inicial do bombeiro
conteudo(1,1,bombeiro).

% Define os objetos e sua posições
conteudo(1,3,entulho).
conteudo(1,5,escada).
conteudo(1,8,escada).
conteudo(1,9,incendio).
conteudo(1,10,incendio).

conteudo(2,1,escada).
conteudo(2,5,escada).
conteudo(2,6,entulho).
conteudo(2,7,entulho).
conteudo(2,8,escada).

conteudo(3,1,escada).
conteudo(3,2,extintor).
conteudo(3,3,extintor).
conteudo(3,4,parede).
conteudo(3,10,escada).

conteudo(4,3,escada).
conteudo(4,4,entulho).
conteudo(4,5,escada).
conteudo(4,7,entulho).
conteudo(4,9,escada).
conteudo(4,10,escada).

conteudo(5,2,incendio).
conteudo(5,3,escada).
conteudo(5,5,escada).
conteudo(5,6,entulho).
conteudo(5,7,parede).
conteudo(5,9,escada).
conteudo(5,10,incendio).