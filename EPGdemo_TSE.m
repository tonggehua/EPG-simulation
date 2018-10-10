function om_store = EPGdemo_TSE(alpha,N,esp)
%EPGdemo_TSE.m : demonstrates EPG of turbo spin echo sequence
% with an initial (90,90) pulse followed by N (0,alpha) pulses
%  alpha : flip angle of 2nd to (N+1)th pulses  
%  N : number of pulses after the initial (90,90) pulse
%  dt: TR between pulses (also )
%  ASSUMES APPROXIMATELY NO RELAXATION
% --------------------------CODE BEGINS---------------------------
% No relaxation: this is just to populate the fields
seq.T1 = 0; seq.T2 = 0;% zero T1,T2 means no relaxation in relax.m 
% Time evolves in 0.5*esp steps (dt = 0.5*esp -> dk = 1) 
dt = esp/2;

% Define TSE sequence
seq.name = 'Turbo Spin Echo';
seq.rf(:,1) = [90,90]';
seq.rf(:,2:N+1) = repmat([0,alpha]',1,N);
seq.grad = ones(1,2*N+1);
seq.time = [0 dt];
seq.events = {'rf','grad'};

% Generate events and time info
for n = 1:N
    seq.events{end+1} = 'rf';
    seq.events{end+1} = 'grad';
    seq.events{end+1} = 'grad';
    seq.time = [seq.time (2*n-1)*dt (2*n)*dt (2*n+1)*dt];
end

% Simulate EPG
om_store = EPG_custom(seq,1);

end

