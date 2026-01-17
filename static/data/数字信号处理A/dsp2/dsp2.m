%% 实验 2.3: DTFT 与 DFT 的关系及内插重建
clear; clc; close all;

% (1) 设置 N 点离散序列
x_n = [1, 1, 0, 1];
N = length(x_n);
n = 0:N-1;

% (2) 计算 DTFT 和 DFT
w = linspace(0, 2*pi, 500); % DTFT 连续频率轴
X_dtft = zeros(size(w));
for i = 1:length(w)
    X_dtft(i) = sum(x_n .* exp(-1j * w(i) * n));
end

X_dft = fft(x_n); % DFT 计算
k = 0:N-1;
w_k = 2 * pi * k / N; % DFT 对应的离散频率点

% (3) 用 X(k) 和内插函数重建 DTFT
X_hat = zeros(size(w));
for i = 1:length(w)
    % 内插公式实现
    sum_val = 0;
    for ki = 0:N-1
        % 使用题目给出的内插核函数公式
        num = 1 - exp(-1j * w(i) * N);
        den = 1 - exp(1j * (2*pi*ki/N - w(i)));
        
        % 处理分母为 0 的情况 (当 w 正好等于 2*pi*k/N 时)
        if abs(den) < 1e-10
            sum_val = sum_val + X_dft(ki+1);
        else
            sum_val = sum_val + X_dft(ki+1) * (num / den);
        end
    end
    X_hat(i) = sum_val / N;
end

%% 绘图与比较
figure('Color', 'w', 'Position', [200, 100, 800, 600]);

% 子图 1: DTFT 与 DFT 的对比 (展示栅栏效应)
subplot(2, 1, 1);
plot(w/pi, abs(X_dtft), 'b', 'LineWidth', 1.5, 'DisplayName', 'DTFT (连续谱)');
hold on;
stem(w_k/pi, abs(X_dft), 'r', 'filled', 'LineWidth', 1.2, 'DisplayName', 'DFT (采样点)');
grid on;
title('DTFT 与 DFT 的幅频特性对比 (观察栅栏效应)');
xlabel('\omega / \pi'); ylabel('幅度');
legend;
xlim([0 2]);

% 子图 2: 原 DTFT 与内插重建 DTFT 的比较
subplot(2, 1, 2);
plot(w/pi, abs(X_dtft), 'b', 'LineWidth', 2, 'DisplayName', '原始 DTFT');
hold on;
plot(w/pi, abs(X_hat), 'r--', 'LineWidth', 1.5, 'DisplayName', '内插重建 \hat{X}(e^{j\omega})');
grid on;
title('由 DFT 内插重建的 DTFT 与原 DTFT 比较');
xlabel('\omega / \pi'); ylabel('幅度');
legend;
xlim([0 2]);

sgtitle('实验 2.3: 离散序列的频域分析与重建', 'FontSize', 14);