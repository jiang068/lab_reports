%% 5.3 实验内容拆分版实现
clear; clc; close all;

% --- 1. 基本参数设置 ---
N = 100;                % 周期
L = 10;                 % 周期数
n_total = 0:N*L-1;      % 总时间轴
r_values = [5, 10, 20, 40]; % 选取代表性的 r 值
N_fft = 1024;           % FFT点数
f = (0:N_fft-1)/N_fft;  % 频率轴 (归一化频率)

% --- 2. 生成矩形信号 x(n) ---
x_single = [ones(1, N/2), zeros(1, N/2)];
x = repmat(x_single, 1, L);

% --- 3. Figure 1: 时域波形对比 (从上往下) ---
figure('Name', '图1：时域波形对比', 'Position', [100, 100, 800, 800]);
% 绘制原始信号
subplot(length(r_values)+1, 1, 1);
plot(n_total(101:500), x(101:500), 'k', 'LineWidth', 1.5);
title('原始信号 x(n) (第2-5周期)'); grid on; ylabel('幅度');

% 循环计算并绘制不同 r 下的 y(n)
for i = 1:length(r_values)
    r = r_values(i);
    wp = r * 2 / N; ws = wp + 0.1;
    [n_order, wn] = buttord(wp, ws, 1, 40);
    [b, a] = butter(n_order, wn);
    y = filtfilt(b, a, x);
    
    subplot(length(r_values)+1, 1, i+1);
    plot(n_total(101:500), y(101:500), 'LineWidth', 1);
    title(['低通输出 y(n) (r=', num2str(r), ')']);
    grid on; ylabel('幅度');
end
xlabel('采样点 n');

% --- 4. Figure 2: 幅频特性对比 (从上往下) ---
figure('Name', '图2：幅频特性分析', 'Position', [950, 100, 800, 800]);
% 原始信号频谱
X_k = abs(fft(x_single, N_fft));
X_k = X_k / max(X_k); % 归一化

subplot(length(r_values)+1, 1, 1);
stem(f(1:N_fft/2), X_k(1:N_fft/2), 'Marker', 'none');
title('原始信号 |X(e^{j\omega})| 归一化幅度谱'); grid on; ylabel('幅度');

% 循环计算不同 r 下的 y(n) 频谱
for i = 1:length(r_values)
    r = r_values(i);
    wp = r * 2 / N; ws = wp + 0.1;
    [n_order, wn] = buttord(wp, ws, 1, 40);
    [b, a] = butter(n_order, wn);
    y_single = filtfilt(b, a, x_single);
    Y_k = abs(fft(y_single, N_fft));
    Y_k = Y_k / max(Y_k); % 归一化
    
    subplot(length(r_values)+1, 1, i+1);
    stem(f(1:N_fft/2), Y_k(1:N_fft/2), 'Marker', 'none', 'Color', 'r');
    title(['y(n) 幅度谱 (r=', num2str(r), ')']);
    grid on; ylabel('幅度');
end
xlabel('归一化频率 (f/fs)');

% --- 5. Figure 3: 高通滤波与叠加 (第4题) ---
figure('Name', '图3：高通滤波与叠加分析', 'Position', [500, 500, 800, 500]);
wp_h = 0.3; ws_h = 0.2; rp_h = 1; rs_h = 15;
[n_h, wn_h] = cheb1ord(wp_h, ws_h, rp_h, rs_h);
[bh, ah] = cheby1(n_h, rp_h, wn_h, 'high');
y_hp = filtfilt(bh, ah, x);

subplot(3,1,1); plot(n_total(101:500), x(101:500)); title('原始信号 x(n)'); grid on;
subplot(3,1,2); plot(n_total(101:500), y_hp(101:500), 'g'); title('高通输出 y_{hp}(n)'); grid on;
% 选取一个 r=20 的低通结果做叠加示例
[bl, al] = butter(4, 20*2/N);
y_lp = filtfilt(bl, al, x);
subplot(3,1,3); plot(n_total(101:500), y_lp(101:500) + y_hp(101:500), 'm'); 
title('低通(r=20) + 高通叠加效果'); grid on;