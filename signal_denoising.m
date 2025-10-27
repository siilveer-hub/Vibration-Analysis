function [denoised_signal] = signal_denoising(input_signal, wave, lev)
    % 1) Дополняем сигнал до длины N (степень 2)
    N = 2^nextpow2(length(input_signal));
    input_signal = [input_signal, zeros(1, N - length(input_signal))];
%     lev = log2(N)-1;
    % 2) Вычисляем вейвлет-коэффициенты с помощью вейвлет-преобразования
    [C, L] = wavedec(input_signal, lev, wave);  % используем вейвлет Дебичи
    
    % 3) Расчет шумового уровня (по критерию на основе АКФ)
    sigma_q = zeros(1, lev+1);
    j = round(lev/2);
    % Получаем вейвлет-коэффициенты для уровня j
    detail_coeffs = detcoef(C, L, j);
    approx_coeffs = appcoef(C, L, wave, j);
    coeffs = 1i*detail_coeffs + approx_coeffs;
    % Вычисление автокорреляционной функции (АКФ) и шумового уровня
    sigma_q = median(abs(coeffs - median(coeffs))) / 0.6745;
    
    
    % 4) Расчет порогов для мягкой пороговой обработки
    thresholds = zeros(1, lev);
    for j = lev:-1:round(lev/2)
        sigma = sigma_q/ 2^(j/2);
        thresholds(j) = sigma / sqrt(2) * sqrt(2 * log(N));
    end
    alpha = 1.5;
    m = L(1);
    [thr,sorh,keepapp] = ddencmp('den','wv',input_signal);
    denoised_signal  = wdencmp('gbl',C,L,wave,lev,thr,sorh,keepapp);
    
end
