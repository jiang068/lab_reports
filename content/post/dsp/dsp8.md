---
title: "实验8 线性相位系统"
slug: dsp8
date: 2026-01-17
draft: false
categories: ["编程", "信号", "matlab"]
tags: ["数字信号处理", "信号", "matlab"]
params:
  hidden: true
---


## 实验8 线性相位系统

### 8.1 实验目的

（1）观察理解IIR滤波器的非线性相位特性与FIR滤波器的线性相位特性。

（2）探究两类相位特性对信号处理的影响。

### 8.2 实验原理

设计频带指标相同的IIR滤波器与FIR滤波器，观察两类滤波器对信号波形的影响。观察非线性相位的IIR滤波器发生的色散现象。

### 8.3 实验内容

（1）设计IIR低通滤波器。通带截止频率 $0.8\pi$，通带起伏小于1dB，过渡带宽小于 $0.1\pi$，止带衰减大于40dB，幅度模型Butterworth。

①使用MATLAB内置的buttord与butter函数设计出符合指标要求的滤波器，利用MATLAB内置的freqz函数画出幅频特性曲线和相频特性曲线，利用MATLAB内置的grdelay函数测量设计出的滤波器的群时延。

（2）设计FIR低通滤波器。通带截止频率 $0.8\pi$，过渡带宽小于 $0.1\pi$，止带衰减大于40dB。线性相位特性，窗函数法。

①使用MATLAB内置的fir1函数（默认为Hamming窗）设计出符合指标要求的滤波器，利用MATLAB内置的freqz函数画出幅频特性曲线和相频特性曲线，利用MATLAB内置的grdelay函数测量设计出的滤波器的群时延。

（3）$x_1(n)=\sin(\omega_1 n)$，$x_2(n)=\sin(\omega_2 n)$，$\omega_1=0.1\pi$，$\omega_2=0.7\pi$，序列长度为 $N=80$，分别输入IIR和FIR滤波器，观察群延迟（系统时延），与上述测量结果对比验证。

①使用MATLAB内置的filter函数模拟输入信号通过滤波器，并用MATLAB内置的stem函数画出通过前后的时域波形图。

（4）$x(n)=x_1(n)+x_2(n)$，分别输入IIR和FIR滤波器，观察对比输入波形和两个输出波形。

①使用MATLAB内置的filter函数模拟输入信号通过滤波器，并用MATLAB内置的stem函数画出通过前后的时域波形图。

### 8.4 仿真结果  

![8-1.svg](8-1.svg)
![8-2.svg](8-2.svg)
![8-3.svg](8-3.svg)
![8-4.svg](8-4.svg)

### 8.5 结果分析

**1. 滤波器特性对比分析**

**IIR Butterworth滤波器特性：**
- 幅频特性满足设计指标，过渡带陡峭，阻带衰减良好
- 相频特性呈现明显的非线性特征，不同频率分量的相位延迟不同
- 群时延随频率变化，在通带边缘处群时延变化剧烈

**FIR滤波器特性：**
- 幅频特性同样满足设计要求，但需要更高的阶数才能达到相同的选择性
- 相频特性严格线性，保证了信号的相位不失真
- 群时延为常数，所有频率分量的时延相同

**2. 单频信号测试结果**

对于单频信号$x_1(n)=\sin(0.1\pi n)$和$x_2(n)=\sin(0.7\pi n)$：
- IIR滤波器输出显示不同频率的信号存在不同的时间延迟
- FIR滤波器输出所有频率分量的时延保持一致
- 实际测量的群时延与理论分析结果吻合

**3. 复合信号色散现象**

对于复合信号$x(n)=x_1(n)+x_2(n)$：
- IIR滤波器输出出现明显的色散现象，波形发生畸变
- FIR滤波器输出保持了原信号的波形特征，仅存在整体时延
- 验证了非线性相位对信号完整性的不利影响

### 8.6 结论

本实验深入比较了IIR和FIR滤波器的相位特性及其对信号处理的影响：

（1）**相位特性差异**：IIR滤波器具有非线性相位，会造成不同频率分量的色散；FIR滤波器具有严格的线性相位，能保持信号波形不失真。

（2）**设计权衡**：IIR滤波器用较低阶数即可达到良好的幅频选择性，但存在相位失真；FIR滤波器虽需更高阶数，但能保证线性相位特性。

（3）**应用指导**：对于要求保持信号波形完整性的应用（如数字通信、音频处理），应优先选择FIR滤波器；对于仅关注频率选择性的场合，IIR滤波器更为高效。

实验验证了线性相位在信号处理中的重要性，为滤波器选择提供了重要依据。
### 8.7 代码
```matlab
%% 实验 8.3: IIR 与 FIR 滤波器设计与分析
clear; clc; close all;

% 公共参数
wp = 0.8*pi; tr_width = 0.1*pi; ws = wp + tr_width;
Rp = 1; As = 40;

%% (1) IIR Butterworth 设计
[N1, Wn1] = buttord(wp/pi, ws/pi, Rp, As); 
[b1, a1] = butter(N1, Wn1);                

figure('Name', 'Task 1: IIR Analysis');
subplot(3,1,1); [h1, w1] = freqz(b1, a1, 1024);
plot(w1/pi, 20*log10(abs(h1))); grid on; title('IIR 幅频特性 (dB)');
subplot(3,1,2); plot(w1/pi, angle(h1)); grid on; title('IIR 相频特性 (rad)');
subplot(3,1,3); [gd1, w_gd1] = grpdelay(b1, a1, 1024);
plot(w_gd1/pi, gd1); grid on; title('IIR 群时延 (Samples)');

%% (2) FIR Hamming 设计
N2_order = ceil(6.6*pi/tr_width); 
if mod(N2_order, 2) == 0, N2_order = N2_order + 1; end 
wc = (wp + ws) / 2;               
b2 = fir1(N2_order-1, wc/pi, hamming(N2_order)); 
a2 = 1; 

figure('Name', 'Task 2: FIR Analysis');
subplot(3,1,1); [h2, w2] = freqz(b2, a2, 1024);
plot(w2/pi, 20*log10(abs(h2))); grid on; title('FIR 幅频特性 (dB)');
subplot(3,1,2); plot(w2/pi, angle(h2)); grid on; title('FIR 相频特性 (rad)');
subplot(3,1,3); [gd2, w_gd2] = grpdelay(b2, a2, 1024);
plot(w_gd2/pi, gd2); grid on; title('FIR 群时延 (Samples)');

%% (3) 信号测试与群时延对比验证 (新起子图画时延)
n = 0:79;
x1 = sin(0.1*pi*n); x2 = sin(0.7*pi*n);
y1_iir = filter(b1, a1, x1); y2_iir = filter(b1, a1, x2);
y1_fir = filter(b2, a2, x1); y2_fir = filter(b2, a2, x2);

figure('Name', 'Task 3: Signal Response & Group Delay');
% --- 第一列：IIR 结果 ---
subplot(3,2,1); stem(n, x1, 'r', 'MarkerSize', 2); hold on; stem(n, y1_iir, 'b');
grid on; title('IIR 对 x1(0.1\pi) 响应');
subplot(3,2,3); stem(n, x2, 'r', 'MarkerSize', 2); hold on; stem(n, y2_iir, 'b');
grid on; title('IIR 对 x2(0.7\pi) 响应');
subplot(3,2,5); plot(w_gd1/pi, gd1); hold on; 
% 标出两个测试点的延迟位置
gd_01 = interp1(w_gd1, gd1, 0.1*pi); gd_07 = interp1(w_gd1, gd1, 0.7*pi);
plot(0.1, gd_01, 'ro', 0.7, gd_07, 'ro'); grid on;
title(['IIR群时延(验证: ',num2str(gd_01,'%.1f'),', ',num2str(gd_07,'%.1f'),')']);

% --- 第二列：FIR 结果 ---
subplot(3,2,2); stem(n, x1, 'r', 'MarkerSize', 2); hold on; stem(n, y1_fir, 'b');
grid on; title('FIR 对 x1(0.1\pi) 响应');
subplot(3,2,4); stem(n, x2, 'r', 'MarkerSize', 2); hold on; stem(n, y2_fir, 'b');
grid on; title('FIR 对 x2(0.7\pi) 响应');
subplot(3,2,6); plot(w_gd2/pi, gd2); hold on;
gd_fir = (length(b2)-1)/2;
plot(0.1, gd_fir, 'ro', 0.7, gd_fir, 'ro'); grid on;
title(['FIR群时延(验证固定延迟: ',num2str(gd_fir),')']);
legend('输入x','输出y');

%% (4) 混合信号测试
x_mix = x1 + x2;
y_mix_iir = filter(b1, a1, x_mix); y_mix_fir = filter(b2, a2, x_mix);

figure('Name', 'Task 4: Mixed Signal Response');
subplot(3,1,1); stem(n, x_mix, 'filled', 'MarkerSize', 3); title('混合输入 x1+x2');
subplot(3,1,2); stem(n, y_mix_iir, 'MarkerSize', 3); title('IIR 滤波后输出');
subplot(3,1,3); stem(n, y_mix_fir, 'MarkerSize', 3); title('FIR 滤波后输出');
```