clear

% Load audio file
[y, Fs] = audioread('winxp.wav');

% Generate noisy signal
snr = 20;
New = awgn(y, snr);
    
Y = fft(y); % 对音频数据进行快速傅里叶变换
n = length(Y); % 获取音频数据的长度
f = (0:n-1)*(Fs/n); % 生成频率数组
power = abs(Y).^2/n; % 计算每个频率的功率

subplot(511)
    plot(f(1:n/2), power(1:n/2)) % 绘制频谱
    xlabel('Frequency')
    ylabel('Power')
    title('FFT频谱(无噪声)')

Y2 = fft(New); % 对音频数据进行快速傅里叶变换
n = length(Y2); % 获取音频数据的长度
f = (0:n-1)*(Fs/n); % 生成频率数组
power2 = abs(Y2).^2/n; % 计算每个频率的功率

subplot(512)
    plot(f(1:n/2), power2(1:n/2)) % 绘制频谱
    xlabel('Frequency')
    ylabel('Power')
    title('FFT频谱(有噪声)')

%创建滤波器
% 设定参数
wp = 0.1*pi; % 通带截止频率
rp = 0.25; % 通带波纹
ws = 0.15*pi; % 阻带截止频率
rs = 50; % 阻带衰减

delta_w = ws - wp;
delta_f = delta_w/(2*pi);
N = ceil((rs - 7.95) / (14.36 * delta_f)) + 1;  
%N=12000;
n=0:N;
wc=(wp+ws)/2;
alpha=(N-1)/2;
hd=(wc/pi)*sinc((wc/pi)*(n-alpha));
w_boxcar=boxcar(N+1)';
h=hd.*w_boxcar;

after_filter=filter(h,1,New);

%加上这一段效果会变好
% for i=1:length(after_filter)
%     if(abs(after_filter(i,1))<=0.1)
%         after_filter(i,1)=0;
%     end
%     if(abs(after_filter(i,2))<=0.1)
%         after_filter(i,2)=0;
%     end
% end

subplot(513)%滤波后频谱
    Y3 = fft(after_filter); 
    n = length(Y3); 
    f = (0:n-1)*(Fs/n); 
    power3 = abs(Y3).^2/n; 
    plot(f(1:n/2), power3(1:n/2))
    title('滤波后频率能量谱')

subplot(514)
    plot(New(:,1))
    hold on;
    plot(after_filter(:,1))
    legend(['未滤波';'滤波后'])
    title('声道1(时域)')
    
subplot(515)
    plot(New(:,2))
    hold on
    plot(after_filter(:,2))
    legend(['未滤波';'滤波后'])
    title('声道2')

sound(New,Fs)

pause(4)

sound(after_filter,Fs)