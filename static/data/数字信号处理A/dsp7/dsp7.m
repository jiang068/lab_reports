% 实验参数设置
fs = 500e6;          % 采样频率 500MHz
f0 = 150e6;          % 中心频率 150MHz
B  = 100e6;          % 通带宽度 100MHz
fc = [100e6, 200e6]; % 截止频率范围
wn = fc / (fs/2);    % 归一化截止频率

% 定义不同的阶数 N
N_vals = [50, 150, 500]; 
windows = {'boxcar', 'triang', 'hamming', 'hanning', 'blackman'};
win_names = {'矩形窗', '三角形窗', '海明窗', '汉宁窗', '布莱克曼窗'};

figure('Color', 'w');

%% 任务 (1) & (2): 不同窗函数的对比 (固定 N=150)
subplot(2,1,1);
hold on;
N = 150;
for i = 1:length(windows)
    % 生成滤波器系数
    h = fir1(N, wn, feval(windows{i}, N+1));
    [H, f] = freqz(h, 1, 1024, fs);
    plot(f, abs(H), 'LineWidth', 1.5);
end
title(['不同窗函数频率特性对比 (N=', num2str(N), ')']);
xlabel('频率 (Hz)'); ylabel('归一化幅度');
legend(win_names); grid on;

%% 任务 (1)-②: 改变系统阶数 N (以矩形窗为例)
subplot(2,1,2);
hold on;
for N = N_vals
    h = fir1(N, wn, boxcar(N+1));
    [H, f] = freqz(h, 1, 1024, fs);
    plot(f, abs(H), 'LineWidth', 1.5);
end
title('矩形窗在不同阶数 N 下的对比');
xlabel('频率 (Hz)'); ylabel('归一化幅度');
legend(strcat('N = ', string(N_vals))); grid on;