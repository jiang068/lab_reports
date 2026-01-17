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