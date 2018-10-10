function [om_store,echos] = EPG_custom(seq,annot,graphics)
%% EPG_custom.m:  performs EPG simulation of a general pulse sequence
% Gehua Tong
%inputs:
% seq: sequence struct with the required fields, listed below
% annot: set to 1 to annotate config. state values
% graphics: set to 1 to display EPG


%% Default options
if nargin == 1
    annot = 1;
    graphics = 1;
elseif nargin ==2
    graphics = 1;
end

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
echos = [];
% need to find echos from stored omegas
for v = 1:length(om_store)
    if abs(om_store{v}(1,1)) > 5*eps
        newecho = [timing(v),abs(om_store{v}(1,1))];
        echos = [echos;newecho]; % [time of echo, intensity of echo]
    end
end
echos = unique(echos,'rows');
%% Display
if graphics % if graphic option is on
    display_epg(om_store,seq,annot); % displays epg
    display_seq(seq);% displays simplified pulse sequence
end
end

