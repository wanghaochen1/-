[x,FS]=audioread("winxp.wav");
x=x(:,1);
figure;
subplot(211);
plot(x);
title('Time Field ')
xlabel('n');
ylabel('h(n)');
grid on
n = length(x);
y=fft(x,n);
f=(FS/n)*(1:n);  
subplot(212);
plot(f(1:n),abs(y));
title('Frequences Field');
xlabel('Frequences');
ylabel('Magntitude');
grid on

%add Gause noise into x 
x1=awgn(x,14,'measured');
%sound(x1,FS);
y1=fft(x1,length(x1));

figure;
subplot(211);
plot(x1);
title('Time Field Added in Noise');
xlabel('n');
ylabel('h(n)')
grid on
subplot(212);
plot(f(1:length(x1)),abs(y1));
title('Frequences Field Added in Noise');
xlabel('Frequences');
ylabel('Magntitude');
grid on
%the filter designed by me

fp=7500;
fc=8500; 
wp=2*pi*fp/FS;
ws=2*pi*fc/FS;
Bt=ws-wp; 
N0=ceil(6.2*pi/Bt);     
N=N0+mod(N0+1,2);
wc=(wp+ws)/2/pi;         
hn=fir1(N-1,wc,hamming(N)); 
X=conv(hn,x); 
X1=fft(X,length(X));

%the filter designed by fdatool
X2 = filter(Filter_FIR,x1);
x2 = fft(X2);
figure;
subplot(211);
plot(X2);
title('Time Field By FDAtool Filter');
xlabel('n');
ylabel('h(n)')
subplot(212);
plot(f,abs(x2));
title("Frequences Field By FDAtool Filter")
xlabel('Frequences');
ylabel('Magntitude');

figure;
subplot(211);
plot(X);
title('Time Field By My Filter');
xlabel('n');
ylabel('h(n)')
grid on
subplot(212);
plot(f(1:length(x)),abs(X1(1:length(x)))); 
title("Frequences Field By My Filter")
xlabel('Frequences');
ylabel('Magntitude');
grid on

%sound(X(1:length(x)),FS)
