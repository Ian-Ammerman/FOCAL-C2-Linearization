close all; clear all; clc;

load('DT1_A.mat');
load('DT1_B.mat');
load('DT1_C.mat');
load('DT1_D.mat');
load('DT1_ss_data.mat');

%% ---------- REARRANGE STATES ORDER ---------- %%
new_order = [4,5,11,12,13,14,15,1,2,3,6,7,8,9,10,16,17,18,19,20]';

for i = 1:length(new_order)
    row = new_order(i);

    Anew(i,:) = A(row,:);
    Bnew(i,:) = B(row,:);
end

% Define C matrix
Cnew = eye(length(new_order));
Cnew(8:end,:) = zeros(size(Cnew(8:end,:)));

% Define empty D matrix
Dnew = zeros(size(B));

%% ---------- SPLIT MATRICES INTO MEASURED/ESTIMATED SETS ---------- %%
A11 = Anew(1:7,1:7);
A12 = Anew(1:7,8:end);
A21 = Anew(8:end,1:7);
A22 = Anew(8:end,8:end);

B1 = Bnew(1:7,:);
B2 = Bnew(8:end,:);

% Note: New C matrix already defined above.

%% ---------- COMPUTE OBSERVER GAINS L ---------- %%
Q2 = [A12;A12*A22];

SYS = ss(Anew,Bnew,Cnew,Dnew);

old_poles = pole(SYS);
new_poles = 10*real(old_poles)-10;

p = poly(new_poles);
for i = flip(1:length(p))
    alpha = (A22^i)*p(end+1-i);
end
