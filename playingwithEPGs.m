%% Try GRE with relaxation with EPG_custom.m
clear all
close all
N = 10;
delk = 1;
seq.rf = repmat([0;30],1,3);
seq.grad = [-delk delk delk delk,...
            -delk delk delk delk,...
            -delk delk delk delk];
seq.time = [ 0  5 10 15 20 20,... 
            20 25 30 35 40 40,...
            40 45 50 55 60 60];
seq.events ={'rf','grad','grad','grad','grad','relax',...
             'rf','grad','grad','grad','grad','relax',...
             'rf','grad','grad','grad','grad','relax'};
seq.T1 = 1000;%ms
seq.T2 = 100;%ms
seq.tau = 10;%ms
seq.name = 'GRE';
EPG_custom(seq,1)
%% Try GRE without negative gradient (only net)
clear all
close all
delk = 1;
seq.rf = repmat([0;30],1,3);
seq.grad = [delk delk delk];
seq.time = [0 10 10  ,...
            10 20 20,...
            20 30 30];
seq.events= {'rf','grad','relax',...
            'rf','grad','relax',...
            'rf','grad','relax'};
E1 = 0.99;
E2 = 0.90;

seq.T1 = -10/log(E1); % ~ 1000
seq.T2 = -10/log(E2); % ~ 100
seq.name = 'GRE Wiegel';
om = EPG_custom(seq,1);
%% TSE
close all
clear all
delk = 1;
seq.rf = [ 90   0   0   0   0; 
           90 120 120 120 120];
seq.grad = [delk delk delk delk delk delk delk delk];%gradient shift direction
seq.time = [0 10 10 20 30 30 40 50 50 60 70 70 80]; %User defined
seq.events = {'rf', 'grad','rf','grad','grad','rf','grad','grad','rf','grad','grad','rf','grad'}; 
seq.name = 'TSE';
seq.T1 = 1000;
seq.T2 = 100;
EPG_custom(seq,1);
%% Play with variable rf
close all
clear all
seq.rf = [90 0  0   0   0;   
          90 30 60 90 120];
seq.grad = ones(1,8);
seq.time = [0 10 10 20 30 30 40 50 50 60 70 70 80];
seq.events = {'rf', 'grad','rf','grad','grad','rf','grad','grad','rf','grad','grad','rf','grad'}; 
seq.name = 'TSE variable';
seq.T1 = 0;
seq.T2 = 0;
myom = EPG_custom(seq,1);
%% Run simulations of TSE with ultra short esp and relaxation effects
clear all
close all
alpha = 120;
dur = 50;
esp = 1e-3;
[om_store_gm,echos_gm] = EPGsim_TSE(alpha,dur,esp,'gm',0,0);
[om_store_wm,echos_wm] = EPGsim_TSE(alpha,dur,esp,'wm',0,0);

% Plot echos
figure; hold on
subplot(2,1,1);stem(echos_gm(:,1),echos_gm(:,2));
title(sprintf('GM'))
xlabel('Time(ms)'),ylabel('Echo intensity')
subplot(2,1,2);stem(echos_wm(:,1),echos_wm(:,2));title('WM')
xlabel('Time(ms)'),ylabel('Echo intensity')
fprintf('Simulating with alpha = %d degrees',alpha)
fprintf(' and esp = %0.4f ms',esp)

%% Find steady state echo intensity for different flip angles
close all
clear all
all_alphas = 5:5:180;
P = length(all_alphas);
intensities_gm = zeros(1,P);
intensities_wm = zeros(1,P);
for p = 1:P
    [om_store_gm,echos_gm] = EPGsim_TSE(all_alphas(p),50,1e-3,'gm',0,0);
    [om_store_wm,echos_wm] = EPGsim_TSE(all_alphas(p),50,1e-3,'wm',0,0);
    n1 = size(echos_gm,1);
    n2 = size(echos_wm,1);
    intensities_gm(p) = max(echos_gm(max(n1-10,1):n1,2));
    intensities_wm(p) = max(echos_wm(max(n2-10,1):n2,2));
end
figure(1); hold on
subplot(2,1,1); hold on; title('GM')
plot(all_alphas,intensities_gm,'-*')
xlabel('Alpha'), ylabel('Echo intensity')
subplot(2,1,2); hold on; title('WM')
plot(all_alphas,intensities_wm,'-*')
