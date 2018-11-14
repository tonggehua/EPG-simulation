% EPGsim_TSE_VFA.m
% Simulates variable flip angle (VFA) EPG with TSE scheme

function [om_store,echoes,seq] = EPGsim_TSE_VFA(alphas,esp,rlx)
% Note: 
%    (1) First pulse is always (90,90) to keep T(alpha) real
%    (2) TSE RF spacing:esp/2, esp, esp, esp, ....
%    (3) This is used to test VFA

T1 = rlx(1); T2 = rlx(2);
N = length(alphas);
dt = esp/2;

% Let's do it!
seq.name = 'VFA TSE';
seq.rf = [[90,90]', [zeros(size(alphas));alphas]];
seq.grad = ones(1,2*N+1);
seq.time = [0 dt dt];

seq.events = {'rf','grad','relax'};
for n = 1:N
    seq.time = [seq.time,seq.time(end),...
                seq.time(end)+dt,seq.time(end)+dt,...
                seq.time(end)+2*dt,seq.time(end)+2*dt];
    seq.events{end+1} = 'rf';
    seq.events{end+1} = 'grad';
    seq.events{end+1} = 'relax';
    seq.events{end+1} = 'grad';
    seq.events{end+1} = 'relax';
end
seq.T1 = T1; seq.T2 = T2; 

[om_store,echoes] = EPG_custom(seq);

end