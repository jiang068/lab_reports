%% 实验 6.3 信号频谱分析
clear; clc; close all;

%% (1) 矩形窗与 Hamming 窗对比
N1 = 1024;
n1 = 0:N1-1;
% 定义信号 x1(n)
x1 = 31.6 * exp(1j * (3*pi/7) * n1) + 0.005 * exp(1j * (4*pi/5) * n1);

% 1. 矩形窗
w_rect = boxcar(N1)';
X1_rect = fft(x1 .* w_rect, 2*N1); % 2N 点 DFT
mag1_rect = 20 * log10(abs(X1_rect) / max(abs(X1_rect))); % 归一化并取 dB

% 2. Hamming 窗
w_hamm = hamming(N1)';
X1_hamm = fft(x1 .* w_hamm, 2*N1);
mag1_hamm = 20 * log10(abs(X1_hamm) / max(abs(X1_hamm)));

% 作图 (1)
figure(1);
f = (0:2*N1-1) * (2/ (2*N1)); % 频率轴归一化为 0-2 (pi)
subplot(2,1,1);
plot(f, mag1_rect); grid on; title('(1) 矩形窗幅度谱 (dB)');
ylabel('幅度 (dB)'); ylim([-100, 5]);
subplot(2,1,2);
plot(f, mag1_hamm); grid on; title('(1) Hamming 窗幅度谱 (dB)');
xlabel('归一化频率 (\times\pi rad/sample)'); ylabel('幅度 (dB)'); ylim([-100, 5]);

%% (2) 不同采样点数 N 下的 Blackman 窗对比
% 定义不同 N
Ns = [1024, 2048];
figure(2);

for i = 1:2
    N2 = Ns(i);
    n2 = 0:N2-1;
    % 定义信号 x2(n)
    x2 = 31.6 * exp(1j * (3*pi/7) * n2) + 10 * exp(1j * (1/7 + 1/1024) * 3*pi * n2);
    
    % Blackman 窗
    w_black = blackman(N2)';
    X2 = fft(x2 .* w_black, 2*N2);
    mag2 = 20 * log10(abs(X2) / max(abs(X2)));
    
    % 作图 (2)
    subplot(2,1,i);
    f2 = (0:2*N2-1) * (2 / (2*N2));
    plot(f2, mag2); grid on;
    title(['(2) Blackman 窗, N = ', num2str(N2)]);
    ylabel('幅度 (dB)'); xlabel('归一化频率 (\times\pi rad/sample)');
    xlim([0.3, 0.6]); % 局部放大以观察两个分量
end