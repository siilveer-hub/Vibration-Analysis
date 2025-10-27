function [filtered_signal] = ordinary(data, fs)

    low_cutoff = 100;  % Нижняя частота среза (Гц)
%     high_cutoff = 12000;  % Верхняя частота среза (Гц)
    high_cutoff = 1000;
    [b, a] = butter(4, [low_cutoff high_cutoff] / (fs / 2), 'bandpass');
    filtered_signal = filter(b, a, data);
   
end