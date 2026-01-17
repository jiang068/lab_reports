%% 信号采样分析 (非带限信号)
clear; clc; close all;

syms t f
fq = 100;
a = 100;
x2_t = exp(-a*t) * sin(2*pi*fq*t);

%% ① CFT 分析与 95% 能量带宽
% 使用 fourier 函数 (默认得到的是关于 w 的函数，需转换)
X2_w = fourier(x2_t * heaviside(t)); 
% 转换为关于 f 的函数 (w = 2*pi*f)
X2_f_sym = subs(X2_w, 'w', 2*pi*f);
X2_func = matlabFunction(abs(X2_f_sym));

% 计算 95% 能量频率
f_space = 0:0.1:1000;
energy_density = X2_func(f_space).^2;
total_energy = sum(energy_density);
cum_energy = cumsum(energy_density);
f_95 = f_space(find(cum_energy >= 0.95 * total_energy, 1));
fs_suggested = 2 * f_95;

fprintf('95%% 能量带宽上限约为: %.2f Hz\n', f_95);
fprintf('建议采样频率 fs > %.2f Hz\n', fs_suggested);

% 绘图
figure('Color','w','Name','非带限信号采样分析','Position',[100, 50, 800, 900]);
subplot(5,1,1);
f_plot = 0:0.5:400;
plot(f_plot, X2_func(f_plot)/max(X2_func(f_plot)), 'LineWidth', 1.5);
grid on; title('① x_2(t) 的 CFT 归一化幅度谱');
xlabel('频率 (Hz)'); ylabel('幅度'); xlim([0 400]);

%% ② 不同采样频率下的 DTFT
fs_factors = [1, 4, 6, 10];
fs_list = fs_factors * fq;

for i = 1:length(fs_list)
    fs = fs_list(i);
    T = 1/fs;
    t_n = 0:T:1; % 采样 1 秒
    x2_n = exp(-a*t_n) .* sin(2*pi*fq*t_n);
    
    % 计算 DTFT
    N_fft = 4096;
    X_dtft = abs(fft(x2_n, N_fft));
    X_dtft = X_dtft / max(X_dtft); % 归一化
    f_axis = (0:N_fft-1) * (fs / N_fft);
    
    subplot(5, 1, i+1);
    % 只画出 0 ~ fs 范围
    plot(f_axis(f_axis <= fs), X_dtft(f_axis <= fs), 'r', 'LineWidth', 1.2);
    grid on;
    title(['② f_s = ', num2str(fs_factors(i)), 'f_q = ', num2str(fs), ' Hz 的 DTFT']);
    xlabel('频率 (Hz)'); ylabel('幅度');
    xlim([0 fs]);
end

% 调整布局
sgtitle('x_2(t) 采样与混叠分析', 'FontSize', 14);