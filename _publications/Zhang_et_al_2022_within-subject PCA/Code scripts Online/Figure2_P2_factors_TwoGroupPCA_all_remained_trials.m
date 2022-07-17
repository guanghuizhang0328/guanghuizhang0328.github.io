% % %Figure2_P2_factors_TwoGroupPCA_all_remained_trials
%%% To plot the temporal and spatial factors related to P2 for two group
%%% PCA (trial-averaged group PCA vs. single-trial-based group PCA) for all remained trials

%%Uses the outputs from:m_Step_1_Filter_data_by_wavelet_filter.m



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

%%-------------------------------------Basic Settings----------------------
%Location of the main study directory
%This method of specifying the study directory only works if you run the script;
%for running individual lines of code, replace the study directory with the path on your computer, e.g.: DIR = \Users\Lu_Emotional_ERP_Experiment
Subject_file_Path = fileparts(fileparts(mfilename('fullpath')));


%Location of the folder that contains this script and any associated processing files
%This method of specifying the current file path only works if you run the script;
%For running individual lines of code, replace the current file path with the path on your computer, e.g.: DIR = \Users\Lu_Emotional_ERP_Experiment\Codes_for_EEG_ERP_Processing
Current_File_Path = fileparts(mfilename('fullpath'));

%List of subjects to process, based on the name of the folder that contains that subject's data
Subject_Name = [1:2,4,7:10,14:16,18:21,24:26];%%Orders for all participants that used to extract P2.
% List of stimulus for each subject to process separately, based on the name of the sub-folder that contains that subject's data
Stimulus_Name = {'MD','MF','ED','EF','ND','NF'};%%Names for stimuli

timeStart = -200;%%Left interval for each trial
timeEnd = 900;%%Right interval for each trial
fs = 500;%%Sampling rate
load chanlocs;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%-----------------------------trial-averaged group PCA------------------%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for Numofsub =1:length(Subject_Name)%%Loop for participants
    fn = char(strcat('1_wavelet_filter',filesep,num2str(Subject_Name(Numofsub)),'.mat'));%%Filename
    D = [];
    D = importdata(fn);%%Load data
    
    stiNum = length(fieldnames(D));
    fieldNames = fieldnames(D);
    for Numofsti = 1:stiNum
        data = [];
        data = getfield(D,fieldNames{Numofsti});
        X(:,:,Numofsti,Numofsub)  = squeeze(mean(data,3));
    end
end
save('X_WF_all_trials_P2.mat','X','-v7.3');
[NumChans,NumSamps,Numsti,NumSubs] = size(X);
group_Index = ones(NumSubs,1);
NumGroups = max(group_Index);

X = permute(X,[2 1 3 4]);
%% Arranging fourth-order tensor into a matrix
X= reshape(X,NumSamps,NumChans*Numsti*NumSubs);
timeIndex = linspace(timeStart,timeEnd,NumSamps);

%%  PCA
[coef,score,lambda] = pca(X');
ratio = f_explainedVariance(lambda);

threshold = [99 95 90];
for is = 1:length(threshold)
    [va idx] = find(ratio<threshold(is));
    thresholdcomponetsNum(is) = length(idx)+1;
end
%%
for is = 1:length(lambda)
    ratio_sigle(is) = 100*lambda(is)./sum(lambda);
end

%%
R = 40;%%Number of sources

ratio_sigle_keep = ratio_sigle(1:R);
%% rotation
V = coef(:,1:R);
Z = score(:,1:R);
%% rotation for blind source separation
[translated_V,W] = rotatefactors(V, 'Method','promax','power',3,'Maxit',500);
B = inv(W');
Y = Z*W; %%% spatial components
T = V*B;  %%% temporal components

[peakValue,peakTime] = max(abs(T));
timePstart = ceil((0-timeStart)/(1000/fs))+1;
for r = 1 :R
    temp = T(:,r);
    T (:,r) =  temp - mean(temp(1:timePstart));
    peak_T(r) = round((peakTime(r)-1)*(1000/fs)) + timeStart;
end
%%
topo = reshape(Y',R,NumChans,Numsti,NumSubs);
topo_similarity_AV =[];

group_Index = ones(NumSubs,1);
for Numofgroup = 1:1
    Index = find(group_Index==Numofgroup);
    for Numofsti =1:Numsti
        temp= [];
        temp = squeeze(topo(:,:,Numofsti,Index));
        topo_av(:,:,Numofsti,Numofgroup) =  squeeze(mean(temp,3));
        for k = 1:R
            temp1 = corr(squeeze(topo(k,:,Numofsti,Index)));
            topo_similarity{:,:,k,Numofsti,Numofgroup} = temp1;
            RHO(k,Numofsti,Numofgroup) = mean(temp1(:));
        end
    end
end



Selected_k = [4 15];%%Orders for the indetified factors for P2%

%%----------------------------Back-projection and save the reconstructed data as '.mat'--------------------------------------
E = T(:,Selected_k)*Y(:,Selected_k)';%%Back-projection
temp = reshape(E,NumSamps,NumChans,Numsti,NumSubs);
D = permute(temp,[2 1 3 4]);
fileNameNew = ['PCA_average_group_P2_R_',num2str(R),'_K_',num2str(Selected_k)];
save(fileNameNew,'D','-v7.3');

%%---------------------Display the correlation results---------------------
Rho = roundn(corr(Y(:,4),Y(:,15)),-2);
fprintf( [repmat('_',1,70) '\n']);
fprintf(['P2:Correlations between factors for trial-averaged group PCA.\n']);
fprintf( [repmat('_',1,70) '\n']);
fprintf(['Correlation between factor 4 and factor 15 is',32,num2str(Rho), '.\n']);
fprintf( [repmat('_',1,70) '\n\n\n\n\n\n\n\n']);
%%-------------------------------------------------------------------

%%-------------------------Plot temporal and spatial features for the selected factors----------------------------
rowNum = 4;
columnNum = 13;

figure;
set(gcf,'outerposition',get(0,'screensize'))
subplot(rowNum,columnNum,[1:6 14:19],'align')
set(gca,'fontsize',12);
hold on;
plot(timeIndex,T(:,Selected_k),'linewidth',3)
xlim([timeStart timeEnd])
xlabel('Time/ms');
ylabel('Magnitude');
set(gca,'ydir','reverse');
title('Factors for P2 for trial-averaged group PCA'); 
for Numoffactor = 1:numel(Selected_k)
  LegendName{Numoffactor} = char(strcat('Factor',32,num2str(Selected_k(Numoffactor)),'- Explained:',num2str(roundn(ratio_sigle_keep(Selected_k(Numoffactor)),-2)),'%-Latency:',num2str(peak_T(Selected_k(Numoffactor))),'ms'));  
end
legend(LegendName,'location','best');
legend('boxoff');
%%%---------------------------Plot spatial factors-------------------------
for kk = 1:length(Selected_k)
    topo_k = squeeze(topo_av(Selected_k,:,:,:));
    mV = max(abs(topo_k(:)));
    count = (kk+1)*columnNum;

    for Numofsti = 1:Numsti
        count = count +1;
        subplot(rowNum,columnNum,count,'align')
        set(gca,'fontsize',14)
        topoplot(squeeze(topo_av(Selected_k(kk),:,Numofsti)),chanlocs,'maplimits',[-mV,mV]);
        colormap('hot');
        if Numofsti ==1
           tN = strcat('#',num2str(Selected_k(kk)),'-',Stimulus_Name{Numofsti}); 
        else
        tN = Stimulus_Name{Numofsti};
        end
        title(tN,'fontsize',14);
        set(gca,'clim',[-mV mV]);
    end
end
last_subplot = subplot(rowNum,columnNum, count,'align');
last_subplot_position = get(last_subplot,'position');
colorbar_h = colorbar('peer',gca,'SouthOutside','fontsize',10);
set(last_subplot,'pos',last_subplot_position);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%-----------------------------Single-trial-based group PCA--------------%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


count = 0;
Group_Idx = [];
count1 = 0;
sti_trial_label =[];
X = [];
    for Numofsub = 1:length(Subject_Name)
        fn = char(strcat('1_wavelet_filter',filesep,num2str(Subject_Name(Numofsub)),'.mat'));
        D = [];
        D = importdata([fn]);
        stiNum = length(fieldnames(D));
        fieldNames = fieldnames(D);
        for Numofsti = 1:stiNum
            count1= count1+1;
            data = [];
            trialNum = [];
            data = getfield(D,fieldNames{Numofsti});
            [chanNum,samPoints,trialNum] = size(data);
            sti_trial_label = [sti_trial_label;count1*ones(trialNum,1)];
            for Numoftrial = 1:trialNum
                count = count +1;
                X(:,:,count)  = squeeze(data(:,:,Numoftrial));
            end
        end
    end
[NumChans,NumSamps,NumSubs] = size(X);
X = permute(X,[2 1 3]);
%% grouping data into a matrix
X= reshape(X,NumSamps,NumChans*NumSubs);
timeIndex = linspace(timeStart,timeEnd,NumSamps);
%% PCA
[coef,score,lambda] = pca(X');
ratio = f_explainedVariance(lambda);
threshold = [99 95 90];
for is = 1:length(threshold)
    [va idx] = find(ratio<threshold(is));
    thresholdcomponetsNum(is) = length(idx)+1;
end
%%
for is = 1:length(lambda)
    ratio_sigle(is) = 100*lambda(is)./sum(lambda);
end
%%
R = 40;

%% rotation
V = coef(:,1:R);
Z = score(:,1:R);
%% rotation for blind source separation
[translated_V,W] = rotatefactors(V, 'Method','promax','power',3,'Maxit',500);
B = inv(W');
Y = Z*W; %%% spatial components
T = V*B;  %%% temporal components

[peakValue,peakTime] = max(abs(T));
timePstart = ceil((0-timeStart)/(1000/fs))+1;
for r = 1 :R
    temp = T(:,r);
    T (:,r) =  temp - mean(temp(1:timePstart));
    peak_T(r) = round((peakTime(r)-1)*(1000/fs)) + timeStart;
end
%%%%

X1 = Y';
topo = reshape(Y',R,NumChans,NumSubs);
topo_similarity_AV =[];
count =0;
D = [];
count1= 0;
for    Numofgroup = 1:1
    for Numofsub = 1:length(Subject_Name)
        count1= count1+1;
        for Numofsti= 1:6
            count = count+1;
            idx1 = 0;
            idx1 = find(sti_trial_label == count);
            D(:,:,Numofsti,count1) = squeeze(mean(topo(:,:,idx1),3));
        end
    end
end
%%
%%
group_Index = [ones(length(Subject_Name),1)];
for Numofgroup = 1:1
    Index = find(group_Index==Numofgroup);
    for Numofsti =1:6
        temp= [];
        temp = squeeze(D(:,:,Numofsti,Index));
        topo_av(:,:,Numofsti,Numofgroup) =  squeeze(mean(temp,3));
        for k = 1:R
            temp1 = corr(squeeze(D(k,:,Numofsti,Index)));
            topo_similarity{:,:,k,Numofsti,Numofgroup} = temp1;
            RHO(k,Numofsti,Numofgroup) = mean(temp(:));
        end
    end
end


Selected_k = [7 10];%%Order for the identified factors

%%Correlations between selected factors
X1 = D(Selected_k,:,:,:);
X1 = reshape(X1,numel(Selected_k),[]);
RHO2 = 0;
for i = 1:size(X1,1)
    for j = 1:size(X1,1)
        data1 = X1(i,:);
        data2= X1(j,:);
        RHO2(i,j) = corr(data1',data2') ;
    end
end


%%----------------------------Back-projection and save the reconstructed data as '.mat'--------------------------------------
E = T(:,Selected_k)*Y(:,Selected_k)';%%Back-projection
temp = reshape(E,NumSamps,NumChans,NumSubs);
count= 0;
D_pb= [];
count1=0;
for Numofgroup =1:1
    for Numofsub = 1:length(Subject_Name)
        count1=count1+1;
        for Numofsti= 1:6
            count = count+1;
            idx1 = 0;
            idx1 = find(sti_trial_label == count);
            D_pb(:,:,Numofsti,count1) = squeeze(mean(temp(:,:,idx1),3));
        end
    end
end

D_pb = permute(D_pb,[2 1 3 4]);
fileNameNew = ['PCA_single_trial_group_P2_R_',num2str(R),'_K_',num2str(Selected_k)];
save(fileNameNew,'D_pb','-v7.3');
%%%plot results of temporal components and spatial component
hold on
ratio_sigle_keep = ratio_sigle(1:R);
set(gcf,'outerposition',get(0,'screensize'))
subplot(rowNum,columnNum,[8:13 21:26],'align')
set(gca,'fontsize',12);
hold on;
plot(timeIndex,T(:,Selected_k),'linewidth',3)
xlim([timeStart timeEnd])
xlabel('Time/ms');
ylabel('Magnitude');
set(gca,'ydir','reverse');
title('Factors for P2 for single-trial-based group PCA'); 
for Numoffactor = 1:numel(Selected_k)
  LegendName{Numoffactor} = char(strcat('Factor',32,num2str(Selected_k(Numoffactor)),'- Explained:',num2str(roundn(ratio_sigle_keep(Selected_k(Numoffactor)),-2)),'%-Latency:',num2str(peak_T(Selected_k(Numoffactor))),'ms'));  
end
legend(LegendName,'location','best');
legend('boxoff');

for kk = 1:length(Selected_k)
    topo_k = squeeze(topo_av(Selected_k,:,:,:));
    mV = max(abs(topo_k(:)));
    count = (kk+1)*columnNum+7;
    for Numofsti = 1:6
        count = count +1;
        subplot(rowNum,columnNum,count,'align')
        set(gca,'fontsize',14)
        topoplot(squeeze(topo_av(Selected_k(kk),:,Numofsti)),chanlocs,'maplimits',[-mV,mV]);
        colormap('hot');
        if Numofsti ==1
           tN = strcat('#',num2str(Selected_k(kk)),'-',Stimulus_Name{Numofsti}); 
        else
        tN = Stimulus_Name{Numofsti};
        end
        title(tN,'fontsize',14);
        set(gca,'clim',[-mV mV]);
    end
end
last_subplot = subplot(rowNum,columnNum, count,'align');
last_subplot_position = get(last_subplot,'position');
colorbar_h = colorbar('peer',gca,'SouthOutside','fontsize',10);
set(last_subplot,'pos',last_subplot_position);

%Display the correlation results for the selected factors
cdata = roundn((RHO2),-2);

fprintf( [repmat('_',1,70) '\n']);
fprintf(['P2:Correlations between factors for single-trial-based group PCA.\n']);
fprintf( [repmat('_',1,70) '\n']);
fprintf(['Correlation between factor 7 and factor 10 is',32,num2str(cdata(2,1)), '.\n']);
fprintf( [repmat('_',1,70) '\n']);

%%
tic