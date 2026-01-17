---
title: "实验2 栅栏效应"
slug: dsp2
date: 2026-01-17
draft: false
categories: ["编程", "信号", "matlab"]
tags: ["数字信号处理", "信号", "matlab"]
params:
  hidden: true
---


## 实验2 栅栏效应

### 2.1 实验目的

（1）理解栅栏效应是连续频谱取样离散化之后呈现的一种视觉现象。

（2）理解在离散傅里叶变换（DFT）的定义下，栅栏效应呈现的不是误差，与频谱泄漏不同。

### 2.2 实验原理

栅栏效应，是对频域离散化现象的一个形象化描述，指DFT的频谱呈现在基频的整数倍处，只能在相应离散点处看到输出的现象。这像通过一个“栅栏”来观看图景一样，只能在离散点处看到真实图景。

### 2.3 实验题目

（1）设置N点离散序列 $x(n)=[1,1,0,1]$。

（2）对 $x(n)$ 分别做DTFT和DFT，画出 $X(e^{j\omega})$ 和 $X(k)$ 的幅频特性曲线，观察描述栅栏效应现象。

DTFT 的一般表达式为：

$$X(e^{j\omega}) = \sum_{n=-\infty}^{\infty} x(n) e^{-j\omega n}, \quad -\infty < \omega < \infty$$

DFT 的一般表达式为：

$$X(k) = \sum_{n=0}^{N-1} x(n) e^{-j\frac{2\pi}{N}nk}, \quad k = 0, 1, 2, \dots, N-1$$

（3）用 $X(k)$ 和内插函数重建 $X(e^{j\omega})$：

$$\hat{X}(e^{j\omega}) = \frac{1}{N} \sum_{k=0}^{N-1} X(k) \cdot \frac{1 - e^{-j\omega N}}{1 - W_N^{-k} e^{-j\omega}}$$

画出 $\hat{X}(e^{j\omega})$ 的幅频特性曲线，并与 $X(e^{j\omega})$ 的幅频特性曲线进行比较讨论。

### 2.4 仿真结果  

![2.svg](/data/数字信号处理A/dsp2/2.svg)

### 2.5 结果分析

① DTFT 与 DFT 的观察描述：

DTFT 是序列的连续频谱，展示了信号在整个频域的真实分布。

DFT 是对 DTFT 在 $[0, 2\pi]$ 范围内的等间隔采样。

栅栏效应 (Picket-Fence Effect)：由于 DFT 只在特定的离散点（采样点）上获取频谱值，如果信号的真实峰值不在这些采样点上，我们就无法通过 DFT 看到它，就像透过栅栏看风景，只能看到栅栏缝隙中的部分，从而导致频谱信息的丢失。

② 重建 $X(e^{j\omega})$ 的分析：

利用内插公式，可以用有限点的 DFT 序列 $X(k)$ 完美恢复出原有限长序列的 DTFT。

结论：计算得到的重建谱 $\hat{X}(e^{j\omega})$ 与直接计算的 $X(e^{j\omega})$ 曲线完全重合，这证明了 DFT 包含了原有限长序列在频域的全部信息。

### 2.6 结论

（1）**栅栏效应的本质**：DFT只能观察到离散频率点上的频谱值，就像透过栅栏观景一样，可能遗漏峰值信息，但这是离散化的固有特性，而非计算误差。

（2）**DTFT与DFT的关系**：DTFT提供连续频谱视图，DFT是对DTFT的等间隔采样。栅栏效应体现了从连续到离散的信息表示差异。

（3）**信息的完整性**：尽管存在栅栏效应，DFT仍包含了有限长序列的全部频域信息。通过内插公式可以完美重建原DTFT，证明了DFT的信息完备性。

（4）**实际意义**：理解栅栏效应有助于正确解释频谱分析结果，避免将视觉上的"信息缺失"误解为真正的信息丢失。
### 2.7 代码
```matlab
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
```