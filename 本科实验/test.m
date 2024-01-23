% 仿真CA-CFAR
clc;clear;close all
% 参数
signal = 1;
SNR = 10;       %信噪比
Pfa = 1e-3;     %虚警率
N = 1000;       % 信号长度

Pd = zeros(2,1);       % 检测概率
Pf = zeros(2,1);       % 错警率

sigma2 = signal/(10^(SNR/10));  % 噪声方差
x = ones(1,N)*sqrt(signal);     % 信号
noise = sqrt(sigma2)*randn(1,N); % 噪声
x = x + noise;       % 信号+噪声
% ============== 恒定阈值 =================
T1 = sqrt(-1*sigma2*log2(Pfa)/log2(exp(1)));
t = 1:N;
Pd(1,1) = Pd(1,1) + sum(abs(x)>T1);% 检测概率
Pf(1,1) = Pf(1,1) + sum(abs(noise)>T1);% 错警率

% =================== CA CFAR ===================
M = 10;   % length of window (single side)
g = 1;    % length of guard cells(single side)
% 平方律
y = abs(x).^2;% 信号+噪声的平方
n = abs(noise).^2;% 噪声的平方
k = Pfa^(-1/2/M)-1;% 系数
T2 = zeros(1,N);% 阈值
for i = 1:N
    if i == 1
        cell_right = 1/M*sum(y(i+g:i+g+2*M));% 右侧窗口
        Z = cell_right/2;
    end
    if i>1 && i < M+g+1
        cell_right = 1/2/M*sum(y(i+g:i+g+M-i-1));% 右侧窗口
        cell_left =  1/M*sum(y(1:i-g));% 左侧窗口
        Z = (cell_left+cell_right)/2;% 两侧窗口的平均值
    end
    if M+g+1<=i && i<= N-M-g% 信号窗口在中间
        cell_left = 1/M*sum(y(i-g-M:i-g));% 左侧窗口
        cell_right = 1/M*sum(y(i+g:i+g+M));% 右侧窗口
        Z = (cell_left+cell_right)/2;% 两侧窗口的平均值
    end
    if i> N-M-g && i<N% 信号窗口在右侧
        cell_left = 1/M*sum(y(i-g-M+i+1:i-g));% 左侧窗口
        cell_right = 1/M*sum(y(i+g:N));% 右侧窗口
        Z = (cell_left+cell_right)/2;% 两侧窗口的平均值
    end
    if i == N
        cell_left = 1/M*sum(y(i-g-M*2:i-g));% 左侧窗口
        Z = cell_left/2;% 两侧窗口的平均值
    end
    T = k*Z;% 阈值
    T2(i) = T;% 阈值

    if y(i) >= T2(i)% 检测
        Pd(2,1) = Pd(2,1)+1;% 检测概率
    end
    if n(i) >= T2(i)% 错警率
        Pf(2,1) = Pf(2,1)+1;% 错警率
    end

end
Pd = Pd./N % 检测概率（第一项对应恒定阈值检测，第二项对应CACFAR检测）
Pf = Pf./N % 错警率 （第一项对应恒定阈值检测，第二项对应CACFAR检测）
% =================== 画图 ===================
figure;
        plot(1:N,y,'m','LineWidth',0.8);
    hold on;
        plot(1:N,n,'b','LineWidth',1.2);% 信号+噪声，噪声
    hold on;
        plot(1:N,T1*ones(1,N),'LineWidth',1.2,'color','r');% 恒定阈值
    hold on;
        plot(1:N,T2,'LineWidth',1.2,'color','g');% CA-CFAR
    title('SNR=10dB,N=1000');
    xlabel('SNR (dB)');
    grid on
    legend('回波：目标+噪声','噪声','恒定阈值','CA CFAR');
