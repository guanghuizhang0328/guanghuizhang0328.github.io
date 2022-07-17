% % %Figure9_Spatial_CCs_P2_N2_four_methods.m
%%% Compute correlation coefficients of topographies between participants for
%%% increased trials and all remained trials for P2/N2.


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

ERPStart  =130;%% The lower interval of time-window for N2
ERPEnd = 190; %% The upper interval of time-window for N2
%%  setting parameters
timeStart = -200;%%The lower edge of one epoch
timeEnd = 900;%%The upper edge of one epoch
fs = 500; %% sampling rate
%%
%%
ERPSampointStart = round((ERPStart - timeStart)/(1000/fs)) + 1 ;
ERPSampointEnd = round((ERPEnd - timeStart)/(1000/fs)) + 1 ;


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
%%
[NumChans,NumSamps,NumSti,NumSubs,NumMethod] = size(X_GA);
tIndex = linspace(timeStart,timeEnd,NumSamps);
%%%%%%%%%%%%%%%%
%% MEASUREMENT METHOD:mean value/peak value

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%waveforms%%%%%%%%%%%%%%%%%%%%%%%%%%%
X_ST_av = squeeze(mean(X_ST(:,ERPSampointStart:ERPSampointEnd,:,:,:,:),2));%%Mean amplitude

X_GA_av = squeeze(mean(X_GA(:,ERPSampointStart:ERPSampointEnd,:,:,:),2));%%Mean amplitude


for Numofmethod = 1:NumMethod
    
    for Numofsti = 1:NumSti
        
        count1 = 0;
        for ii = 1:NumSubs-1
            for jj = ii+1:NumSubs
                count1 = count1 +1;
                RHO_mean_all(count1,Numofsti,Numofmethod)  = corr(squeeze(X_GA_av(:,Numofsti,ii,Numofmethod)),squeeze(X_GA_av(:,Numofsti,jj,Numofmethod)));
            end
        end
        
        %%Increased trials
        for Numoftrial = 1:length(Trial_num)
            count = 0;
            for i = 1:NumSubs-1
                for j = i+1:NumSubs
                    count = count +1;
                    RHO_mean_increased(count,Numofsti,Numoftrial,Numofmethod)  = corr(squeeze(X_ST_av(:,Numofsti,i,Numoftrial,Numofmethod)),squeeze(X_ST_av(:,Numofsti,j,Numoftrial,Numofmethod)));
                end
            end
        end
    end
end
[Count,NumSti,NumTrial,NumMethod] = size(RHO_mean_increased);
RHO_mean_increased = reshape(RHO_mean_increased,Count*NumSti,NumTrial,NumMethod);
X_mean1 = squeeze(mean(RHO_mean_increased,1));
X_std1 = squeeze(std(RHO_mean_increased,0,1))/sqrt(Count*NumSti);

RHO_mean_all = reshape(RHO_mean_all,Count*NumSti,NumMethod);
X_mean1(34,:) = squeeze(mean(RHO_mean_all,1));
X_std1(34,:) = squeeze(std(RHO_mean_all,0,1))/sqrt(Count*NumSti);



figure;
set(gcf,'outerposition',get(0,'screensize'));
subplot(2,1,1,'align');
hold on;
hold on;
set(gca,'fontsize',14);
B_set= bar(X_mean1);

B_set(4).FaceColor = 'b';
B_set(4).FaceAlpha = 0.3;
B_set(3).FaceColor = 'r';
B_set(3).FaceAlpha = 0.3;
B_set(2).FaceColor = 'k';
B_set(2).FaceAlpha = 0.3;
B_set(1).FaceColor = 'g';
B_set(1).FaceAlpha = 0.3;

ylabel(['Mannitude']);
xlabel(['Number of trials']);
title(['CCs of topographies between subjects for increased trials and all remained trials'])


xlim([0 35]);

ylim([0.1 0.4]);

legend({'Conventional time-domain analysis','Trial-averaged group PCA','Single-trial-based group PCA','Within-subject PCA'});
legend('boxoff');
set(gca,'xtick',[0:35]);

numgroups = size(X_mean1, 1);
numbars = size(X_mean1, 2);
groupwidth = min(0.8, numbars/(numbars+1.5));
count = 1;
xtick_labels{1} ='';
for ii = 10:42
    count = count+1;
    xtick_labels{count} = num2str(ii);
end
xtick_labels{count+1} ='All';
set(gca,'XTickLabel',xtick_labels);%%,'XTickLabelRotation',45


for i = 1:numbars
    % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
    X = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
    hErr= errorbar(X, X_mean1(:,i), X_std1(:,i), 'k', 'linestyle', 'none', 'lineWidth', 1);
    mult = 0.25;                               % twice as long
    b = hErr.Bar;
    drawnow;
    % hidden property/handle                               % populate b's properties
    vd = b.VertexData;
    N = numel(X);                           % number of error bars
    capLength = vd(1,2*N+2,1) - vd(1,1,1);  % assumes equal length on all
    newLength = capLength * mult;
    leftInds = N*2+1:2:N*6;
    rightInds = N*2+2:2:N*6;
    vd(1,leftInds,1) = [X-newLength, X-newLength];
    vd(1,rightInds,1) = [X+newLength, X+newLength];
    b.VertexData = vd;

end



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
ERPStart  =190;%% The lower interval of time-window for N2
ERPEnd = 310; %% The upper interval of time-window for N2
ERPSampointStart = round((ERPStart - timeStart)/(1000/fs)) + 1 ;
ERPSampointEnd = round((ERPEnd - timeStart)/(1000/fs)) + 1 ;


[NumChans,NumSamps,NumSti,NumSubs,NumMethod] = size(X_GA);

X_ST_av = squeeze(mean(X_ST(:,ERPSampointStart:ERPSampointEnd,:,:,:,:),2));%%Mean amplitude

X_GA_av = squeeze(mean(X_GA(:,ERPSampointStart:ERPSampointEnd,:,:,:),2));%%Mean amplitude

RHO_mean_all = [];
RHO_mean_increased  = [];
for Numofmethod = 1:NumMethod
    
    for Numofsti = 1:NumSti
        
        count1 = 0;
        for ii = 1:NumSubs-1
            for jj = ii+1:NumSubs
                count1 = count1 +1;
                RHO_mean_all(count1,Numofsti,Numofmethod)  = corr(squeeze(X_GA_av(:,Numofsti,ii,Numofmethod)),squeeze(X_GA_av(:,Numofsti,jj,Numofmethod)));
            end
        end
        
        %%Increased trials
        for Numoftrial = 1:length(Trial_num)
            count = 0;
            for i = 1:NumSubs-1
                for j = i+1:NumSubs
                    count = count +1;
                    RHO_mean_increased(count,Numofsti,Numoftrial,Numofmethod)  = corr(squeeze(X_ST_av(:,Numofsti,i,Numoftrial,Numofmethod)),squeeze(X_ST_av(:,Numofsti,j,Numoftrial,Numofmethod)));
                end
            end
        end
    end
end
[Count,NumSti,NumTrial,NumMethod] = size(RHO_mean_increased);
RHO_mean_increased = reshape(RHO_mean_increased,Count*NumSti,NumTrial,NumMethod);
X_mean = squeeze(mean(RHO_mean_increased,1));
X_std = squeeze(std(RHO_mean_increased,0,1))/sqrt(Count*NumSti);

RHO_mean_all = reshape(RHO_mean_all,Count*NumSti,NumMethod);
X_mean(34,:) = squeeze(mean(RHO_mean_all,1));
X_std(34,:) = squeeze(std(RHO_mean_all,0,1))/sqrt(Count*NumSti);


tIndex = [10:43];

hold on;
set(gcf,'outerposition',get(0,'screensize'));
subplot(2,1,2,'align');
hold on;
hold on;
set(gca,'fontsize',14);
B_set= bar(X_mean);

B_set(4).FaceColor = 'b';
B_set(4).FaceAlpha = 0.3;
B_set(3).FaceColor = 'r';
B_set(3).FaceAlpha = 0.3;
B_set(2).FaceColor = 'k';
B_set(2).FaceAlpha = 0.3;
B_set(1).FaceColor = 'g';
B_set(1).FaceAlpha = 0.3;

ylabel(['Mannitude']);
xlabel(['Number of trials']);
title(['CCs of topographies between subjects for increased trials and all remained trials'])

xlim([0 35]);

ylim([0.65 0.9]);

legend({'Conventional time-domain analysis','Trial-averaged group PCA','Single-trial-based group PCA','Within-subject PCA'});
legend('boxoff');
set(gca,'xtick',[0:35]);

numgroups = size(X_mean, 1);
numbars = size(X_mean, 2);
groupwidth = min(0.8, numbars/(numbars+1.5));
count = 1;
xtick_labels{1} ='';
for ii = 10:42
    count = count+1;
    xtick_labels{count} = num2str(ii);
end
xtick_labels{count+1} ='All';
set(gca,'XTickLabel',xtick_labels);%%,'XTickLabelRotation',45


for i = 1:numbars
    % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
    X = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
    hErr= errorbar(X, X_mean(:,i), X_std(:,i), 'k', 'linestyle', 'none', 'lineWidth', 1);
    mult = 0.25;                               % twice as long
    b = hErr.Bar;
    drawnow;
    % hidden property/handle                               % populate b's properties
    vd = b.VertexData;
    N = numel(X);                           % number of error bars
    capLength = vd(1,2*N+2,1) - vd(1,1,1);  % assumes equal length on all
    newLength = capLength * mult;
    leftInds = N*2+1:2:N*6;
    rightInds = N*2+2:2:N*6;
    vd(1,leftInds,1) = [X-newLength, X-newLength];
    vd(1,rightInds,1) = [X+newLength, X+newLength];
    b.VertexData = vd;
    
end
%%
toc