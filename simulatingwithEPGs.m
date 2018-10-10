%% simulatingwithEPGs.m
% This script runs several EPG simulations 
% Created by Gehua Tong, Oct 10 2018

%% Run simulations of TSE with ultra short esp and relaxation effects
clear all
close all
alpha = 150;
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
figure; hold on
subplot(2,1,1); hold on; title('GM')
plot(all_alphas,intensities_gm,'-*')
xlabel('Alpha'), ylabel('Echo intensity')
subplot(2,1,2); hold on; title('WM')
plot(all_alphas,intensities_wm,'-*')
