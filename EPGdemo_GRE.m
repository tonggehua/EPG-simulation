function [om_store,echos] = EPGdemo_GRE(alpha,N,TR,rlx)
%EPGdemo_TSE.m : demonstrates EPG of turbo spin echo sequence
% with an initial (90,90) pulse followed by N (0,alpha) pulses
%  alpha : flip angle of 2nd to (N+1)th pulses  
%  N : number of pulses after the initial (90,90) pulse
%  dt: TR between pulses (also )
%  rlx: mode of relaxation. 0 - no relaxation; 1 - GM; 2 - WM;

% Default: no relaxation
if nargin < 4
    rlx = 'none';
end
% Define T1 and T2, depending on tissue type
switch rlx
    case 'none'
       seq.T1 = 0; seq.T2 = 0;% zero T1,T2 means no relaxation in relax.m 
    case 'gm' % gray matter
       seq.T1 = 1300; seq.T2 = 110;
    case 'wm' % white matter
       seq.T1 = 960; seq.T2 = 80; 
    case 'default'
       seq.T1 = 1000; seq.T2 = 100; % same as in EPG paper for reference
end 

seq.name = 'Gradient Refocused Echo with relaxation';
seq.rf = repmat([0,alpha]',1,N);
seq.time = [];
dt = TR/4;
seq.events ={};
for n = 1:N
    seq.events{end+1} = 'rf';
    for m = 1:4
        seq.events{end+1} = 'grad';
    end
    seq.events{end+1} = 'relax';
    ts = TR*(n-1);
    seq.time = [seq.time,ts,ts+dt,ts+2*dt,ts+3*dt,ts+4*dt,ts+4*dt];
end
seq.grad = repmat([-1,1,1,1],1,N);
[om_store,echos] = EPG_custom(seq,1);

end

