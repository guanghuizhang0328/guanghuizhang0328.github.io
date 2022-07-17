% % %Figure10_11_Statistical_P2_N2_4methods_increased_trials
%%% Compute the statistical analysis results based on two-way ANOVA for
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


%%% When using this code, please cite the following articles:
%%% 1. Fengyu Cong, Yixiang Huang, Igor Kalyakin, Hong Li, Tiina Huttunen-Scott, Heikki Lyytinen, Tapani Ristaniemi,
%%% Frequency Response based Wavelet Decomposition to Extract Children's Mismatch Negativity Elicited by Uninterrupted Sound,
%%% Journal of Medical and Biological Engineering, 2012, 32(3): 205-214, DOI: 10.5405/jmbe.908
%%% 2. Guanghui Zhang, Xueyan Li, and Fengyu Cong. Objective Extraction of Evoked Event-related Oscillation from Time-frequency Representation of Event-related Potentials.
%%% Neural Plasticity. DOI:10.1155/2020/8841354
%%% 3. Lu, Y., Luo, Y., Lei, Y., Jaquess, K. J., Zhou, C., & Li, H. (2016). Decomposing valence intensity effects in disgusting and fearful stimuli: an event-related potential study.
%%% Social neuroscience, 11(6), 618-626. doi:https://doi.org/10.1080/17470919.2015.1120238









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

ERPStart  =130;%% The lower interval of time-window for P2
ERPEnd = 190; %% The upper interval of time-window for P2
ChansOfInterestNames = {'FC3','FCz','FC4','C3','Cz','C4'};%% Names of electrodes of interest
%%  setting parameters
timeStart = -200;%%The lower edge of one epoch
timeEnd = 900;%%The upper edge of one epoch
fs = 500; %% sampling rate
%%
%%
ERPSampointStart = round((ERPStart - timeStart)/(1000/fs)) + 1 ;
ERPSampointEnd = round((ERPEnd - timeStart)/(1000/fs)) + 1 ;


%%%%%%%%%%%%%%%%determining the orders of the electrodes of interest based on the names of eletrodes tha t are given
ChansOfInterestNumbers = [];
count = 0;
for chanSelected = 1:length(ChansOfInterestNames)
    for chan = 1:length(chanlocs)
        code = strcmp(chanlocs(chan).labels,ChansOfInterestNames{chanSelected});
        if code == 1
            count =  count +1;
            ChansOfInterestNumbers(count) = chan;
        end
    end
end

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
X_ST_av_topo = squeeze(mean(X_ST_av(ChansOfInterestNumbers,:,:,:,:),1));%%Mean amplitude

X_GA_av = squeeze(mean(X_GA(:,ERPSampointStart:ERPSampointEnd,:,:,:),2));%%Mean amplitude for all remained trials
X_GA_av_topo = squeeze(mean(X_GA_av(ChansOfInterestNumbers,:,:,:),1));%%Mean amplitude

S_analysis_mean = [];
for Numofmethod = 1:NumMethod
    %%Increased trials
    for Numoftrial = 1:length(Trial_num)
        topo_box_mean = squeeze(X_ST_av_topo(:,:,Numoftrial,Numofmethod))';
        [trialNum,stiNum]= size(topo_box_mean);
        Y = [];
        Y = reshape(topo_box_mean,[],1);
        stiOne =3;
        stiTwo = 2;
        stiNum = stiOne*stiTwo;
        BTFacs =[];
        WInFacs = [];
        count = 0;
        for is = 1:stiOne
            IdexStart = trialNum*(is-1)*stiTwo+1;
            IdexEnd =  is*trialNum*stiTwo;
            WInFacs(IdexStart:IdexEnd,1) = is;
            for iss  = 1:stiTwo
                count  = count +1;
                IdexStart = trialNum*(count-1)+1;
                IdexEnd =  trialNum*count;
                WInFacs(IdexStart:IdexEnd,2) = iss;
            end
        end
        
        S = [];
        for iss = 1:stiNum
            IdexStart = trialNum*(iss-1)+1;
            IdexEnd =  iss*trialNum;
            S(IdexStart:IdexEnd,1) =1:trialNum ;
        end
        factorNames = {'Valence','Negative-category '};
        D1 = reshape(Y,1 ,[]);
        sta = f_rm_anova2(D1,WInFacs,S,factorNames);
        
        S_analysis_mean(1,Numoftrial,Numofmethod)= sta{3,6};
        S_analysis_mean(2,Numoftrial,Numofmethod)= sta{9,6};
        S_analysis_mean(3,Numoftrial,Numofmethod)= sta{15,6};
        S_analysis_mean(4,Numoftrial,Numofmethod)= sta{3,7};
        S_analysis_mean(5,Numoftrial,Numofmethod)= sta{9,7};
        S_analysis_mean(6,Numoftrial,Numofmethod)= sta{15,7};
        
    end
end


S_analysis_mean_All = [];
for Numofmethod = 1:NumMethod
    %%Increased trials
    topo_box_mean = squeeze(X_GA_av_topo(:,:,Numofmethod))';
    [trialNum,stiNum]= size(topo_box_mean);
    Y = [];
    Y = reshape(topo_box_mean,[],1);
    stiOne =3;
    stiTwo = 2;
    stiNum = stiOne*stiTwo;
    BTFacs =[];
    WInFacs = [];
    count = 0;
    for is = 1:stiOne
        IdexStart = trialNum*(is-1)*stiTwo+1;
        IdexEnd =  is*trialNum*stiTwo;
        WInFacs(IdexStart:IdexEnd,1) = is;
        for iss  = 1:stiTwo
            count  = count +1;
            IdexStart = trialNum*(count-1)+1;
            IdexEnd =  trialNum*count;
            WInFacs(IdexStart:IdexEnd,2) = iss;
        end
    end
    
    S = [];
    for iss = 1:stiNum
        IdexStart = trialNum*(iss-1)+1;
        IdexEnd =  iss*trialNum;
        S(IdexStart:IdexEnd,1) =1:trialNum ;
    end
    factorNames = {'Valence','Negative-category '};
    D1 = reshape(Y,1 ,[]);
    sta = f_rm_anova2(D1,WInFacs,S,factorNames);
    
    S_analysis_mean_All(1,Numofmethod)= sta{3,6};
    S_analysis_mean_All(2,Numofmethod)= sta{9,6};
    S_analysis_mean_All(3,Numofmethod)= sta{15,6};
    S_analysis_mean_All(4,Numofmethod)= sta{3,7};
    S_analysis_mean_All(5,Numofmethod)= sta{9,7};
    S_analysis_mean_All(6,Numofmethod)= sta{15,7};
    
    
end

MethodName = {'P2:Statistical results for Conventional time-domain analysis','Trial-averaged group PCA','Single-trial-based group PCA','Within-subject PCA'};
RowNum = 2;
ColumnNum = 2;
tIndex = [10:42];
figure;
set(gcf,'outerposition',get(0,'screensize'));
for Numofmethod =1:4
    X_ALL = squeeze(S_analysis_mean(:,:,Numofmethod));
    X_all_mean = squeeze(S_analysis_mean_All(:,Numofmethod));
    subplot(RowNum,ColumnNum,Numofmethod,'align');
    hold on;
    set(gca,'fontsize',10);
    hold on;
    plot(tIndex,X_ALL(4,:),'k','linewidth',1);
    hold on;
    plot(tIndex,X_ALL(5,:),'b','linewidth',1) ;
    hold on;
    plot(tIndex,X_ALL(6,:),'r','linewidth',1);
    hold on;
    ylim([-0.1 1.05]);
    plot(tIndex,0.05*ones(length(X_ALL(6,:)),1),'g','linewidth',1);
    hold on;
    plot(43, X_all_mean(4,1),'ks','linewidth',2);
    hold on;
    plot(43, X_all_mean(5,1),'b*','linewidth',2);
    hold on;
    plot(43, X_all_mean(6,1),'r+','linewidth',2);
    hold on;
    
    xlim([9 44]);
    set(gca,'xtick',[9:44]);
    count = 1;
    xtick_labels{1} ='';
    for ii = 10:42
        count = count+1;
        xtick_labels{count} = num2str(ii);
    end
    xtick_labels{count+1} ='All';
    set(gca,'XTickLabel',xtick_labels);%%,'XTickLabelRotation',45
    xlabel('Number of trials')
    ylabel('p value');
    tN = strcat( MethodName{Numofmethod});
    legend({'V','NC','V*NC','p=0.05'});
    legend('boxoff');
    title(tN,'fontsize',10);
    
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
X_ST_av_topo = squeeze(mean(X_ST_av(ChansOfInterestNumbers,:,:,:,:),1));%%Mean amplitude

X_GA_av = squeeze(mean(X_GA(:,ERPSampointStart:ERPSampointEnd,:,:,:),2));%%Mean amplitude for all remained trials
X_GA_av_topo = squeeze(mean(X_GA_av(ChansOfInterestNumbers,:,:,:),1));%%Mean amplitude

S_analysis_mean = [];
for Numofmethod = 1:NumMethod
    %%Increased trials
    for Numoftrial = 1:length(Trial_num)
        topo_box_mean = squeeze(X_ST_av_topo(:,:,Numoftrial,Numofmethod))';
        [trialNum,stiNum]= size(topo_box_mean);
        Y = [];
        Y = reshape(topo_box_mean,[],1);
        stiOne =3;
        stiTwo = 2;
        stiNum = stiOne*stiTwo;
        BTFacs =[];
        WInFacs = [];
        count = 0;
        for is = 1:stiOne
            IdexStart = trialNum*(is-1)*stiTwo+1;
            IdexEnd =  is*trialNum*stiTwo;
            WInFacs(IdexStart:IdexEnd,1) = is;
            for iss  = 1:stiTwo
                count  = count +1;
                IdexStart = trialNum*(count-1)+1;
                IdexEnd =  trialNum*count;
                WInFacs(IdexStart:IdexEnd,2) = iss;
            end
        end
        
        S = [];
        for iss = 1:stiNum
            IdexStart = trialNum*(iss-1)+1;
            IdexEnd =  iss*trialNum;
            S(IdexStart:IdexEnd,1) =1:trialNum ;
        end
        factorNames = {'Valence','Negative-category '};
        D1 = reshape(Y,1 ,[]);
        sta = f_rm_anova2(D1,WInFacs,S,factorNames);
        
        S_analysis_mean(1,Numoftrial,Numofmethod)= sta{3,6};
        S_analysis_mean(2,Numoftrial,Numofmethod)= sta{9,6};
        S_analysis_mean(3,Numoftrial,Numofmethod)= sta{15,6};
        S_analysis_mean(4,Numoftrial,Numofmethod)= sta{3,7};
        S_analysis_mean(5,Numoftrial,Numofmethod)= sta{9,7};
        S_analysis_mean(6,Numoftrial,Numofmethod)= sta{15,7};
        
    end
end


S_analysis_mean_All = [];
for Numofmethod = 1:NumMethod
    %%Increased trials
    topo_box_mean = squeeze(X_GA_av_topo(:,:,Numofmethod))';
    [trialNum,stiNum]= size(topo_box_mean);
    Y = [];
    Y = reshape(topo_box_mean,[],1);
    stiOne =3;
    stiTwo = 2;
    stiNum = stiOne*stiTwo;
    BTFacs =[];
    WInFacs = [];
    count = 0;
    for is = 1:stiOne
        IdexStart = trialNum*(is-1)*stiTwo+1;
        IdexEnd =  is*trialNum*stiTwo;
        WInFacs(IdexStart:IdexEnd,1) = is;
        for iss  = 1:stiTwo
            count  = count +1;
            IdexStart = trialNum*(count-1)+1;
            IdexEnd =  trialNum*count;
            WInFacs(IdexStart:IdexEnd,2) = iss;
        end
    end
    
    S = [];
    for iss = 1:stiNum
        IdexStart = trialNum*(iss-1)+1;
        IdexEnd =  iss*trialNum;
        S(IdexStart:IdexEnd,1) =1:trialNum ;
    end
    factorNames = {'Valence','Negative-category '};
    D1 = reshape(Y,1 ,[]);
    sta = f_rm_anova2(D1,WInFacs,S,factorNames);
    
    S_analysis_mean_All(1,Numofmethod)= sta{3,6};
    S_analysis_mean_All(2,Numofmethod)= sta{9,6};
    S_analysis_mean_All(3,Numofmethod)= sta{15,6};
    S_analysis_mean_All(4,Numofmethod)= sta{3,7};
    S_analysis_mean_All(5,Numofmethod)= sta{9,7};
    S_analysis_mean_All(6,Numofmethod)= sta{15,7};
    
    
end

MethodName = {'N2:Statistical results for Conventional time-domain analysis','Trial-averaged group PCA','Single-trial-based group PCA','Within-subject PCA'};
RowNum = 2;
ColumnNum = 2;
tIndex = [10:42];
figure;
set(gcf,'outerposition',get(0,'screensize'));
for Numofmethod =1:4
    X_ALL = squeeze(S_analysis_mean(:,:,Numofmethod));
    X_all_mean = squeeze(S_analysis_mean_All(:,Numofmethod));
    subplot(RowNum,ColumnNum,Numofmethod,'align');
    hold on;
    set(gca,'fontsize',10);
    hold on;
    plot(tIndex,X_ALL(4,:),'k','linewidth',1);
    hold on;
    plot(tIndex,X_ALL(5,:),'b','linewidth',1) ;
    hold on;
    plot(tIndex,X_ALL(6,:),'r','linewidth',1);
    hold on;
    ylim([-0.1 1.05]);
    plot(tIndex,0.05*ones(length(X_ALL(6,:)),1),'g','linewidth',1);
    hold on;
    plot(43, X_all_mean(4,1),'ks','linewidth',2);
    hold on;
    plot(43, X_all_mean(5,1),'b*','linewidth',2);
    hold on;
    plot(43, X_all_mean(6,1),'r+','linewidth',2);
    hold on;
    
    xlim([9 44]);
    set(gca,'xtick',[9:44]);
    count = 1;
    xtick_labels{1} ='';
    for ii = 10:42
        count = count+1;
        xtick_labels{count} = num2str(ii);
    end
    xtick_labels{count+1} ='All';
    set(gca,'XTickLabel',xtick_labels);%%,'XTickLabelRotation',45
    xlabel('Number of trials')
    ylabel('p value');
    tN = strcat( MethodName{Numofmethod});
    legend({'V','NC','V*NC','p=0.05'});
    legend('boxoff');
    title(tN,'fontsize',10);
end
%%
toc