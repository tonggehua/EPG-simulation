function [om_store,echoes,seq] = EPGsim_bSSFP(alpha,N,TR,rlx)
% N must be even (if odd, it will be N+1)
N = 2*ceil(N/2);
seq.T1 = rlx(1);
seq.T2 = rlx(2);
seq.name = 'Balanced SSFP';
seq.rf = [zeros(1,N);repmat([alpha,-alpha],1,N/2)];
seq.events = {};
seq.time = [0,TR/2,TR];
seq.grad = 0;
for u = 1:N-1
    seq.time = [seq.time seq.time(end) seq.time(end)+TR/2 seq.time(end)+TR];
end
for k = 1:N
    seq.events{end+1} = 'rf';
    seq.events{end+1} = 'relax';
    seq.events{end+1} = 'relax';
    
end

[om_store,echoes] = EPG_custom(seq);
echoes = findAllEchos(seq,om_store);
% %figure(1);display_epg(om_store,seq,1,gca);
% figure(2);stem(echos(:,1),echos(:,2),'.')
% hold on;
% E1 = exp(-0.5*TR/seq.T1); E2 = exp(-0.5*TR/seq.T2);
% level = sind(alpha)*(1-E1)/(1-(E1-E2)*cosd(alpha)-E1*E2);
% plot([seq.time(1),seq.time(end)],[level,level],'-k')
end