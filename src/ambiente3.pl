%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ambiente Completo 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% dynamic permite remover conhecimento da base
:- dynamic conteudo/3.

% Define a posição inicial do bombeiro
conteudo(1,1,bombeiro).

% Define os objetos e sua posições
conteudo(3,1,entulho).
conteudo(5,1,escada_inferior).
conteudo(6,1,parede).
conteudo(9,1,escada_inferior).
conteudo(10,1,incendio).

conteudo(1,2,escada_inferior).
conteudo(3,2,entulho).
conteudo(5,2,escada_superior).
conteudo(6,2,entulho).
conteudo(7,2,entulho).
conteudo(8,2,escada_inferior).
conteudo(9,2,escada_superior).

conteudo(1,3,escada_superior).
conteudo(4,3,escada_inferior).
conteudo(5,3,parede).
conteudo(6,3,extintor).
conteudo(8,3,escada_superior).
conteudo(10,3,escada_inferior).

conteudo(1,4,extintor).
conteudo(3,4,escada_inferior).
conteudo(4,4,escada_superior).
conteudo(6,4,entulho).
conteudo(9,4,escada_inferior).
conteudo(10,4,escada_superior).

conteudo(2,5,incendio).
conteudo(3,5,escada_superior).
conteudo(6,5,entulho).
conteudo(8,5,incendio).
conteudo(9,5,escada_superior).
conteudo(10,5,incendio).