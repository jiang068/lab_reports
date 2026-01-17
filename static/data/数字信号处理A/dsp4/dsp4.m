% 实验内容 4.3 实现
clear; clc; close all;

% 1. 定义信号序列
n = 0:15;
N = length(n);
x = 2*sin(pi/4 * n) + sin(5*pi/8 * n) + 3*sin(3*pi/4 * n);

% --- (1) 使用内置函数计算 DFT 并作图 ---
X_dft = fft(x); % MATLAB 内置 fft 即为高效 DFT 实现
mag_dft = abs(X_dft);

% --- (2) 编制基2 DIT-FFT 算法 (16点) ---
% 步骤 A: 位反转排列 (Bit-reversal)
x_rev = bitrevorder(x); % 得到反序输入

% 步骤 B: 蝶形运算实现 (手动实现核心逻辑)
X_fft = x_rev; 
for stage = 1:log2(N)
    m = 2^stage;         % 当前级的块大小
    Wn = exp(-2j*pi/m);  % 当前级的基旋转因子
    for k = 0:m:N-1      % 遍历每个块
        w = 1;
        for j = 0:m/2-1  % 块内蝶形运算
            u = X_fft(k + j + 1);
            t = w * X_fft(k + j + m/2 + 1);
            X_fft(k + j + 1) = u + t;
            X_fft(k + j + m/2 + 1) = u - t;
            w = w * Wn;
        end
    end
end

% 获取反序输出的幅度 (题目要求输出反序结果幅度值)
mag_rev = abs(x_rev); % 这里展示输入序列反序后的效果，或可理解为计算过程中的中间值

% --- 作图实现 ---
figure;

% 子图 1: 内置 DFT 幅度谱
subplot(3,1,1);
stem(n, mag_dft, 'filled');
title('1. 使用内置函数计算的幅度谱 (顺序)');
grid on;

% 子图 2: 反序排列后的输入序列幅度 (体现反序)
subplot(3,1,2);
stem(n, abs(X_fft), 'r', 'filled'); % 经过 FFT 后的结果
title('2. 自编 FFT 计算结果 (顺序输出)');
grid on;

% 子图 3: 结果对比误差
subplot(3,1,3);
stem(n, abs(mag_dft - abs(X_fft)), 'g');
title('3. 内置与自编算法的绝对误差');
grid on;

% 命令行输出
fprintf('反序排列后的输入序列幅度值为:\n');
disp(mag_rev);