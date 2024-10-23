%% Univariate Bayesian Markov-Switching Model
%% Looking at the case of Greece from 1995 until 2023
% Danilo Leiva-Leon (03-2018)

%% Housekeeping
clc
clear 
close all
addpath('functions'); %this line adds functions to take lags etc
seed=12345;  rng(seed);   % fix the seed if desired

%% Select number of draws
M  = 2000;       %NUMBER OF DRAWS TO KEEP
M0 = 1000;      %NUMBER OF DRAWS TO LEAVE OUT
capn = M0 + M;  %TOTAL NUMBER OF DRAWS

%% Load the data
data =xlsread('gdp_greece.xls',1);        % This loads the macro. variables
y=100*(log(data(2:end,1))-log(data(1:end-1,1)));

time=1995+1/4:1/4:2023+3/4;

%nber=data(2:end,2); % load data on the NBER recessions for comparison purposes only
T=size(y,1);  %Sample size

%% Set the priors
T0_M = [0;1];   % for MU0, MU1
R0_M=eye(2);     

T0=0;   % for sigma_2
D0=0;   

U_01=2;  U_00=8;    %for p and q
U_10=1;  U_11=9;    

%% Set initial values
MU0TT=0; 
MU1TT=1;

SIG2TT = 1;

PTT=0.8;
QTT=0.7;

%% Start the Gibss sampler
for itr=1:capn
    clc;
    itr
    
% Step 1: Draw the state variable
[STT]=GEN_ST(y,PTT,QTT,MU0TT,MU1TT,SIG2TT);
  
% Setp 2: Draw the state-dependent means
[MU0TT,MU1TT]=GEN_MU(y,SIG2TT,STT,R0_M,T0_M);
   
% 4) Draw the error variance
[SIG2TT]=GEN_SIGMA(y,MU0TT,MU1TT,STT,T0,D0);

% Step 3: Draw the transition probabilities
    tranmat=switchg(STT+1,[1;2]);   %Number of transitions between states
    PTT=betarnd(U_11 + tranmat(2,2),U_10 + tranmat(2,1));
    QTT=betarnd(U_00 + tranmat(1,1),U_01 + tranmat(1,2));
    
% Collect generated draws
    if itr>M0
        MU0MM(:,itr-M0)=MU0TT;
        MU1MM(:,itr-M0)=MU1TT;
        
        SIG2MM(:,itr-M0)=SIG2TT;
        
        PMM(:,itr-M0)=PTT;
        QMM(:,itr-M0)=QTT;
        
        SSMM(:,itr-M0)=STT;    
    end
end

%% Set Figures

% Plot recession probabilities

prob_rec=1-mean(SSMM,2);
%time=1995+1/4:1/4:2017+3/4;

figure (1)
plot(time,prob_rec,'-k','LineWidth',2)
hold on
%plot(time,nber,'--r','LineWidth',0.5)
xlim([time(1) time(end)])
title('Probability of Recessions in Greece');

%saveas(gcf,'probabilities','png');

% Plot marginal posterior distributions
figure(2)
subplot(2,3,1);
hist(MU0MM,50);
axis tight
title('\mu_{0}');

subplot(2,3,2);
hist(MU1MM,50);
axis tight
title('\mu_{1}');

subplot(2,3,3);
hist(SIG2MM,50);
axis tight
title('\sigma^{2}');

subplot(2,3,4);
hist(PMM,50);
axis tight
title('p_{11}');

subplot(2,3,5);
hist(QMM,50);
axis tight
title('p_{00}');

%saveas(gcf,'histograms','png');

