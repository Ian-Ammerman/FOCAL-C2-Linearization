function [NewTime,ssExcite,Aglobal,Bglobal,Cglobal,Dglobal]= SS_Fitting_Wave_Excitation(opt_file)
%% State Space fitting of the convolution integral
% This routine fits a state-space model for the convolution term of wave
% excitation forces on a floating body, based on the coefficients of WAMIT. 
% All the inputs should be define in the "opt_file". 
% Alan Wright February - April 2018
% To run the code please type in the comand window: 
% >> ss_fitting_Excite('SS_Fitting_Options.log')
% Please refer to the Theory and UserManual for more information.
%
% This routine was developed by:
% National Renewable Energy Lab
% 
% V1.00.01

%% Read option file
fid = fopen(opt_file);
if fid==-1
    disp(['The input file "' opt_file '" was not found.']);
    return
end
    
Excite = textscan(fid,'%s','delimiter','%','commentstyle','%','Headerlines',1);
fclose(fid);

% Assemble structures
fields = {'dof'}; %Global parameters

gp=cell2struct(Excite{1}(2),fields); 
gp.DoF=str2num(gp.dof);  %Vector with the DoF positions [1 0...](of 1 body) 

ULEN=1; %Reference length of the WAMIT files: Change if different. 

fields = {'FileName','WaveTMax','dT','Fit','ppmf','fmt','maxiter', 'WtrDen', 'Grav','WaveDir','OutFileName','tc','frac','order'}; %Local structure Excite
try
Excite=cell2struct(Excite{1}([1 3:15]),fields);
Excite.WaveTMax=str2num(Excite.WaveTMax);   %Fit required for the parametric model (max. recomended 0.97)
Excite.dT=str2num(Excite.dT);   %Time step in wave time series (s)
Excite.Fit=str2num(Excite.Fit);   %Fit required for the parametric model (max. recomended 0.97)
Excite.ppmf=str2num(Excite.ppmf); %Plot the parametric model fit. (TDI or FDI)
Excite.fmt=str2num(Excite.fmt);   %Reduction Method for Method=4
Excite.maxiter=str2num(Excite.maxiter);   %maximum number of iterations for the Automatic method
Excite.WtrDen=str2num(Excite.WtrDen);   %Water density
Excite.Grav=str2num(Excite.Grav);   %Reduction Method for Method=4
Excite.WaveDir=str2num(Excite.WaveDir);   %Reduction Method for Method=4
Excite.OutFileName=Excite.OutFileName;   %Reduction Method for Method=4
Excite.tc=Excite.tc; %Time offset
Excite.frac = str2num(Excite.frac); %threshold for IRF time shift
Excite.order = str2num(Excite.order); %order for manual reduction
catch
    disp('Error reading the input file. Please use the reference file and')
    disp('the "User and Theory Manual.')
    return
end


if (isempty(Excite.ppmf) || (Excite.ppmf~=0 && Excite.ppmf~=1) )
    
    disp('The plot flag must be 0 or 1')
    return
end

if (isempty(Excite.fmt) || (Excite.fmt~=0 && Excite.fmt~=1) )
    
    disp('The order reduction flag must be 0 or 1')
    return
end

%% Reads WAMIT .3 file
% Get the Wave Excitation Force Coefficients
% First work with some input parameters
DffrctDim = [];
WaveTMax=Excite.WaveTMax;

% HdroExctn: Complex frequency domain version of the impulse response function as
% function of frequency (col 1), wave direction (col 2), and force
% component or direction (col 3)
HdroExctn=[];

% HdroZeroWaveDirExctn: Version for wave direction equal to zero (Col 2 = 1 in HdroExctn)
HdroZeroWaveDirExctn=[];

% HdroZeroWaveDirExctnInterp: Interpolated (finer frequency mesh) version
% of HdroZeroWaveDirExctn
HdroZeroWaveDirExctnInterp=[];

% assorted arrays needed to read in and sort WAMIT data.
WAMITFreq=[];
WAMITPer=[];
WAMITWvDir=[];
SortFreqInd=[];
SortFreqInd(1)=0.;
SortWvDirInd=[];
HdroFreq = [];
OnePlusEps=1.00000001;
RhoXg = Excite.WtrDen*Excite.Grav;

DffrctDim(1) = RhoXg*ULEN^2;
DffrctDim(4) = RhoXg*ULEN^3;
DffrctDim(2) = DffrctDim(1);
DffrctDim(3) = DffrctDim(1);
DffrctDim(5) = DffrctDim(4);
DffrctDim(6) = DffrctDim(4);

% Stuff related to Tiago's algorithm:
HighFreq = 0.;
FirstPass = '.True.';
k=0;

%!!!! See if this is FAST dependent and/or needs to be included in input
DffrctDim = 10051.82*ones(6,1);

% Now all of this follows FAST version 7 programming that reads in Wamit
% (.1) data and forms the frequency response function.
   fid1 = fopen(strcat(Excite.FileName,'.1'));
   if fid1==-1
        disp(['The WAMIT file "' Excite.FileName '" was not found.'])
        disp(' The file name can contain relative or absolute path, and should not contain the extension ".1".')
        disp(' Ex.: "HydroData/Spar" or "C:/HydroData/Spar".' )
        return
   end
   OPT1 = textscan(fid1,'%f %n %n %f %f','commentstyle','W'); %read in wamit columns
   fclose(fid1); 

   ctr=OPT1{1}(1); % Check for 0 or inf frequency
   if ctr~=0 % 0 freq
       n=1; 
       while OPT1{1}(n)==OPT1{1}(n+1) 
           n=n+1; 
       end
   end
   
   if ctr==0 %Inf freq
       n=length(OPT1{1}); 
   end
   m=max(OPT1{3}); frm='%3.0f\t%2.6E\t ';

   N = length(OPT1{1});
   PrvPer = 0.;
   for ii = 0:N-1
     TmpPer = OPT1{1}(ii+1);
     if(strcmp(FirstPass,'.TRUE.'))||(TmpPer~=PrvPer)

         k=k+1;
         PrvPer = TmpPer;
         FirstPass   = '.FALSE.';

         WAMITPer(k) = TmpPer;
         if(TmpPer<0.)
            WAMITFreq(k)=0.;
            ZeroFreq = '.TRUE.';
         elseif(TmpPer==0.)
            WAMITFreq(k)=3.4E38;
            InfFreq = '.TRUE.';
         else
            WAMITFreq(k)=(2*pi)/TmpPer;
            HighFreq = max(HighFreq,WAMITFreq(k));
         end
         
         InsertInd = k;
         
         for i = 1:k-1
             if((WAMITFreq(i)>WAMITFreq(k)))
                 InsertInd = min(InsertInd,SortFreqInd(i));
                 SortFreqInd(i)=SortFreqInd(i) + 1;
             end
         end
     SortFreqInd(k)=InsertInd;
     end
   end
   
%-----------------------------------New stuff to get HydroFreq 2-8-18--------------------------

k = 0;
PrvPer = 0.;
FirstPass = '.True.';

   for ii = 0:N-1
     TmpPer = OPT1{1}(ii+1);
     if(strcmp(FirstPass,'.TRUE.'))||(TmpPer~=PrvPer)
         k=k+1;
         PrvPer = TmpPer;
         FirstPass = '.FALSE.';
   
   
            if (     TmpPer <  0.0 )                                        % Periods less than zero in WAMIT represent infinite period = zero frequency
               HdroFreq (SortFreqInd(k)) = 0.0;
            elseif ( TmpPer == 0.0 )                                     % Periods equal to  zero in WAMIT represent infinite frequency; a value slightly larger than HighFreq is returned to approximate infinity while still maintaining an effective interpolation later on.
               HdroFreq (SortFreqInd(k)) = HighFreq*OnePlusEps;              % Set the infinite frequency to a value slightly larger than HighFreq
            else                                                            % We must have positive, non-infinite frequency
               HdroFreq (SortFreqInd(k)) = (2*pi)/TmpPer;                     % Convert the period in seconds to a frequency in Excite/s and store them sorted from lowest to highest
            end

     end
   end
         
%-------------------------------------------------------------------------------------------------   
   fid3 = fopen(strcat(Excite.FileName,'.3'));
   if fid3==-1
        disp(['The WAMIT file "' Excite.FileName '" was not found.'])
        disp(' The file name can contain relative or absolute path, and should not contain the extension ".1".')
        disp(' Ex.: "HydroData/Spar" or "C:/HydroData/Spar".' )
        return
   end
  
   OPT3 = textscan(fid1,'%f %f %n %f %f %f %f','commentstyle','W');
  
     % First find the number of input incident wave propagation heading direction
      %   components inherent in the complex wave excitation force per unit wave
      %   amplitude vector:

   
   NInpWvDir = 0;        % Initialize to zero
   PrvDir    = 0.0;      % Initialize to a don't care
   FirstPass = '.TRUE.';   % Initialize to .TRUE. for the first pass  
 
   N3 = length(OPT3{1});
    
   for iii = 0:N3-1  % Loop through all rows in the file
  
       TmpPer = OPT3{1}(iii+1);
       TmpDir = OPT3{2}(iii+1);
    
       if(strcmp(FirstPass,'.TRUE.')) %! .TRUE. if we are on the first pass
          PrvPer=TmpPer;              %! Store the current period as the previous period for the next pass
       end
       
       if (TmpPer ~= PrvPer   )   % .TRUE.                                if the period    currently read in is different than the previous period    read in; thus we found a new period    in the WAMIT file, so stop reading in data
            break
       end

       if(strcmp(FirstPass,'.TRUE.'))||(TmpDir~=PrvDir)  % .TRUE. if we are on the first pass or if the direction currently read in is different than the previous direction read in; thus we found a new direction in the WAMIT file!
            NInpWvDir = NInpWvDir + 1;                   % Since we found a new direction, count it in the total
            PrvDir    = TmpDir ;                       % Store the current direction as the previous direction for the next pass
            FirstPass = '.FALSE.';                     % Sorry, you can only have one first pass
       end
   end
   
   
   k = 0;
   PrvPer = 0.0;
   PrvDir = 0.0;
   FirstPass = '.TRUE.';
  
  
   for iiii = 0:N3-1
      TmpPer = OPT3{1}(iiii+1);
      TmpDir = OPT3{2}(iiii+1);

      if(strcmp(FirstPass,'.TRUE.'))||(TmpPer~=PrvPer)   % .TRUE. if we are on the first pass or if the period    currently read in is different than the previous period    read in; thus we found a new period    in the WAMIT file!
 
            j         = 0;           % Reset the count of directions to zero
            k         = k + 1;       % This is current count of which frequency component we are on
            PrvPer    = TmpPer;      % Store the current period    as the previous period    for the next pass
            FirstFreq = FirstPass;   % Sorry, you can only loop through the first frequency once
            NewPer    = '.TRUE.';      % Reset the new period flag

            while ( WAMITPer(k) <= 0.0 )  % Periods less than or equal to zero in WAMIT represent infinite period = zero frequency and infinite frequency, respectively.  However, only the added mass is output by WAMIT at these limits.  The damping and wave excitation are left blank, so skip them!
               k = k + 1;
            end
            if ( TmpPer ~= WAMITPer(k) )  % Abort if the .3 and .1 files do not contain the same frequency components (not counting zero and infinity)
               
                    disp([' Other than zero and infinite frequencies, "']);
                    return             
            end

      end
     
    
      if(strcmp(FirstPass,'.TRUE.'))||(TmpDir~=PrvDir)||strcmp(NewPer,'.TRUE.')   % .TRUE. if we are on the first pass, or if this is new period, or if the direction currently read in is different than the previous direction read in; thus we found a new direction in the WAMIT file!
  
            j         = j + 1;    % This is current count of which direction component we are on
            PrvDir    = TmpDir;      % Store the current direction as the previous direction for the next pass
            FirstPass = '.FALSE.';     % Sorry, you can only have one first pass
            NewPer    = '.FALSE.';     % Disable the new period flag

            if(strcmp(FirstFreq,'.TRUE.'))  % .TRUE. while we are still looping through all directions for the first frequency component
               WAMITWvDir(j)   = TmpDir;    % Store the directions in the order they appear in the WAMIT file          
               InsertInd = j;
               for i=1:j-1                                                  % Loop through all previous directions
                     if ( ( WAMITWvDir(i) > WAMITWvDir(j) ) )               % .TRUE. if a previous direction component is higher than the current direction component
                        InsertInd       = min( InsertInd, SortWvDirInd(i) ); % Store the lowest sorted index whose associated direction component is higher than the current direction component
                        SortWvDirInd(i) = SortWvDirInd(i) + 1;               % Shift all of the sorted indices up by 1 whose associated direction component is higher than the current direction component
                     end
               end                                                          % I - All previous directions
            
               SortWvDirInd(j) = InsertInd;                                  %Store the index such that WAMITWvDir(SortWvDirInd(:)) is sorted from lowest to highest direction
            elseif ( TmpDir ~= WAMITWvDir(j) )                              % We must have looped through all directions at least once; so check to make sure all subsequent directions are consistent with the directions from the first frequency component, otherwise Abort
               disp([' Not every freq component..., "']);
               return             
            end
      end
   end
   
   
  % Now we can finally read in the frequency- and direction-dependent complex
  %   wave excitation force per unit wave amplitude vector:
   k                = 0;                                                     % Initialize to zero
   PrvPer           = 0.0;                                                   % Initialize to a don't care
   PrvDir           = 0.0;                                                   % Initialize to a don't care
   FirstPass        = '.TRUE.';                                              % Initialize to .TRUE. for the first pass
  
   HdroExctn = 0.0;                                                          % Initialize to zero

   for jj = 0:N3-1
       
      TmpPer    = OPT3{1}(jj+1);
      TmpDir    = OPT3{2}(jj+1);
      I         = OPT3{3}(jj+1);
      TmpData1  = OPT3{4}(jj+1);
      TmpData2  = OPT3{5}(jj+1);
      TmpRe     = OPT3{6}(jj+1);
      TmpIm     = OPT3{7}(jj+1);
   
      if(strcmp(FirstPass,'.TRUE.'))||(TmpPer~=PrvPer)

            j            = 0;                                                % Reset the count of directions to zero
            k            = k + 1;                                            % This is current count of which frequency component we are on
            PrvPer       = TmpPer;                                           % Store the current period    as the previous period    for the next pass
            FirstFreq    = FirstPass;                                        % Sorry, you can only loop through the first frequency once
            NewPer       = '.TRUE.';                                           % Reset the new period flag
      
          while ( WAMITPer(k) <= 0.0 )                                      % Periods less than or equal to zero in WAMIT represent infinite period = zero frequency and infinite frequency, respectively.  However, only the added mass is output by WAMIT at these limits.  The damping and wave excitation are left blank, so skip them!
               k = k + 1;
          end
      end
       
       if(strcmp(FirstPass,'.TRUE.'))||(TmpDir~=PrvDir)||strcmp(NewPer,'.TRUE.')
      
             j            = j + 1;                                           % This is current count of which direction component we are on
            PrvDir       = TmpDir;                                           % Store the current direction as the previous direction for the next pass
            FirstPass    = '.FALSE.';                                        % Sorry, you can only have one first pass
            NewPer       = '.FALSE.';                                        % Disable the new period flag
                  
            if ( FirstFreq )                                                % .TRUE. while we are still looping through all directions for the first frequency component
               HdroWvDir(SortWvDirInd(j)) = TmpDir;                          % Store the directions sorted from lowest to highest
            end

       
       end
       
       HdroExctn(SortFreqInd(k),SortWvDirInd(j),I) = complex( TmpRe, TmpIm )*DffrctDim(I);  % Redimensionalize the data and place it at the appropriate location within the array
   end
   
   
 % Interpolate to get the correct Kc for the input wave direction by interpolation:  

   Nlength = length(HdroExctn);
   for jjj = 1:Nlength
     for iii = 1:6
       KcDir(jjj,iii) = interp1(HdroWvDir,HdroExctn(jjj,:,iii),Excite.WaveDir,'linear','extrap');
     end
   end

  
   dT = Excite.dT;

% Determine the time-domain impulse response functions corresponding to
% each direction (1-6) of HdroZeroWaveDirExctn. First extract out these
% directions and then perform the MATLAB ifft function:

   Kc1 = HdroExctn(:,1,:);

   w = HdroFreq(1:length(HdroFreq)-1); 


%% Call the CausalIRF function to form a causal IRF from the original IRF through application of
% a time delay:
[NewTime,KtNew,ii,tc] = CausalIRF(gp,Excite,Kc1,w,dT);  

%% define dof vector that will be needed in the Fit_Statespace_Model routine:

ldof=length(gp.DoF); dof=zeros(1); ii=0;

for d=1:1:ldof
    if gp.DoF(d)==1, ii=ii+1;
       dof(ii)=d; %Vector with the number of each DoF: surge=1 heave=3 ...
    end
end


%% Now that we have a causal IRF, fit a state-space model to this:
[ssExcite] = Fit_StateSpace_Model(Excite,KtNew,NewTime,dT,dof,ii); %TD Realization Theory
%[ssExcite] = Fit_StateSpace_Model_prony(Excite,KtNew,Newtime,dT,dof,ii); %TD Realization Theory

% Assemble global A, B, and C matrices: Next several lines set up what's
% necessary to do this.
%ssExcite(6).A = 0*eye(2);
%ssExcite(6).B = [0;0];
%ssExcite(6).C = [0 0];

np = size(ssExcite);
lp=0;
    for iii = 1:np(2)
        lp= lp+ length(ssExcite(iii).A);
    end
    

    
Aglobal = zeros(lp,lp);
Bglobal = zeros(lp,1);
Cglobal = zeros(6,lp);
Dglobal = zeros(6,1);

mp=[];
    for iii = 1:np(2)+1
        if(iii == 1) 
            mp(iii)=0;
        else
            mp(iii)= mp(iii-1)+length(ssExcite(iii-1).A);
        end
    end
% Assemble global A, B, and C matrices (D assumed 0 matrix).    
    for iii = 1:np(2)
        Aglobal(mp(iii)+1:mp(iii+1),mp(iii)+1:mp(iii+1))=ssExcite(iii).A;
        Bglobal(mp(iii)+1:mp(iii+1),1)=ssExcite(iii).B;
        Cglobal(iii,mp(iii)+1:mp(iii+1))=ssExcite(iii).C;
    end
   

% % Perform final system order reduction
% fullsys = ss(Aglobal,Bglobal,Cglobal,Dglobal);
% 
% t = [0:0.05:60];
% u = zeros(length(t),7); %[0,0,0,0,0,0,0];
% u(:,1) = [4*sin(2*t)+2*sin(2.5*t)+0.5*sin(3.7*t)]';
% IC1 = zeros(1,size(Aglobal,1));
% 
% order = 1;
% Kplottime = [0:1:length(Kt)-1]'*dT;
% Rfit = 0;
% while Rfit < Excite.Fit || order <= size(AM,1)
%     R = reducespec(fullsys,"balanced");
%     R.Options.FreqIntervals = [0,6.28];
% 
%     [rsys,~] = getrom(R,Order=[n],Method="truncate");
% 
%     [An,Bn,Cn,Dn] = ssdata(rsys);
%     [Y(:,1),T]=impulse(ss(An,Bn,Cn,Dn,0),Kplottime); 
% 
%     res=KtSmooth(:,dof(s))-Y;                     %Residuals
%     avrg=mean(KtSmooth(:,dof(s)));             %Sum of squares about the mean
%     sst=sum(((KtSmooth(:,dof(s))-avrg).*conj(KtSmooth(:,dof(s))-avrg)));  %Weighted average value
%     Rfit=1-sum(res.^2)/sst %Sum of squares about the mean
% end


% Write information to a file that can be read in by the HydroDyn driver code
% for comparing state-space wave load calculations to those using
% HydroDyn's inverse FFT method of wave force calculation. This is the
% .ssexctn file read by HydroDyn.
WaveHeadingAngle = Excite.WaveDir;
TimeOffset = tc;
ExcitationStates=length(Aglobal);
ExcitationStatesperDOF=[ ];
ExcitationStatesperDOF=[length(ssExcite(1).A),length(ssExcite(2).A),length(ssExcite(3).A),length(ssExcite(4).A),length(ssExcite(5).A),length(ssExcite(6).A)];


fid=fopen(strcat(Excite.OutFileName, '.ssexctn'),'w+');

fprintf(fid,'%s\r\n',['SS_Excitation_Fitting v1.00.01: State-Spaces Matrices']);
fprintf(fid,'%s\r\n',[num2str(WaveHeadingAngle) '    %Wave heading angle']);
fprintf(fid,'%s\r\n',[num2str(TimeOffset) '          %time offset (tc)']);
fprintf(fid,'%s\r\n',[num2str(ExcitationStates) '    %total # of states']);
fprintf(fid,'%s\r\n',[num2str(ExcitationStatesperDOF) '   %# states per degree of freedom']);

formata='%6.6e '; %Format of AA
for ii=1:size(Aglobal,2)-1
    formata=[formata '%6.6e '];
end
formata=[formata '\r\n']; 
fprintf(fid,formata,Aglobal');

formatb=['%6.6e ','\r\n'];%Format of BB
for ii=1:size(Bglobal,1)-1
    formatb=[formatb ;  ['%6.6e ','\r\n']];
end
fprintf(fid,'%6.6e\n ',Bglobal);

formatc='%6.6e ';%Format of CC
for ii=1:size(Cglobal,1)
    for iii=1:size(Cglobal,2)-1
        formatc=[formatc '%6.6e '];
    end
    formatc=[formatc ,'\n'];
    fprintf(fid,formatc,Cglobal(ii,:)');    
end

fclose(fid);

