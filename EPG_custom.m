function [om_store,echoes] = EPG_custom(seq)
%EPG_custom
% Performs EPG simulation of a general pulse sequence
% INPUTS 
%     seq: sequence struct with the required fields
%         seq.rf - 2xn matrix with each col = [phi,alpha]'
%         seq.grad - vector of gradient strengths. Each time interval
%                    must have a nonempty gradient
%         seq.events - cell of chars: 'rf','grad', or 'relax'
%         seq.timing - vector of timing for each event in seq.events
%         seq.T1, seq.T2 : T1 and T2 values for relaxation (0 for no relaxation)
%%  Inputs
% These are the seq fields that need to be populated outside of the
% EPG_custom() function
rf = seq.rf;
grad = seq.grad;
timing = seq.time; % in ms
uniqtimes = unique(timing);
events = seq.events; % 3 types of events: 'rf','grad', and 'relax'
N = length(events);
T1 = seq.T1; % must be populated - set to 0 for no relaxation
T2 = seq.T2; % must be populated - set to 0 for no relaxation
%% Initialize
omega = [0 0 1].'; % initial magnetization is always at equilibrium (+z)
%delk=1; %Unit dephasing
rf_index = 1;
om_index = 1;
grad_index = 1;
%% Describe pulse sequence in steps
om_store = cell(1,N);
for n = 1:N
   switch events{n}
       case 'rf'
           omega = rf_rotation(rf(1,rf_index),rf(2,rf_index))*omega;
           rf_index = rf_index + 1;
       case 'grad'
           omega = shift_grad(grad(grad_index),omega);     
           grad_index = grad_index + 1;
       case 'relax'
           q = find(uniqtimes==timing(n));
           tau = uniqtimes(q) - uniqtimes(q-1);
           omega = relax(tau,T1,T2,omega);
   end
   om_store{om_index} = omega;
   om_index = om_index + 1;
end
% Find and store echos
echoes = findEchoes(seq,om_store);

end

