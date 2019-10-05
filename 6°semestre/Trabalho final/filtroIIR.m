%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Projeto filtros IIR
%kaline B.F Mequita
%Ferramentas: FILTRO DE BUTTERWORTH E NOTCH.
%Descrição: Neste código são utilizado dois filtro IIR para a filtragem de
%           uma som. No som há uma pessoa falando, uma sirene e um chiado.
%           O código retira o som da sirene e do chiado. Deixando o som da
%           voz da pessoa audível.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clc;
clear all;
% Carregamento do sinal de audio
[x,fs]=audioread('C:\Users\Wellington\Desktop\kaline\Recursos\trabalho\fala_sirene_tm0.wav');
nbits=16;
% Play na musica original 
%wavplay(x,fs);

% Capturando informações
Ts = 1/fs;                  % Período de amostragem
t = 0:Ts:1-Ts;              % Intervalo de amostragem
fa=[0:1:length(x)-1];       % fa percorre vetor de amostras dos sinal
f=fa.*fs/(length(x)-1);     % Vetor de frequências em Hz
X=abs(fft(x));              % Espectro de frequência do sinal de áudio

% Apresentação de plots
subplot(2,1,1);
plot(fa,abs(x));
title('Sinal de Voz');
subplot(2,1,2);
plot(f(1:(round(length(x)/2))),X(1:(round(length(x)/2))));
title('Espectro do sinal');


% ------------------------ 1° Estágio de filtragem ---------------
% Filtro notch
Wo = 0.0275; BW=0.01;          % Parâmetros de entrada
[b,a] = iirnotch(Wo,BW);       % Filtro notch 
[H1, W1]= freqz(b, a, 512);    % Resposta em frequência do filtro
y = filter(b,a,x);             % Filtrando o sinal
Y = abs(fft(y));               % Resposta em frequência do sinal filtrado

% Coeficientes do primeiro filtro notch
disp('Coeficientes do primeiro filtro notch');
disp(b);
disp(a);

% Filtro notch
Wo = 0.018; BW=0.01;          % Parâmetros de entrada
[b1,a1] = iirnotch(Wo,BW);     % Filtro notch 
[H1, W1]= freqz(b1, a1, 512);  % Resposta em frequência do filtro
e = filter(b1,a1,y);           % Filtrando o sinal
E = abs(fft(e));               % Resposta em frequência do sinal filtrado
[G,U] = impz(b1, a1);          % Resposta ao impulso do filtro IIR

% Coeficientes do segundo filtro notch
disp('Coeficientes do segundo filtro notch');
disp(b1);
disp(a1);

% Apresentação de plots
figure;
subplot(2,1,1);
plot(f(1:(round(length(x)/2))),X(1:(round(length(x)/2))));
hold on;
plot(W1*(fs/(2*pi)), abs(H1*12000), 'r');
title('Representação do filtro notch IIR');
subplot(2,1,2);
plot (f(1:round(length(e)/2)), E(1:round(length(e)/2)));
title('Resposta em frequência do sinal filtrado IIR');
figure;
plot(U,abs(G));
title('Resposta ao impulso do filtro IIR');

% -------------------------- 2° Estágio de filtragem ---------------
% Filtro de passa-baixa de butterworth
[b2, a2] = butter(10, 0.045, 'low'); % Parâmetros de entrada
[H1, W1]= freqz(b2, a2, 512);       % Resposta em frequência do filtro
s = filter(b2,a2,e);                % Filtrando o sinal
S = abs(fft(s));                    % Resposta em frequência do sinal filtrado
[I,T] = impz(b2, a2);               % Resposta ao impulso do filtro IIR

% Coeficientes do filtro de butterworth
disp('Coeficientes do filtro de butterworth');
disp(b2);
disp(a2);

% apresentação de plots
figure;
subplot(2,1,1);
plot(f(1:(round(length(e)/2))),E(1:(round(length(e)/2))));
hold on;
plot(W1*(fs/(2*pi)), abs(H1*12000), 'r');
title('Representação do filtro butterworth (passa-baixa) IIR');
subplot(2,1,2);
plot (f(1:round(length(s)/2)), S(1:round(length(s)/2)) );
title('Resposta em frequência do sinal filtrado IIR');
figure;
plot(T,abs(I));
title('Resposta ao impulso do filtro IIR');

% Salvando sinal filtrado
audiowrite('C:\Users\Wellington\Desktop\kaline\Recursos\trabalho\fala_sirene_tmIIR.wav',s,fs);

% % Play na voz filtrada
% [x1,fs1,nbits1]=wavread('C:\Users\usuario\Desktop\TRABALHOS\FILTRO-DIGITAIS\Codigos\Sons\fala_sirene_tmIIR.wav');
% am=(1)*x1;              % Amplificação do sinal.
% wavplay(am,fs1);
% 
% disp('100%!');
