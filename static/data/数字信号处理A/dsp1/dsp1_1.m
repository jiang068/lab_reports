%% 信号采样与频谱分析实验
clear; clc; close all;

% 基本参数设置
fh = 10;                % 最高频率 10Hz
fs_factors = [0.3, 0.6, 1.2, 1.8, 2.4]; % 采样频率系数
fs_list = fs_factors * fh;              % 采样频率列表

% 创建画布，设置长宽比以便于垂直查看
figure('Color', 'w', 'Name', '信号采样分析', 'Position', [200, 50, 800, 950]);

%% ① 绘制 x1(t) 的 CFT 幅度谱
% 理论分析：x1(t) = sin(2*pi*fh*t)/t 的 CFT 是一个宽度为 2*fh 的矩形脉冲
% 在 0~120Hz 范围内，由于是单边频谱观察，其幅度在 0~10Hz 为常数，10Hz 以上为 0
f_cft = 0:0.1:120;
X1_cft = (f_cft <= fh); % 归一化幅度，10Hz 以内为 1

subplot(6, 1, 1);
plot(f_cft, X1_cft, 'LineWidth', 2, 'Color', [0 0.447 0.741]);
grid on;
title(['① x_1(t) 的连续时间傅里叶变换 (CFT) 幅度谱 (最高频率 f_h = ', num2str(fh), 'Hz)']);
xlabel('频率 (Hz)'); ylabel('归一化幅度');
xlim([0 120]); ylim([0 1.2]);
text(fh+2, 0.5, ['\leftarrow 最高频率 f_h = ', num2str(fh), 'Hz'], 'FontSize', 10);

%% ② 绘制 5 种不同采样频率下的 x1(n) 的 DTFT 幅度谱
% 采样时长和点数设置，用于保证 DTFT 的计算精度
T_duration = 30; % 截取 30 秒的信号进行分析

for i = 1:length(fs_list)
    fs = fs_list(i);
    
    % 生成离散采样序列 x1(n)
    n = -round(T_duration * fs / 2) : round(T_duration * fs / 2);
    t_n = n / fs;
    
    % 计算 x1(n) = sin(2*pi*fh*nT)/nT，处理 t=0 处的极限
    x1_n = zeros(size(t_n));
    idx0 = (t_n == 0);
    x1_n(~idx0) = sin(2 * pi * fh * t_n(~idx0)) ./ t_n(~idx0);
    x1_n(idx0) = 2 * pi * fh; % 极限值为 2*pi*fh
    
    % 计算 DTFT (在 0 ~ fs 范围内计算)
    % DTFT 公式: X(f) = sum( x(n) * exp(-j*2*pi*f*n/fs) )
    f_dtft = linspace(0, fs, 1000); % 题目要求频率范围 0 ~ fs
    X_val = zeros(size(f_dtft));
    for k = 1:length(n)
        X_val = X_val + x1_n(k) * exp(-1j * 2 * pi * f_dtft * n(k) / fs);
    end
    
    % 幅度归一化
    mag_X = abs(X_val);
    mag_X = mag_X / max(mag_X);
    
    % 绘图
    subplot(6, 1, i + 1);
    plot(f_dtft, mag_X, 'LineWidth', 1.5, 'Color', [0.85 0.325 0.098]);
    hold on;
    
    % 绘制理想无混叠边界（参考线）
    if fh <= fs
        line([fh fh], [0 1.2], 'Color', 'k', 'LineStyle', '--');
    end
    
    grid on;
    title(['② 采样频率 f_s = ', num2str(fs_factors(i)), 'f_h = ', num2str(fs), ' Hz']);
    xlabel('频率 (Hz)'); ylabel('幅度');
    xlim([0 fs]); ylim([0 1.2]);
end

% 调整子图间距
keyboard_offset = 0.05;
set(gcf, 'Units', 'Normalized');