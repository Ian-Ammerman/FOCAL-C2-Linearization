function  [Newtime,KtNew,ii,tc] = CausalIRF(gp,Excite,Kc,w,dT)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Function to compute the Impulse Response Function and form a
%  causal IRF through applying a time delay (chosen by user)                        
%                                                                 
%  Alan Wright 3-2018
%
%
% in collaboration with:
% Jason Jonkman - NREL
% NREL (www.wind.nrel.gov)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Let's first calculate the Impulse Response Function through MATLAB's ifft function. We will perform the ifft
%  command on the frequency response function Kc.
% Now let's get finer resolution frequency domain values.
% Interpolate the matrices to get a evenly spaced Hdro matrix


% ii: counter used later
ii=0;

% dT: time increment defined by user (input from ".inp file)
dT = Excite.dT;
% dw: delta frequency
dw = 2*pi/Excite.WaveTMax;
% wi: re-define frequency vector to with increment dw (finer increment than
% original wi)
wi = [0.0:dw:pi/Excite.dT]; 
%declare interpolated frequency response function
% np: length of frequency vector wi:
np=length(wi); 
Kc2 = [];


%go ahead and interpolate original FRF via wi   
Kc2= interp1(w,Kc,wi,'previous','extrap');

% Now take the steps to form a 2-sided FRF. We must assure that the 
% real components of the FRF are an even function of frequency, and the
% imaginary components are an odd function of frequency. To do this, flip
% Kc2 and then form complex conjugate. The modified FRF is formed from the
% original FRF stacked on top of the flipped and conjugated FRF.
KcConj = conj(flip(Kc2));   
Kc2sided = [Kc2; KcConj(1:length(KcConj)-1,1,:)];

% re-form frequency vector based on length of modified FRF and already
% calculated dw.
wi2 = [0:1:length(Kc2sided)-1]*dw; 
np2 = length(wi2);

% Now calculate the inverse Fourier Transform using Matlab's ifft command:
Kt2sided = ifft(Kc2sided)/dT;

% resulting 2-sided IRF is not centered. Center this IRF through Matlab's ifftshift command.
% Add more explanation here
K1t = ifftshift(Kt2sided(:,1));
K2t = ifftshift(Kt2sided(:,2));
K3t = ifftshift(Kt2sided(:,3));
K4t = ifftshift(Kt2sided(:,4));
K5t = ifftshift(Kt2sided(:,5));
K6t = ifftshift(Kt2sided(:,6));

N = length(K1t);
dT = Excite.dT;

%Form a time vector strictly for IRF plotting purposes.
%plotting time endpoint;
Tend = 30;
time = [-Tend:dT:Tend]'; 

%Consolidate shifted IRF components into 1 vector. Note that this is binned
% in terms of positive samples, with center at length(wi2)/2.
Kt2 = [K1t,K2t,K3t,K4t,K5t,K6t];
% Resulting x-axis of IRF functions assumes only positive time (sample
% counts). Shift to center contribution is at sample 0 (instead of sample
% length(wi2)/2) and reduce number of samples so that x-axis goes from
% -(N-1)/2-Tend/DT to +(N-1)/2-Tend/DT.
% positive sample counts)
Kt2b = Kt2((N-1)/2-Tend/dT: (N-1)/2+Tend/dT,:,:);


%% Continue...   
%Plot these shifted components. Note: this is the non-causal IRF.
figure('Name','Impulse Response Functions');
subplot(6,1,1), plot(time,Kt2b(:,1),'--black','Linewidth',1)
hold on;
xlabel('Time (sec)','FontSize',12)
title('IRF(1)')

subplot(6,1,2), plot(time,Kt2b(:,2),'--y','Linewidth',2)
hold on;
xlabel('Time (sec)','FontSize',12)
%ylabel('Thust(kN)','FontSize',12)
title('IRF(2)')

subplot(6,1,3), plot(time,Kt2b(:,3),'--c','Linewidth',2)
hold on;
xlabel('Time (sec)','FontSize',12)
%ylabel('Thust(kN)','FontSize',12)
title('IRF(3)')

subplot(6,1,4), plot(time,Kt2b(:,4),'--g','Linewidth',2)
hold on;
xlabel('Time (sec)','FontSize',12)
%ylabel('Thust(kN)','FontSize',12)
title('IRF(4)')

subplot(6,1,5), plot(time,Kt2b(:,5),'--r','Linewidth',2)
hold on;
xlabel('Time (sec)','FontSize',12)
%ylabel('Thust(kN)','FontSize',12)
title('IRF(5)')

subplot(6,1,6), plot(time,Kt2b(:,6),'--b','Linewidth',2)
hold on;
xlabel('Time (sec)','FontSize',12)
%ylabel('Thust(kN)','FontSize',12)
title('IRF(6)')

%% Now we will determine a causal IRF through the time-shifting method (see Report/User's manual)
% this is based on user's intuition and examination of the IRFs just
% plotted. You only choose one time delay value (tc)(worst case). This value of tc is applied to
% all IRF components. 
location = zeros(1,6);
time_delay = zeros(1,6);

if strncmp(Excite.tc,'auto',4) == 0
    tc = str2num(Excite.tc);
else
    % Loop over each IRF and find point when excitation begins to exceed
    % threshold
    for i = 1:6
        K_max = max(abs(real(Kt2b(:,i))));
        j = 1;
        isSmaller = false;
        while true
            val = abs(Kt2b(j,i));
            if val > Excite.frac*K_max
                location(i) = (length(Kt2b)/2) - j;
                break
            end
            j = j+1;
        end
    end

    % Compute time delay for each IRF based on time when threshold is
    % broken
    for i = 1:6
        time_delay(i) = location(i)*dT;
    end

    % Global time delay is set to maximum of all IRFs to capture all
    tc = max(time_delay);
end

disp(sprintf('Causalization time = %0.4g seconds',tc));
    
Nb = height(Kt2b);
%Now do the shifting by time tc/dT.
Ktshift = Kt2b((Nb-1)/2-tc/dT:length(Kt2b),:);

%Form revised time vector for plotting purposes:
Newtime =[0:1:length(Ktshift)-1]'*dT;
%Assemble time-shifted IRFs into one vector.
KtNew = [Ktshift(:,1),Ktshift(:,2),Ktshift(:,3),Ktshift(:,4),Ktshift(:,5),Ktshift(:,6)];

%Now plot these causal IRF components:
subplot(6,1,1), plot(Newtime,KtNew(:,1),'black','Linewidth',1)
xlabel('Time (sec)','FontSize',12)
title('IRF(1)')
   
subplot(6,1,2), plot(Newtime,KtNew(:,2),'y','Linewidth',1)
xlabel('Time (sec)','FontSize',12)
title('IRF(2)')

subplot(6,1,3), plot(Newtime,KtNew(:,3),'c','Linewidth',1)
xlabel('Time (sec)','FontSize',12)
title('IRF(3)')
   
subplot(6,1,4), plot(Newtime,KtNew(:,4),'g','Linewidth',1)
xlabel('Time (sec)','FontSize',12)
title('IRF(4)')

subplot(6,1,5), plot(Newtime,KtNew(:,5),'r','Linewidth',1)
xlabel('Time (sec)','FontSize',12)
title('IRF(5)')

subplot(6,1,6), plot(Newtime,KtNew(:,6),'b','Linewidth',1)
xlabel('Time (sec)','FontSize',12)
title('IRF(6)')

hold off;


