
## 实验5 信号通过IIR滤波器

### 5.1 实验目的

（1）理解系统对信号的作用、输入信号与输出信号的关系。

（2）任何复杂信号都可以看成是不同频率的简单正弦信号叠加的结果。

### 5.2 实验原理

观察一个矩形波信号通过低通滤波器。通过设置滤波器不同的截止频率，可以看到矩形波信号时域波形的变化。随着截止频率的升高，时域波形越接近矩形。

### 5.3 实验内容

（1）设计一个IIR低通滤波器。通带起伏小于1dB，止带衰减大于40dB，过渡带宽小于 $0.1\pi$，通带截止频率为 $\omega_p(n)=r\cdot 2\pi/N$，其中 $r$ 分别取5，10，15，20，40，$N=100$。

提示：IIR滤波器的设计可以使用MALTAB内置的buttord和butter函数。

（2）生成一个周期为 $N=100$ 的矩形信号序列 $x(n)$，

$$x(n)=\left\{\begin{matrix}1&0\le n\le\frac{N}{2}-1\\0&\frac{N}{2}\le n\le N-1\\\end{matrix}\right.$$

取10个周期长度，激励（1）中设计的低通滤波器（可使用MATLAB内置的filtfilt函数模拟该过程），得到输出序列 $y(n)$，并计算 $x(n)$ 和 $y(n)$ 的幅频特性。

（3）观察和比较滤波器取不同截止频率时，$x(n)$、$y(n)$ 的时域波形、幅频特性的变化，特别是方波棱角的变化（时域波形画出第2到第5个周期即可）。  

（4）采用双线性变换法设计一个数字切比雪夫I型高通滤波器。当 $\omega \le 0.2\pi$ 内，衰减大于15dB; 当 $0.3\pi \le \omega \le \pi$ 时，衰减小于1dB。并观察 $x(n)$ 通过该高通滤波器后输出 $y_{hp}(n)$ 的时域波形，并对比（3）中不同截止频率时输出时域波形与 $y_{hp}(n)$ 叠加后的波形（即 $y(n)+y_{hp}(n)$ 的时域波形）。


### 5.4 仿真结果  

![5-1.svg](5-1.svg)
![5-2.svg](5-2.svg)
![5-3.svg](5-3.svg)

### 5.5 结果分析
（3）观察与比较不同截止频率的影响时域波形变化：

随着截止频率 $\omega_p$（由参数 $r$ 决定）的减小，低通滤波器的通带变窄，滤除的高频谐波增多。

$r$ 较小时（如 $r=5$）：

方波的大部分谐波被滤除，输出波形接近平滑的正弦波。

$r$ 较大时（如 $r=40$）：

保留了更多高频分量，方波棱角变得清晰、陡峭，更接近原始信号，但在跳变处会出现轻微的吉布斯震荡。


幅频特性变化：

随着 $r$ 增大，幅度谱中保留的脉冲个数增多。$y(n)$ 的频谱包络逐渐向 $x(n)$ 的 $\text{Sa}(\omega)$ 型频谱靠拢。



（4）双线性变换法设计高通滤波器及叠加分析高通滤波器设计：

利用双线性变换法设计的切比雪夫 I 型高通滤波器，能够有效抑制 $0.2\pi$ 以下的低频（包括直流分量）和基波分量。

$y_{hp}(n)$ 波形特点：

高通滤波后的波形表现为在原始方波的上升沿和下降沿出现正负尖峰，实质上提取了信号的突变细节（边缘信息）。

叠加效果 $y(n) + y_{hp}(n)$：

将低通输出（平滑轮廓）与高通输出（边缘细节）叠加后，合成波形的边缘变得更加锐利。

这种叠加在工程上常用于信号增强，补偿了低通滤波造成的边缘模糊，使合成后的时域波形比单纯的低通输出更接近理想方波的跳变特征。

### 5.6 结论
本实验通过矩形波信号通过不同截止频率的IIR低通滤波器，验证了频域滤波对时域波形的影响规律。
实验表明，滤波器截止频率越高，保留的高频谐波越多，输出波形越接近原始方波；截止频率越低，输出越趋于平滑的正弦波。
高通滤波器能有效提取信号的边缘信息，与低通输出叠加后可实现信号增强效果。
实验深化了对频域与时域关系的理解，证明了复杂信号可分解为不同频率正弦波叠加的傅里叶理论基础。

### 5.7 代码
```matlab
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
```