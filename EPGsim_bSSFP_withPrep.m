function [om_store,echoes,seq] = EPGsim_bSSFP_withPrep(alpha,N,TR,rlx)
% [alpha/2] followed by N repeats of [-alpha +alpha]: 2*N + 1 total pulses
N = N/2;
seq.T1 = rlx(1);
seq.T2 = rlx(2);
seq.name = 'Balanced SSFP';
seq.rf = [zeros(1,2*N+1);[alpha/2, repmat([-alpha,alpha],1,N)]];
seq.time = [0,TR/2,TR/2];
for u = 1:2*N
    seq.time = [seq.time seq.time(end) seq.time(end)+TR/2 ...
                seq.time(end)+TR/2, seq.time(end)+TR, seq.time(end)+TR];
end
seq.events = {'rf','grad','relax'};
for k = 1:2*N
    seq.events{end+1} = 'rf';
    seq.events{end+1} = 'grad';
    seq.events{end+1} = 'relax';
    seq.events{end+1} = 'grad';
    seq.events{end+1} = 'relax';
    
end
seq.grad = zeros(1,4*N + 1);

[om_store,echoes] = EPG_custom(seq);
echoes = findAllEchos(seq,om_store);
% %figure(1);display_epg(om_store,seq,1,gca);
% figure(2);stem(echos(:,1),echos(:,2),'.')
% hold on;
% E1 = exp(-0.5*TR/seq.T1); E2 = exp(-0.5*TR/seq.T2);
% level = sind(alpha)*(1-E1)/(1-(E1-E2)*cosd(alpha)-E1*E2);
% plot([seq.time(1),seq.time(end)],[level,level],'-k')
end