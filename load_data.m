function [x, fs, t, BPFI, BPFO] = load_data(file)
    % Неисправность внутренненого кольца
    data = load(fullfile(matlabroot, 'toolbox', 'predmaint', 'predmaintdemos', 'bearingFaultDiagnosis', 'train_data', file));
    x = data.bearing.gs;
    fs = data.bearing.sr;
    t = (0:length(x)-1)/fs;
    BPFI = data.BPFI;
    BPFO = data.BPFO;
end
% % Неисправностей нет
% dataNormal = load(fullfile(matlabroot, 'toolbox', 'predmaint', ...
%     'predmaintdemos', 'bearingFaultDiagnosis', ...
%     'train_data', 'baseline_1.mat'));
% x = dataNormal.bearing.gs;
% fs = dataNormal.bearing.sr;
% t = (0:length(x)-1)/fs;
% BPFI = dataNormal.BPFI;
% BPFO = dataNormal.BPFO;
% 
% % Неисправность внешнего кольца
% dataOuter = load(fullfile(matlabroot, 'toolbox', 'predmaint', ...
%     'predmaintdemos', 'bearingFaultDiagnosis', ...
%     'train_data', 'OuterRaceFault_2.mat'));
% x = dataOuter.bearing.gs;
% fs = dataOuter.bearing.sr;
% t = (0:length(x)-1)/fs;
% BPFI = dataInner.BPFI;
% BPFO = dataOuter.BPFO;
