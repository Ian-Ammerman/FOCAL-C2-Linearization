%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%% PARAMETRIC MODEL -Time domain - Realization Theory!!!- %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ssExcite] = Fit_StateSpace_Model(Excite,Kt,Newtime,dT, dof,ii)
fprintf('Using time domain identification, with K(t) and imp2ss.m.\n')%Method chosen

%Initializations
ssExcite(:).D=[];
N=zeros(1,1);
q=1; %Index for the number of significant entries of Kt

Legend = cell(100,1);
Ymaxold = 0.;

plottime = [0:1:max(Newtime)/dT]'*dT;   
   
final_ss_plt=[];
Nn = 0;
   

for s=1:1:ii %for each entry of the matrix
           
%filter the impulse response function to remove spikey data

%    windowSize = 8;
    windowSize = 4;
    b = (1/windowSize)*ones(1,windowSize);
    a = 1;
    KtSmooth = filter(b,a,Kt);

    %Fitting
    [A,B,C,D,~,~] = imp2ss(KtSmooth(:,dof(s)),dT,1,1,.01);
    [y,t]=impulse(ss(A,B,C*dT,0,0),plottime);
    
    %set first element of y to zero: spurious data
    y(1)=0.;

%% AUTOMATIC ORDER REDUCTION ---------------------------------------------------------
    a=0;
    if Excite.fmt==0 %If Automatic order reduction is selected

        figure('NumberTitle','off','Name','Impulse Response Function');
        NKt = length(KtSmooth);
        Ny = length(y);
        Nmin = min(NKt,Ny);
        irf_plt=plot(plottime(1:Nmin),KtSmooth(1:Nmin,dof(s)),'Linewidth',2,'DisplayName','IRF');
        % high_ss_plt = plot(t(1:Nmin),y(1:Nmin),'LineWidth',2);
        % Legend = cell(2,1);
        % Legend{1}=strcat('Original IRF');
        % Legend{2}=strcat('high order ss approx');
        legend;

        xlabel('Time [s]');
        if s>3
            ylabel('[kg.m^2/s^2]');
        else
            ylabel('[kg/s^2]');
        end
        title(strcat('K_{',num2str(dof(s)),'}(t)'));

        hold on;        iii = 0.;
        n2 = length(A);                    
        Nn(iii+1)=n2;

        % Initialize order and fitting parameters:
        n=1;
        Rsquare=0;
            
        while Rsquare<Excite.Fit  %Is the user satisfied with the goodness of the fit
            iii=iii+1;
            if(n<Excite.maxiter)
                n= n + 1;
                Nn(iii+1)=n;
            else
                break
            end
            
            % sys = ss(A,B,C*dT,0*D); % Form ss object
            % 
            % R = reducespec(sys,"balanced");
            % R.Options.FreqIntervals = [0,6.28];
            % 
            % [rsys,~] = getrom(R,Order=[n],Method="truncate");
            % 
            % [AM,BM,CM,DM] = ssdata(rsys);

            [AM,BM,CM,DM,~,~] =balmr(A,B,C*dT,0,1,n); %System must be casual (D=0)

            Kplottime = [0:1:length(Kt)-1]'*dT;   
            [Y(:,1),T]=impulse(ss(AM,BM,CM,DM,0),Kplottime); 

            res=KtSmooth(:,dof(s))-Y;                     %Residuals
            avrg=mean(KtSmooth(:,dof(s)));             %Sum of squares about the mean
            sst=sum(((KtSmooth(:,dof(s))-avrg).*conj(KtSmooth(:,dof(s))-avrg)));  %Weighted average value
            Rsquare=1-sum(res.^2)/sst %Sum of squares about the mean
            disp(['Iteration number ='])
            disp(n)
            if(n==Excite.maxiter)
              disp('maximum number of iterations reached')
              
            end       
%            Nn(iii+1)=n;
        end
        
        final_ss_plt=plot(T,Y,'Linewidth',2,'DisplayName',sprintf('%i order ss approx',n));
        % Legend{3}=strcat('',num2str(Nn(iii)),' th order ss approx');
        legend;
        title(strcat('Wave Excitation Force K_{',num2str(dof(s)),'}(t)')); 
        hold off;
        drawnow

%% MANUAL ORDER REDUCTION ------------------------------------------------------------- 
    else % Manual order detection

        iii = 0.;
        n = length(A);                    
        Nn(iii+1)=n;
        
        figure('NumberTitle','off','Name','Impulse Response Function');

        NKt = length(KtSmooth);
        Ny = length(y);
        Nmin = min(NKt,Ny);
        irf_plt=plot(plottime(1:Nmin),KtSmooth(1:Nmin,dof(s)),'Linewidth',2);
        Legend = cell(2,1);
        Legend{1}=strcat('Original IRF');
        % Legend{2}=strcat('high order ss approx');
        % legend(Legend);
%        legend('X(t)','~Kt(t)-original (i=200)');
        xlabel('Time [s]');
        
        if s>3
            ylabel('[kg.m^2/s^2]');
        else
            ylabel('[kg/s^2]');
        end
        title(strcat('K_{',num2str(dof(s)),'}(t)'));

        hold on;
               
        while a==0 %Is the user satisfied with the goodness of the fit
            iii = iii+1;
            prompt = 'Input the order n of fitted state-space model';
            n = input(prompt);
            Nn(iii)=n;
                   
            [AM,BM,CM,DM,TOTBND,HSV] =balmr(A,B,C*dT,0,1,n);%System must be casual (D=0)
            [Y(:,1),T]=impulse(ss(AM,BM,CM,DM,0),t);
                                      
            p2=plot(T,Y,'Linewidth',2);
            %plot(plottime,Y,'Linewidth',2);
            Legend{2}=strcat('',num2str(Nn(iii)),' th order ss approx');
            legend(Legend);
            drawnow;
            a=input('Is the state reduction good (1), or do you want to re-do it (0)?');
            if a == 0
                delete(p2);
                drawnow;
            end
        end                        
        hold off;

    end
 
%Stability of the system
[~,p,~] = zpkdata(ss(AM,BM,CM,DM));
unstable=0;
for j=1:length(p)
    if real(p{j})>0 
        unstable=1; 
    end 
end       
if unstable==1, error('Excitation dynamic system UNSTABLE'); end
         
%Output assembly
ssExcite(q).A=AM; ssExcite(q).B=BM;

if (q==1|| q==5  )
 ssExcite(q).C=-CM;
else
 ssExcite(q).C=CM;
end
ssExcite(q).D=DM;

%if r==s, N(s,r)=dof(s); else N(s,r)=-1; end  %Real DoFs          
q=q+1;
    
end

%% New (reduced) convolution array %%%
 %Comented out TD: In order to garantee that the output matrices are always
 %refering to 6 DOF's functions!
idx=find(diag(N)==0);
for j=1:length(idx)        % Loop to verify if there is a coss-copling % 
     if nnz(N(:,idx(j)))>0 % term higher than the diagonal value       %
        idx(j)=0;
     end
end
%N = removerows(N.',nonzeros(idx));
%N = removerows(N.',nonzeros(idx));
N = N;
N = N;

[i,j,s] = find(N.'); s(s<0)=0;
for u=1:length(i)
    ssExcite(u).ij=[j(u),i(u),s(u)];
end

