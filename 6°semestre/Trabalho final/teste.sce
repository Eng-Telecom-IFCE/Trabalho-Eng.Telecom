y=wavread('C:\Users\Alunos\Desktop\fala_sirene_tm0.wav');
// default is 8-bits mu-law
auwrite(y,TMPDIR+'/tmp.au');
y1=auread(TMPDIR+'/tmp.au');
max(abs(y-y1))

z= fft(y);
n= length(z);
plot(abs(z(1:n/2)));
