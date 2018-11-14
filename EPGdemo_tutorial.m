%% EPG demo / tutorial
% Gehua Tong, Nov 14 2018
% Run each section separately!


%% How to use EPG_custom.m
% Construct seq (a struct, not related to pulseq at the moment)
         seq.rf =  [0  0   0   0   0   0
                    90 180 180 180 180 180];
         seq.grad = [1,1,1,1,1,1,1,1,1];
         seq.events - cell of chars: 'rf','grad', or 'relax'
         seq.timing - vector of timing for each event in seq.events
         seq.T1, seq.T2 : T1 and T2 values for relaxation (0 for no relaxation)