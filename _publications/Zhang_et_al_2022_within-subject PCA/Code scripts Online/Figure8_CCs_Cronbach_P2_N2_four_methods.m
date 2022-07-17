% % %Figure8_CCs_Cronbach_P2_N2_four_methods.m
%%% Compute correlation coefficients of waves between few trials (e.g., 10 trials) and all remained trials for
%%% Compute the consistency of waveforms between particiapnts  for a specific trials based on Cronbach Alpha.


%%%Uses the outputs from:m_Step_2_Extract_P2_N2_withinsubject_PCA_all_trials.m
%%%                      m_Step_3_Extract_P2_N2_withinsubject_PCA_increased_trials.m
%%%                      m_Step_4_P2_N2_trial_averaged_group_PCA_increased_trials.m
%%%                      m_Step_5_P2_N2_single_trial_based_group_PCA_increased_trials.m
%%%                      Figure2_P2_factors_TwoGroupPCA_all_remained_trials.m
%%%                      Figure3_N2_factors_TwoGroupPCA_all_remained_trials.m

%%% In order to run this code, please install EEGLAB toolboxes. It can be downloaded from http://sccn.ucsd.edu/eeglab/
%%% This code was written by GuangHui Zhang, July 2022, JYU
%%% Faculty of Information Technology, University of Jyväskylä
%%% Address: Seminaarinkatu 15,PO Box 35, FI-40014 University of Jyväskylä,Jyväskylä, FINLAND
%%% E-mails: zhang.guanghui@foxmail.com





clear
clc
close all
%%
tic


%%-----------------------------------------P2------------------------------------------------------
subName = [1:2 4,7:10,14:16,18:21,24:26];
load chanlocs;
%%
Trial_num = [10:42];
S_analysis_mean = [];
S_analysis_peak = [];


for Numofmethod = 1:4
    if Numofmethod ==4
        X_GA(:,:,:,:,4) = importdata('PCA_withinsubject_P2.mat');
    elseif Numofmethod ==1
        X_GA(:,:,:,:,1) = importdata('X_WF_all_trials_P2.mat');
    elseif Numofmethod ==2
        X_GA(:,:,:,:,2) = importdata('PCA_average_group_P2_R_40_K_4  15.mat');
    else
        X_GA(:,:,:,:,3) = importdata('PCA_single_trial_group_P2_R_40_K_7  10.mat');
    end
    
    for Numoftrial = 1:length(Trial_num)
        
        if Numofmethod ==1
            
            for Numofsub = 1:length(subName)
                PathName =  strcat('2_PCA for increased trials\P2\4_Within-subject PCA',filesep,num2str(subName(Numofsub)),filesep,'Trial_',num2str(Trial_num(Numoftrial)),filesep);
                D = [];
                a = dir(PathName);
                D = importdata([PathName a(end).name]);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                X_ST(:,:,:,Numofsub,Numoftrial,4) = squeeze(mean(D,4));
            end
            
        elseif Numofmethod ==2
            
            pn = strcat('1_wavelet_filter',filesep);
            for Numofsub = 1:length(subName)
                %% Download the data for each subject under different conditions and retain the the same trials.
                fn = char(strcat(num2str(subName(Numofsub)),'.mat'));
                D = [];
                D = importdata([pn,fn]);
                stiNum = length(fieldnames(D));
                fieldNames = fieldnames(D);
                for Numofsti = 1:stiNum
                    data = [];
                    data = getfield(D,fieldNames{Numofsti});
                    X_ST(:,:,Numofsti,Numofsub,Numoftrial,1) = squeeze(mean(data(:,:,[1:Trial_num(Numoftrial)]),3));
                end
            end
            
        elseif Numofmethod ==3
            PathName = strcat('2_PCA for increased trials\P2\2_Trial averaged group PCA',filesep,'Trial_',num2str(Trial_num(Numoftrial)),filesep);
            X = [];
            a = dir(PathName);
            X_ST(:,:,:,:,Numoftrial,2) = importdata([PathName a(end).name]);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        else
            PathName = strcat('2_PCA for increased trials\P2\3_Single trial based group PCA',filesep,'Trial_',num2str(Trial_num(Numoftrial)),filesep);
            D = [];
            a = dir(PathName);
            D= importdata([PathName a(end).name]);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            X_ST(:,:,:,:,Numoftrial,3) = D;
        end
        
        
    end
end
%%%%%%%%%%%%%%%%%%%%%%
timeStart = -200;

timeEnd = 900;
fs = 500;
%%
[NumChans,NumSamps,NumSti,NumSubs,NumMethod] = size(X_GA);
tIndex = linspace(timeStart,timeEnd,NumSamps);
ChansOfInterestNames = {'FC3','FCz','FC4','C3','Cz','C4'};
%%
ChansOfInterestNumbers = [];
count = 0;
for chanSelected = 1:length(ChansOfInterestNames)
    for chan = 1:NumChans
        code = strcmp(chanlocs(chan).labels,ChansOfInterestNames{chanSelected});
        if code == 1
            count =  count +1;
            ChansOfInterestNumbers(count) = chan;
        end
    end
end

%%%%%%%%%%%%%%%%
%% MEASUREMENT METHOD:mean value/peak value

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%waveforms%%%%%%%%%%%%%%%%%%%%%%%%%%%
X_ST_av = squeeze(mean(X_ST(ChansOfInterestNumbers,:,:,:,:,:),1));
X_ST_av1 = reshape(X_ST_av,NumSubs*NumSamps*NumSti,length(Trial_num),NumMethod);


X_GA_av = squeeze(mean(X_GA(ChansOfInterestNumbers,:,:,:,:),1));
X_GA_av1 = reshape(X_GA_av,NumSubs*NumSamps*NumSti,NumMethod);
for Numofmethod = 1:NumMethod
    for Numoftrial = 1:length(Trial_num)
        S(Numoftrial,Numofmethod) = corr(squeeze(X_GA_av1(:,Numofmethod)),squeeze(X_ST_av1(:,Numoftrial,Numofmethod)));
    end
end
figure;
subplot(2,2,1);
hold on;
set(gca,'fontsize',12,'FontWeight','bold');
hold on;
plot([10:42],S(:,1),'g','linewidth',1);
hold on;
plot([10:42],S(:,2),'k','linewidth',3);
hold on;
plot([10:42],S(:,3),'r','linewidth',1);
hold on;
plot([10:42],S(:,4),'b','linewidth',1);
hold on;
xlim([9 43]);
ylim([0.7 1]);
set(gca,'XTick',10:1:42,'XTickLabel',10:1:42);
hold on;
title(['P2:CCs of waves between few trials and all trials']);
hold on;
xlabel(['Trial Number']);
legend({'Conventional time-domain analysis','Trial-averaged group PCA','Single-trial-based group PCA','Within-subject PCA'});
legend('boxoff');

%%--------------------------Cronbach alpha---------------------------------

X_ST = permute(X_ST,[2 1 3 4 5 6]);
X_ST_av1 = X_ST(:,ChansOfInterestNumbers,:,:,:,:);
X_ST_av1 = reshape(X_ST_av1,NumSamps,length(ChansOfInterestNumbers)*NumSubs*NumSti,length(Trial_num),4);

for Numofmethod = 1:4
    for Numoftrial = 1:length(Trial_num)
        S(Numoftrial,Numofmethod) = cronbach(squeeze(X_ST_av1(:,:,Numoftrial,Numofmethod)));
    end
end

subplot(2,2,2);
hold on;
set(gca,'fontsize',12,'FontWeight','bold');
hold on;
plot([10:42],S(:,1),'g','linewidth',1);
hold on;
plot([10:42],S(:,2),'k','linewidth',3);
hold on;
plot([10:42],S(:,3),'r','linewidth',1);
hold on;
plot([10:42],S(:,4),'b','linewidth',1);
hold on;
xlim([9 43]);
ylim([0.95 1]);
set(gca,'XTick',10:1:42,'XTickLabel',10:1:42);
hold on;
title(['P2:Cronbach alpha for increased trials']);
hold on;
xlabel(['Number of trials']);
legend({'Conventional time-domain analysis','Trial-averaged group PCA','Single-trial-based group PCA','Within-subject PCA'});
legend('boxoff');


%%---------------------------------------N2---------------------------------------------------------------------

subName = [1:4,7:10,13,14:16,18:22,24:26];
%%
Trial_num = [10:42];
S_analysis_mean = [];
S_analysis_peak = [];
X_ST = [];
X_GA = [];
for Numofmethod = 1:4
    if Numofmethod ==4
        X_GA(:,:,:,:,4) = importdata('PCA_withinsubject_N2.mat');
    elseif Numofmethod ==1
        X_GA(:,:,:,:,1) = importdata('X_WF_all_trials_N2.mat');
    elseif Numofmethod ==2
        X_GA(:,:,:,:,2) = importdata('PCA_average_group_N2_R_40_K_2   5   9  26.mat');
    else
        X_GA(:,:,:,:,3) = importdata('PCA_single_trial_group_N2_R_40_K_3  10  12  16.mat');
    end
    
    for Numoftrial = 1:length(Trial_num)
        
        if Numofmethod ==1
            
            for Numofsub = 1:length(subName)
                PathName =  strcat('2_PCA for increased trials\N2\4_Within-subject PCA',filesep,num2str(subName(Numofsub)),filesep,'Trial_',num2str(Trial_num(Numoftrial)),filesep);
                D = [];
                a = dir(PathName);
                D = importdata([PathName a(end).name]);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                X_ST(:,:,:,Numofsub,Numoftrial,4) = squeeze(mean(D,4));
            end
            
        elseif Numofmethod ==2
            
            pn = strcat('1_wavelet_filter',filesep);
            for Numofsub = 1:length(subName)
                %% Download the data for each subject under different conditions and retain the the same trials.
                fn = char(strcat(num2str(subName(Numofsub)),'.mat'));
                D = [];
                D = importdata([pn,fn]);
                stiNum = length(fieldnames(D));
                fieldNames = fieldnames(D);
                for Numofsti = 1:stiNum
                    data = [];
                    data = getfield(D,fieldNames{Numofsti});
                    X_ST(:,:,Numofsti,Numofsub,Numoftrial,1) = squeeze(mean(data(:,:,[1:Trial_num(Numoftrial)]),3));
                end
            end
            
        elseif Numofmethod ==3
            PathName = strcat('2_PCA for increased trials\N2\2_Trial averaged group PCA',filesep,'Trial_',num2str(Trial_num(Numoftrial)),filesep);
            X = [];
            a = dir(PathName);
            X_ST(:,:,:,:,Numoftrial,2) = importdata([PathName a(end).name]);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        else
            PathName = strcat('2_PCA for increased trials\N2\3_Single trial based group PCA',filesep,'Trial_',num2str(Trial_num(Numoftrial)),filesep);
            D = [];
            a = dir(PathName);
            D= importdata([PathName a(end).name]);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            X_ST(:,:,:,:,Numoftrial,3) = D;
        end
        
        
    end
end
%%%%%%%%%%%%%%%%%%%%%%
timeStart = -200;

timeEnd = 900;
fs = 500;
%%
[NumChans,NumSamps,NumSti,NumSubs,NumMethod] = size(X_GA);
tIndex = linspace(timeStart,timeEnd,NumSamps);
ChansOfInterestNames = {'FC3','FCz','FC4','C3','Cz','C4'};
%%
ChansOfInterestNumbers = [];
count = 0;
for chanSelected = 1:length(ChansOfInterestNames)
    for chan = 1:NumChans
        code = strcmp(chanlocs(chan).labels,ChansOfInterestNames{chanSelected});
        if code == 1
            count =  count +1;
            ChansOfInterestNumbers(count) = chan;
        end
    end
end

%%%%%%%%%%%%%%%%
%% MEASUREMENT METHOD:mean value/peak value

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%waveforms%%%%%%%%%%%%%%%%%%%%%%%%%%%
X_ST_av = squeeze(mean(X_ST(ChansOfInterestNumbers,:,:,:,:,:),1));
X_ST_av1 = reshape(X_ST_av,NumSubs*NumSamps*NumSti,length(Trial_num),NumMethod);


X_GA_av = squeeze(mean(X_GA(ChansOfInterestNumbers,:,:,:,:),1));
X_GA_av1 = reshape(X_GA_av,NumSubs*NumSamps*NumSti,NumMethod);
for Numofmethod = 1:NumMethod
    for Numoftrial = 1:length(Trial_num)
        S(Numoftrial,Numofmethod) = corr(squeeze(X_GA_av1(:,Numofmethod)),squeeze(X_ST_av1(:,Numoftrial,Numofmethod)));
    end
end
% figure;
subplot(2,2,3);
hold on;
set(gca,'fontsize',12,'FontWeight','bold');
hold on;
plot([10:42],S(:,1),'g','linewidth',1);
hold on;
plot([10:42],S(:,2),'k','linewidth',3);
hold on;
plot([10:42],S(:,3),'r','linewidth',1);
hold on;
plot([10:42],S(:,4),'b','linewidth',1);
hold on;
xlim([9 43]);
ylim([0.85 1]);
set(gca,'XTick',10:1:42,'XTickLabel',10:1:42);
hold on;
title(['N2:CCs of waves between few trials and all trials']);
hold on;
xlabel(['Trial Number']);
legend({'Conventional time-domain analysis','Trial-averaged group PCA','Single-trial-based group PCA','Within-subject PCA'});
legend('boxoff');

%%--------------------------Cronbach alpha---------------------------------

X_ST = permute(X_ST,[2 1 3 4 5 6]);
X_ST_av1 = X_ST(:,ChansOfInterestNumbers,:,:,:,:);
X_ST_av1 = reshape(X_ST_av1,NumSamps,length(ChansOfInterestNumbers)*NumSubs*NumSti,length(Trial_num),4);

for Numofmethod = 1:4
    for Numoftrial = 1:length(Trial_num)
        S(Numoftrial,Numofmethod) = cronbach(squeeze(X_ST_av1(:,:,Numoftrial,Numofmethod)));
    end
end

subplot(2,2,4);
hold on;
set(gca,'fontsize',12,'FontWeight','bold');
hold on;
plot([10:42],S(:,1),'g','linewidth',1);
hold on;
plot([10:42],S(:,2),'k','linewidth',3);
hold on;
plot([10:42],S(:,3),'r','linewidth',1);
hold on;
plot([10:42],S(:,4),'b','linewidth',1);
hold on;
xlim([9 43]);
% ylim([0.995 0.999]);
set(gca,'XTick',10:1:42,'XTickLabel',10:1:42);
xtickangle(45); 
hold on;
title(['N2:Cronbach alpha for increased trials']);
hold on;
xlabel(['Number of trials']);
legend({'Conventional time-domain analysis','Trial-averaged group PCA','Single-trial-based group PCA','Within-subject PCA'});
legend('boxoff');
%%
toc