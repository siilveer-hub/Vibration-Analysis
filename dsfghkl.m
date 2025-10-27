% Параметры модели
fs = 10000;          % Частота дискретизации (Гц)
T = 1;               % Интервал наблюдения (с)
t = 0:1/fs:T-1/fs;   % Временная шкала
N = length(t);       % Количество отсчетов

% Параметры подшипника
fr = 30;             % Частота вращения вала (Гц)
f0 = 3000;           % Собственная частота подшипника (Гц)
BPFO = 3.6 * fr;     % Частота дефекта наружного кольца (Гц)
BPFI = 5.4 * fr;     % Частота дефекта внутреннего кольца (Гц)
BSF = 2.3 * fr;      % Частота дефекта тела качения (Гц)

% Амплитуда и декремент затухания
A_k = 1;             % Амплитуда импульсов
alpha_k = 500;       % Декремент затухания

% Шумовая составляющая (АБПШ)
SNR = 20;            % Отношение сигнал/шум (дБ)
noise_power = A_k^2 / (10^(SNR/10));  % Мощность шума
n = sqrt(noise_power) * randn(1, N);  % Белый шум

% Генерация сигналов
s_BPFO = defect_outer_ring(t, A_k, alpha_k, f0, BPFO, n);  % Дефект наружного кольца
s_BPFI = defect_inner_ring(t, A_k, alpha_k, f0, BPFI, fr, n);  % Дефект внутреннего кольца
s_BSF = defect_rolling_element(t, A_k, alpha_k, f0, BSF, fr, n);  % Дефект тела качения

% Визуализация сигналов
figure;
subplot(3, 1, 1);
plot(t, s_BPFO);
title('Сигнал с дефектом наружного кольца (BPFO)');
xlabel('Время (с)');
ylabel('Амплитуда');

subplot(3, 1, 2);
plot(t, s_BPFI);
title('Сигнал с дефектом внутреннего кольца (BPFI)');
xlabel('Время (с)');
ylabel('Амплитуда');

subplot(3, 1, 3);
plot(t, s_BSF);
title('Сигнал с дефектом тела качения (BSF)');
xlabel('Время (с)');
ylabel('Амплитуда');

% Функция для дефекта наружного кольца
function s = defect_outer_ring(t, A_k, alpha_k, f0, BPFO, n)
    K = round(BPFO * t(end));  % Количество импульсов
    s = zeros(1, length(t));
    for k = 1:K
        tau_k = (k - 1) / BPFO;  % Время задержки импульса
        s = s + A_k * exp(-alpha_k * (t - tau_k)) .* sin(2 * pi * f0 * (t - tau_k)) .* (t >= tau_k);
    end
    s = s + n;  % Добавление шума
end

% Функция для дефекта внутреннего кольца
function s = defect_inner_ring(t, A_k, alpha_k, f0, BPFI, fr, n)
    K = round(BPFI * t(end));  % Количество импульсов
    s = zeros(1, length(t));
    for k = 1:K
        tau_k = (k - 1) / BPFI;  % Время задержки импульса
        s = s + A_k * exp(-alpha_k * (t - tau_k)) .* sin(2 * pi * f0 * (t - tau_k)) .* (t >= tau_k);
    end
    s = (1 + 0.5 * sin(2 * pi * fr * t)) .* s + n;  % Модуляция и добавление шума
end

% Функция для дефекта тела качения
function s = defect_rolling_element(t, A_k, alpha_k, f0, BSF, fr, n)
    K = round(BSF * t(end));  % Количество импульсов
    s = zeros(1, length(t));
    for k = 1:K
        tau_k = (k - 1) / BSF;  % Время задержки импульса
        s = s + A_k * exp(-alpha_k * (t - tau_k)) .* sin(2 * pi * f0 * (t - tau_k)) .* (t >= tau_k);
    end
    s = (1 + 0.5 * sin(2 * pi * fr * t)) .* s + n;  % Модуляция и добавление шума
end