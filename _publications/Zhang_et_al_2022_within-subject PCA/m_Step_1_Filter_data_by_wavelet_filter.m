% % %Script #1
%%%  Filtering sing-trial EEG data after preprocessed
%%% In order to run this code, please install EEGLAB toolboxes. It can be downloaded from http://sccn.ucsd.edu/eeglab/
%%% This code was written by GuangHui Zhang in Match 2021, JYU
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



%Location of the main study directory
%This method of specifying the study directory only works if you run the script;
%for running individual lines of code, replace the study directory with the path on your computer, e.g.: DIR = \Users\Lu_Emotional_ERP_Experiment
Subject_file_Path = fileparts(fileparts(mfilename('fullpath')));


%Location of the folder that contains this script and any associated processing files
%This method of specifying the current file path only works if you run the script;
%For running individual lines of code, replace the current file path with the path on your computer, e.g.: DIR = \Users\Lu_Emotional_ERP_Experiment\Codes_for_EEG_ERP_Processing
Current_File_Path = fileparts(mfilename('fullpath'));

%List of subjects to process, based on the name of the folder that contains that subject's data
Subject_Name = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20'};

% List of stimulus for each subject to process separately, based on the name of the sub-folder that contains that subject's data
Stimulus_Name = {'MD','MF','ED','EF','ND','NF'};

%% add function into path
Currentpath1 = char(strcat(Current_File_Path,filesep,'functions',filesep));
addpath(genpath(Currentpath1));

%%
timeStart = -200;%% The lower time-internal of one epoch
NumSamps = 900;%% Time point within one epoch
fs = 500;%% sampling rate

%% wavelet filter -- See 'Function\f_filterWavelet'
wname = ['rbio6.8'];%% Name of the wavelet
lv = 9; %% Decomposition level
kp = [2 3 4 5 6]; %% Reconstruction and output the result
timePstart = round((0-timeStart)/(1000/fs))+1;

%%Frequency responses of wavelet filter
Len=NumSamps;
Dura = NumSamps;
FFTLen=fs*10;
freqRs=fs/FFTLen;
freLow=fs/FFTLen;
freHigh = 35;
binLow=freLow/freqRs;
binHigh=freHigh/freqRs;
timeIndex=(1:(2*Len-1))*1000/fs;
fIndex=freLow:freqRs:freHigh;
sig=[zeros(Len-1,1);1; zeros(Len-1,1)];
tIndex = linspace(-Dura,Dura,length(sig));
%%%%%%%%%%%%%%%%%%%%%%% Wavelet filter
WLDsig=f_filterWavelet(sig,lv,wname,kp);
WLDsigFFT=fft(WLDsig,FFTLen);
spec=abs(WLDsigFFT(binLow:binHigh,:));
WaveletfreqResp=20*log10(spec/max(spec));
Waveletphase = 2*pi*phase(WLDsigFFT(binLow:binHigh));

figure;
% set(gcf,'outerposition',get(0,'screensize'));
subplot(2,1,1);
set(gca,'fontsize',20);
hold on;
plot(fIndex,WaveletfreqResp,'k','linewidth',3);
xlim([freLow,freHigh]);
ylim([-100 20]);
tN = ['Magnitude of frequency responses '];
title(tN,'fontsize',16);
xlabel('Frequency/Hz','fontsize',16);
ylabel('Attenuation/dB','fontsize',16);
legend(' Wavelet filter','location','Southwest')

subplot(2,1,2);
set(gca,'fontsize',20);
hold on;
plot(fIndex,Waveletphase,'k','linewidth',3);
xlim([freLow,freHigh]);
tN = ['Phase of frequency responses'];
title(tN,'fontsize',16);
xlabel('Frequency/Hz','fontsize',16);
ylabel('Angle/degree','fontsize',16);
%%


stiName = {'BC-MD','BC-MF','BC-ED','BC-EF','BC-DN','BC-DF'};

pn = strcat('G:\JYU\Data\shangti_luyingzhi\DATA  for 2015\Unaveraged data',filesep);

route  =strcat('1_exported_data',filesep);
mkdir(route);
subName = [6];
% subName = [1:4,7:10,13,14:16,18:22,24:26];
for Numofsub  =1:length(subName)
    
    for Numofsti  =1:length(stiName)
        
        switch Numofsti
            
            case 1
                if subName(Numofsub) > 9
                    fn = strcat('D0',num2str(subName(Numofsub)),'_',stiName{Numofsti},'.vhdr');
                else
                    fn = strcat('D00',num2str(subName(Numofsub)),'_',stiName{Numofsti},'.vhdr');
                end
                
                EEG = pop_loadbv([pn,stiName{Numofsti},filesep], fn);
                EEG = eeg_checkset( EEG );
                EEG = pop_select( EEG,'nochannel',{'TP9' 'VEOG' 'TP10' 'HEOG'});
                EEG = eeg_checkset( EEG );
                EEG = pop_resample( EEG, 500);
                EEG = eeg_checkset( EEG );
                
                X.s1 = double(EEG.data);
                
                
            case 2
                
                if subName(Numofsub) > 9
                    fn = strcat('F0',num2str(subName(Numofsub)),'_',stiName{Numofsti},'.vhdr');
                else
                    fn = strcat('F00',num2str(subName(Numofsub)),'_',stiName{Numofsti},'.vhdr');
                end
                
                EEG = pop_loadbv([pn,stiName{Numofsti},filesep], fn);
                EEG = eeg_checkset( EEG );
                EEG = pop_select( EEG,'nochannel',{'TP9' 'VEOG' 'TP10' 'HEOG'});
                EEG = eeg_checkset( EEG );
                EEG = pop_resample( EEG, 500);
                EEG = eeg_checkset( EEG );
                X.s2 = double(EEG.data);
                
            case 3
                
                if subName(Numofsub) > 9
                    fn = strcat('D0',num2str(subName(Numofsub)),'_',stiName{Numofsti},'.vhdr');
                else
                    fn = strcat('D00',num2str(subName(Numofsub)),'_',stiName{Numofsti},'.vhdr');
                end
                
                EEG = pop_loadbv([pn,stiName{Numofsti},filesep], fn);
                EEG = eeg_checkset( EEG );
                EEG = pop_select( EEG,'nochannel',{'TP9' 'VEOG' 'TP10' 'HEOG'});
                EEG = eeg_checkset( EEG );
                EEG = pop_resample( EEG, 500);
                EEG = eeg_checkset( EEG );
                X.s3 = double(EEG.data);
                
            case 4
                
                if subName(Numofsub) > 9
                    fn = strcat('F0',num2str(subName(Numofsub)),'_',stiName{Numofsti},'.vhdr');
                else
                    fn = strcat('F00',num2str(subName(Numofsub)),'_',stiName{Numofsti},'.vhdr');
                end
                
                EEG = pop_loadbv([pn,stiName{Numofsti},filesep], fn);
                EEG = eeg_checkset( EEG );
                EEG = pop_select( EEG,'nochannel',{'TP9' 'VEOG' 'TP10' 'HEOG'});
                EEG = eeg_checkset( EEG );
                EEG = pop_resample( EEG, 500);
                EEG = eeg_checkset( EEG );
                
                X.s4 = double(EEG.data);
                
            case 5
                if subName(Numofsub) > 9
                    fn = strcat('D0',num2str(subName(Numofsub)),'_',stiName{Numofsti},'.vhdr');
                else
                    fn = strcat('D00',num2str(subName(Numofsub)),'_',stiName{Numofsti},'.vhdr');
                end
                
                EEG = pop_loadbv([pn,stiName{Numofsti},filesep], fn);
                EEG = eeg_checkset( EEG );
                EEG = pop_select( EEG,'nochannel',{'TP9' 'VEOG' 'TP10' 'HEOG'});
                EEG = eeg_checkset( EEG );
                EEG = pop_resample( EEG, 500);
                EEG = eeg_checkset( EEG );
                
                X.s5 = double(EEG.data);
                
                
            case 6
                
                if subName(Numofsub) > 9
                    fn = strcat('F0',num2str(subName(Numofsub)),'_',stiName{Numofsti},'.vhdr');
                else
                    fn = strcat('F00',num2str(subName(Numofsub)),'_',stiName{Numofsti},'.vhdr');
                end
                
                EEG = pop_loadbv([pn,stiName{Numofsti},filesep], fn);
                EEG = eeg_checkset( EEG );
                EEG = pop_select( EEG,'nochannel',{'TP9' 'VEOG' 'TP10' 'HEOG'});
                EEG = eeg_checkset( EEG );
                EEG = pop_resample( EEG, 500);
                EEG = eeg_checkset( EEG );
                
                X.s6 = double(EEG.data);
                
        end
        [chanNum,sampoints,trialNum] = size(data);
        for Numoftrial = 1:trialNum
            for chan = 1:chanNum
                temp = squeeze(data(chan,:,Numoftrial))' ;
                temp1 = f_filterWavelet(temp,lv,wname,kp);
                temp1 = temp1 - mean(temp1(1:timePstart));
                d3 (chan,:,Numoftrial) = temp1;
                
            end
        end
        EEG.data = d3;
        
        
        
        
    end
    fileName = strcat(num2str(subName(Numofsub)),'.mat');
    save([route,fileName ],'X','-v7.3');
    
    clear X;
    
    
end





Hw_news =['Filtering EEG data by wavelet filter...'];
Hw = waitbar(0,Hw_news);
count = 0;
for Numofsub = 1:length(Subject_Name)
    
    for Numofsti = 1:length(Stimulus_Name)
        count = count +1;
        waitbar(count/(length(Subject_Name)*length(Stimulus_Name)),Hw);
        %%load data of each subject under each condition
        EEG = [];
        fileName = strcat('Sub_',Subject_Name{Numofsub},'_Emotional_Lu_2017',filesep,Subject_Name{Numofsub},'_',Stimulus_Name{Numofsti},'.set');
        EEG = pop_loadset([Subject_file_Path,filesep,fileName]);
        
        data = [];
        d3  =[];
        data = EEG.data;
        [chanNum,sampoints,trialNum] = size(data);
        for Numoftrial = 1:trialNum
            for chan = 1:chanNum
                temp = squeeze(data(chan,:,Numoftrial))' ;
                temp1 = f_filterWavelet(temp,lv,wname,kp);
                temp1 = temp1 - mean(temp1(1:timePstart));
                d3 (chan,:,Numoftrial) = temp1;
                
            end
        end
        EEG.data = d3;
        %%save filtered data for each subject under each experimental conditon to the original folder
        fileName_save = strcat('Sub_',Subject_Name{Numofsub},'_Emotional_Lu_2017',filesep,Subject_Name{Numofsub},'_',Stimulus_Name{Numofsti},'_WF.set');
        EEG = pop_saveset( EEG, fileName_save,[Subject_file_Path,filesep]);
        EEG = eeg_checkset( EEG );
        %%
    end
end
close(Hw);
%% program ends
toc