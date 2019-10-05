
//An[álise do audio 'toque'
[y, fa]=wavread('C:\Users\Alunos\Desktop\trabalho final\toque.wav');

y= fft(y);
n= length(y);

y = y/(n/2)
f = [0:fa/(n-1):fa];
 plot(f(1:n/2),abs(y(1:n/2)));
 wc = 2*1800/fa;
 [num,hm,fr] = wfir("lp",30,wc,"hm",[0 0]);

 [H, W] = freq(num("num"),[1,512,fa]);
 //rep=freq(sys("num"),sys("den"),[0,0.9,1.1,2,3,10,20])

 plot(W,abs(H))



