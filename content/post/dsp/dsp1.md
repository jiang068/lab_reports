---
title: "实验1 连续信号的离散化"
slug: dsp1
date: 2026-01-17
draft: false
categories: ["编程", "信号", "matlab"]
tags: ["数字信号处理", "信号", "matlab"]
params:
  hidden: true
---


## 实验1 连续信号的离散化

### 1.1 实验目的

（1）探究连续时间信号与时间取样序列之间的关系，取样前后的变化。

（2）理解取样操作的本质，是希望取样序列能够承载和表达原信号的所有信息。

（3）对比原信号频谱实验内容

（4）理解奈奎斯特取样准则的物理意义及初步运用，掌握如何针对实际信号选择合适的取样频率。

### 1.2 实验原理

连续时间傅里叶变换（CFT）的一般表达式为 $$X(j\Omega)=\int_{-\infty}^{\infty}x(t)e^{-j\Omega t}dt$$

其反变换的一般表达式为 $$x(t)=\frac{1}{2\pi}\int_{-\infty}^{\infty}X(j\Omega)e^{j\Omega t}d\Omega$$

离散时间傅里叶变换（DTFT）的一般表达式为 $$X(e^{j\omega})=\sum_{n=-\infty}^{\infty}{x(n)}e^{-j\omega n}$$

其反变换的一般表达式为 $$x(n)=\frac{1}{2\pi}\int_{-\pi}^{\pi}{X(e^{j\omega})e^{j\omega n}d\omega}$$

主要内容：

1）对 $x(t)$ 做CFT，记录观察频谱的幅频特性；

2）对 $x(t)$ 做时域离散化得到 $x(n)$，对 $x(n)$ 做DTFT，记录观察幅频特性；

3）在不同的取样频率下，对比分析取样前后的幅频特性变化，理解奈奎斯特取样原理



### 1.3 实验题目  

#### 1.3.1 题目1  

（1）设 $x_1(t)=\frac{\sin{2\pi f_h t}}{t}$，$f_h=10Hz$。

①依据 $x_1(t)$ 的CFT表达式，画出幅频特性图，观察 $x_1(t)$ 的幅度谱，带宽是否受限并有确定的最高频率 $f_h$，根据奈奎斯特取样准则确定合适的取样频率 $f_s$。

②在以下5个取样频率 $f_s$ 下：$0.3f_h$、$0.6f_h$、$1.2f_h$、$1.8f_h$、$2.4f_h$，分别对 $x_1(t)$ 进行时域取样，形成取样序列 $x_1(n)$，对 $x_1(n)$ 进行DTFT。  

依据 $x_1(n)$ 的DTFT表达式，画出幅频特性图，观察 $x_1(n)$ 的幅度谱，与 $x_1(t)$ 的幅度谱进行对比和分析讨论。

③作图要求幅度归一化，频率单位为Hz。$x_1(t)$ 幅度谱的频率范围为0～120Hz，$x_1(n)$ 幅度谱的频率范围为 $0～f_s$。

#### 1.3.2 仿真结果  

![1-1.svg](/data/数字信号处理A/dsp1/1-1.svg)

#### 1.3.3 结果分析  

子图 1 (CFT)：信号的能量严格集中在 $0 \sim 10\text{Hz}$ 之间，这说明该信号是带限的，$f_h = 10\text{Hz}$。根据奈奎斯特采样准则，合适的采样频率应满足 $f_s \ge 2f_h = 20\text{Hz}$。

子图 2~5 ($f_s = 3, 6, 12, 18\text{Hz}$)：由于这些采样频率都小于 $20\text{Hz}$（欠采样），你会观察到频谱发生了混叠 (Aliasing)，原本的矩形形状被扭曲，高频成分折叠回了低频区域。

子图 6 ($f_s = 24\text{Hz}$)：此时 $f_s > 2f_h$，满足采样定理。你会发现频谱在 $0 \sim 10\text{Hz}$ 范围内恢复了完美的矩形形状，说明没有发生混叠，可以完整重构原始信号。


#### 1.3.2 题目2  

（2）设 $x_2(t)=e^{-100t}\sin{(2\pi f_q t)}$，$f_q=100Hz$。

①使用MATLAB内置的fourier函数对 $x_2(t)$ 进行CFT，并画出幅频特性图，观察 $x_2(t)$ 的幅度谱，观察 $x_2(t)$ 带宽是否无限、高频段的幅度是否有明显衰减，并根据频谱能量95%的近似原则确定合适的取样频率 $f_s$。

②取样频率 $f_s$ 取 $f_q$、$4f_q$、$6f_q$、$10f_q$ 时，分别对 $x_2(t)$ 进行时域取样，形成不同的取样序列 $x_2(n)$，对 $x_2(n)$ 分别进行DTFT，并画出幅频特性图。随着取样频率 $f_s$ 的增加，观察 $X_2(e^{j\omega})$ 频谱混叠现象的变化情况，并分析讨论。

③要求幅度归一化，频率单位为Hz。$x_2(t)$ 幅度谱的频率范围为0～400Hz，$x_2(n)$ 幅度谱的频率范围为 $0～f_s$。

#### 1.3.2 仿真结果

![1-2.svg](/data/数字信号处理A/dsp1/1-2.svg)

#### 1.3.3 结果分析

1、核心结论与参数确定带宽无限性：

信号 $x_2(t) = e^{-100t} \sin(2\pi f_q t)$ 在时域是因果信号且有突变，根据傅里叶变换性质，其频谱 $X_2(f)$ 是无限宽的，高频段幅度随频率增加逐渐衰减。

2、95% 能量带宽 ($B$)：通过计算 $|X_2(f)|^2$ 的积分，当累积能量达到总能量的 95% 时，对应的频率截止点 $B \approx 132\text{Hz}$。

合适采样频率 ($f_s$)：根据奈奎斯特准则，为避免严重混叠，采样频率应满足 $f_s > 2B$。

在本题中，$f_s > 2 \times 132 = 264\text{Hz}$。因此，$f_s = 1f_q (100\text{Hz})$ 不合适。

$f_s = 4f_q, 6f_q, 10f_q$（即 $400, 600, 1000\text{Hz}$）均 合适，且 $f_s$ 越大，还原效果越精确。

### 1.4 结论  

通过本实验，验证了奈奎斯特采样定理的核心原理：

（1）对于带限信号（如题目1中的$x_1(t)$），只有当采样频率$f_s \geq 2f_h$时，才能避免频谱混叠，完整保留原信号信息。当$f_s < 2f_h$时，会产生严重的频谱混叠现象，导致信号失真。

（2）对于无限带宽信号（如题目2中的$x_2(t)$），实际应用中需根据能量分布特点选择合适的采样频率。通过95%能量准则确定有效带宽，可有效平衡采样效率与信号保真度。

（3）时域采样操作在频域表现为周期性频谱复制，采样频率的选择直接决定了频谱复制的间隔，从而影响信号重构的质量。

本实验深化了对连续时间信号数字化处理基本原理的理解，为后续数字信号处理学习奠定了重要基础。

### 1.5 代码
#### 题目1
```matlab
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
```
#### 题目2
```matlab
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
``` 