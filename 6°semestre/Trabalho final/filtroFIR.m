%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Projeto filtros FIR
%Kaline B.F Mesquita
%Ferramentas:M�TODO DAS JANELAS
%Descri��o: Neste c�digo s�o utilizado dois filtro FIR para a filtragem de
%           uma som. No som h� uma pessoa falando, uma sirene e um chiado.
%           O c�digo retira o som da sirene e do chiado. Deixando o som da
%           voz da pessoa aud�vel.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clc;
clear all;
%
% Carregamento do sinal de �udio
[x,fs]=audioread('C:\Users\kaline\Desktop\kaline\Recursos\trabalho\fala_sirene_tm0.wav');
nbits=16;
% Play na musica original 
%wavplay(x,fs);

% Capturando informa��es
Ts = 1/fs;                  % Per�odo de amostragem
t = 0:Ts:1-Ts;              % Intervalo de amostragem
fa=[0:1:length(x)-1];       % fa percorre vetor de amostras dos sinal
f=fa.*fs/(length(x)-1);     % Vetor de frequ�ncias em Hz
X=abs(fft(x));              % Espectro de frequ�ncia do sinal de �udio

% Apresenta��o de plots
subplot(2,1,1);
plot(fa,abs(x));
title('Sinal de Voz');
subplot(2,1,2);
plot(f(1:round(length(x)/2)),X(1:round(length(x)/2)));
title('Espectro do sinal');

% ------------------------- 1� Est�gio de filtragem ---------------
% Filtro rejeita-faixa.
fc = 200;                    % Frequ�ncia a ser eliminada
r = 0.9926;                  % coeficiente para regula��o
wc = (2*pi*fc)/fs;           % Convers�o da frequ�ncia de corte
b = [1 -2*cos(wc) 1];        % Coeficientes do numerador do filtro
a = [1 -2*r*cos(wc) r^2];    % Coeficientes do denominador do filtro
[H1,W1] = freqz(b, a, 512);  % Resposta em Frequ�ncia do Filtro Notch
e = filter(b,a,x);           % Filtrando o sinal
E = abs(fft(e));             % Resposta em frequ�ncia do sinal filtrado
[I,T] = impz(b*10000, a*10000);          % Resposta ao impulso do filtro FIR

% Coeficientes do segundo filtro notch
disp('Coeficientes do filtro rejeita-faixa FIR');
disp(b);
disp(a);

% Apresenta��o de plots
figure;
subplot(2,1,1);
plot(f(1:round(length(x)/2)),X(1:round(length(x)/2)));
hold on
plot(W1*(fs/(2*pi)), abs(H1*12000), 'r');
title('Representa��o do filtro rejeita-faixa FIR');
subplot(2,1,2);
plot (f(1:round(length(e)/2)), E(1:round(length(e)/2)));
title('Resposta em frequ�ncia do sinal filtrado FIR');
figure;
plot(T,abs(I));
title('Resposta ao impulso do filtro FIR');

% ------------------------- 2� Est�gio de filtragem ---------------
% Filtro passa-baixa.
B=fir1(100,0.05, 'low');
A=1;
[H1,W1] = freqz(B, 1, 1024);  % Resposta em Frequ�ncia
y = filter(B,A,e);            % Filtrando o sinal
Y = abs(fft(y));              % Resposta em frequ�ncia do sinal filtrado
[I1,T1] = impz(B, A);         % Resposta ao impulso do filtro FIR

% Coeficientes do segundo filtro notch
disp('Coeficientes do filtro passa-baixa FIR');
disp(B);
disp(A);

% Apresenta��o de plots
figure;
subplot(2,1,1);
plot(f(1:round(length(e)/2)),E(1:round(length(e)/2)));
hold on
plot(W1*(fs/(2*pi)), abs(H1*12000), 'r');
title('Representa��o do filtro passa-baixa FIR');
subplot(2,1,2);
plot (f(1:round(length(y)/2)), Y(1:round(length(y)/2)));
title('Resposta em frequ�ncia do sinal filtrado FIR');
figure;
plot(T1,abs(I1));
title('Resposta ao impulso do filtro FIR');

% Salvando sinal filtrado
audiowrite('C:\Users\kaline\Desktop\kaline\Recursos\trabalho\fala_sirene_tmFIR.wav',y,fs);

% Play no voz filtrado
%[x1,fs1,nbits1]=wavread('C:\Users\usuario\Desktop\TRABALHOS\FILTRO-DIGITAIS\Codigos\Sons\fala_sirene_tmFIR.wav');
%am=(1)*x1;              % Amplifica��o do sinal.
%wavplay(am,fs1);

disp('100%!');
