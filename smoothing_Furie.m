function [smoothed_pxx, fxx] = smoothing_Furie(signal, fs, wave, level, sorh)

    [pxx, fxx, ~, ~] = envspectrum(signal, fs);
    Pxx = abs(pxx).^2;
    logPxx = 10*log10(Pxx);
    [C, L] = wavedec(logPxx, level, wave); % Разложение сигнала вейвлетом
    thr = 0.2;
    
    for i = 1:level 
        startIndex = sum(L(1:i))+ 1;
        endIndex = sum(L(1:i+1));
        C(startIndex:endIndex) = wthresh(C(startIndex:endIndex), sorh, thr);
    end
    % Восстановление сигнала
    logPxx_smoothed = waverec(C, L, wave);
    Pxx_smoothed = 10.^(logPxx_smoothed/10); % Преобразование обратно в линейную шкалу
    
    smoothed_pxx = exp(log(Pxx_smoothed)+double(eulergamma));
end 