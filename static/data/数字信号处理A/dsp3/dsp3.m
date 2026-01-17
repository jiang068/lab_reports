% 实验参数设置
f1 = 24; f2 = 60;
f0 = gcd(f1, f2); 
T0 = 1/f0;

% 情况 R1: 2个周期; 情况 R2: 2.5个周期
L1 = 2 * T0; 
L2 = 2.5 * T0;

fs = 1000; % 用于模拟连续信号的高采样率
t1 = 0:1/fs:L1;
t2 = 0:1/fs:L2;

x1 = exp(1j*2*pi*f1*t1) + exp(1j*2*pi*f2*t1);
x2 = exp(1j*2*pi*f1*t2) + exp(1j*2*pi*f2*t2);

figure('Color','w','Name','信号频谱分析');

% --- (3) 连续时间傅里叶变换 (CFT 模拟) ---
subplot(3,1,1);
N_fft = 4096;
X1_f = abs(fftshift(fft(x1, N_fft)));
freq = (-N_fft/2:N_fft/2-1)*(fs/N_fft);
plot(freq, X1_f/max(X1_f), 'b', 'DisplayName', 'R1 (整倍数)'); hold on;
X2_f = abs(fftshift(fft(x2, N_fft)));
plot(freq, X2_f/max(X2_f), 'r--', 'DisplayName', 'R2 (非整倍数)');
xlim([0 100]); grid on;
title('x_1(t) 的幅频特性 (CFT 模拟)');
xlabel('频率 (Hz)'); ylabel('归一化幅度');
legend;

% --- (5) DFT 分析 ---
% 设定采样频率 fs1 = 1/(2*T0) = 6Hz (会混叠)
% 这里为了演示，我们使用一个能观察到频谱的较高采样率，如 200Hz
fs_dft = 200; 
ts1 = 0:1/fs_dft:L1;
xs1 = exp(1j*2*pi*f1*ts1) + exp(1j*2*pi*f2*ts1);
N1 = length(xs1);
Xk1 = abs(fft(xs1));

subplot(3,1,2);
stem(0:N1-1, Xk1, 'filled');
title('x_1(n) 在 R_1 下的 DFT (k=0...N-1)');
xlabel('k (频率索引)'); ylabel('幅度');
grid on;

% --- (6) 补零后的 DFT ---
xs2 = [xs1, zeros(1, N1)]; % 补一倍零
N2 = length(xs2);
Xk2 = abs(fft(xs2));

subplot(3,1,3);
stem(0:N2-1, Xk2, 'Color', [0 .5 0]);
title('x_2(n) 补零后的 DFT (高密度谱采样)');
xlabel('k (频率索引)'); ylabel('幅度');
grid on;