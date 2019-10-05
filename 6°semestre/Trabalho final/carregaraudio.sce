//carregar o audio 
y=wavread('C:\Users\Alunos\Desktop\fala_sirene_tm0.wav');
// default is 8-bits mu-law
auwrite(y,TMPDIR+'/tmp.au');
y1=auread(TMPDIR+'/tmp.au');
max(abs(y-y1))
plot(y)
z = fft(y);
plot2d(z)

//analisando a amostra do audio
t=soundsec(0.5);
// Then we generate the sound.
s=sin(440*t)+sin(220*t)/2+sin(880*t)/2;
[nr,nc]=size(t);
s(nc/2:nc)=sin(330*t(nc/2:nc));
analyze(s);
plot2d(s)
