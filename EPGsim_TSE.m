function [om_store,echos] = EPGsim_TSE(alpha,N,esp,rlx,annot,graphics)
%EPGdemo_TSE.m : demonstrates EPG of turbo spin echo sequence
% with an initial (90,90) pulse followed by N (0,alpha) pulses
%  alpha : flip angle of 2nd to (N+1)th pulses  
%  N : number of pulses after the initial (90,90) pulse
%  dt: TR between pulses (also )
%  rlx: mode of relaxation. 0 - no relaxation; 1 - GM; 2 - WM;


% Default: no relaxation, no annotation, and no EPG display
if nargin < 4
    rlx = 'none';
    annot = 0;
    graphics = 0;
end
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

dt = esp/2; % time evolves in 0.5*esp steps (dt = 0.5*esp -> dk = 1) 

seq.name = 'Turbo Spin Echo';
seq.rf(:,1) = [90,90]';
seq.rf(:,2:N+1) = repmat([0,alpha]',1,N);
seq.time = [0 dt dt];
seq.events = {'rf','grad','relax'};

for n = 1:N
    % Order of operators : T(rf)->S(grad)->E(relax) "TSE",easy to remember!
    seq.events{end+1} = 'rf';
    seq.events{end+1} = 'grad';
    seq.events{end+1} = 'relax';
    seq.events{end+1} = 'grad';
    seq.events{end+1} = 'relax';
    seq.time = [seq.time (2*n-1)*dt 2*n*dt 2*n*dt (2*n+1)*dt (2*n+1)*dt];
end
seq.grad = ones(1,2*N+1);
[om_store,echos] = EPG_custom(seq,annot,graphics);

end