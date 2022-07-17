% % %Figure5_Tab4_N2_wave_topo_four_methods_all_remained_trials
%%% Plot grand averaged waveforms and toographies for all conditions for N2(all remained trials)
%%% Compute the statistical analysis results based on two-way ANOVA


%%%Uses the outputs from:m_Step_1_Filter_data_by_wavelet_filter.m
%%%                      m_Step_2_Extract_P2_N2_withinsubject_PCA.m
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
tic
%%
%%  setting parameters
timeStart = -200;

timeEnd = 898;
fs = 500;
Group_Idx= ones(20,1);

NumGroups = max(Group_Idx);
%%
ERPStart  =190;
ERPEnd = 310;
load chanlocs;
%%
D(:,:,:,:,1) = importdata('X_WF_all_trials_N2.mat');
D(:,:,:,:,4) = importdata('PCA_withinsubject_N2.mat');
D(:,:,:,:,2) = importdata('PCA_average_group_N2_R_40_K_2   5   9  26.mat');
D(:,:,:,:,3) = importdata('PCA_single_trial_group_N2_R_40_K_3  10  12  16.mat');

ERPSampointStart = round((ERPStart - timeStart)/(1000/fs)) + 1 ;
ERPSampointEnd = round((ERPEnd - timeStart)/(1000/fs)) + 1 ;
[NumChans,NumSamps,NumSti,NumSubs,NumMethod] = size(D);
tIndex = linspace(timeStart,timeEnd,NumSamps);
%%
ChansOfInterestNames = {'FC3','FC4','FCz','Cz','C3','C4'};
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

TOPO = squeeze(mean(D(:,ERPSampointStart:ERPSampointEnd,:,:,:),2));
Topo_av = squeeze(mean(TOPO,3));

TOPO_sta = squeeze(mean(TOPO(ChansOfInterestNumbers,:,:,:),1));

%% the Grand waveform(s) at interest electrode(s)
MethodName = {'Conventional time-domain analysis','Trial-averaged group PCA','Single-trial-based group PCA','Within-subject PCA'};
D_av = squeeze(mean(D(ChansOfInterestNumbers,:,:,:,:),1));
D_av = squeeze(mean(D_av,3));
%%
Max_mv = max(abs(Topo_av(:)));
rowNum =2;
columnNum =6;
Sti_names = {'MD','MF','ED','EF','DN','DF'};
for Numofmethod = 1:NumMethod
    
    figure;
    set(gcf,'outerposition',get(0,'screensize'))
    for sti = 1:NumSti
        subplot(rowNum,columnNum,[1:3 7:9],'align');
        set(gca,'fontsize',12,'FontWeight','bold');
        hold on;
        switch sti
            case 1
                plot(tIndex(1:501), D_av(1:501,sti,Numofmethod),'k','linewidth',1);
                hold on;
                %                 plot(tIndex(1:501), D_av(1:501,sti,1),'k','linewidth',1);
                
            case 2
                plot(tIndex(1:501), D_av(1:501,sti,Numofmethod),'k-.','linewidth',1);
                hold on;
                %                 plot(tIndex(1:501), D_av(1:501,sti,1),'k-.','linewidth',1);
                
            case 3
                plot(tIndex(1:501),D_av(1:501,sti,Numofmethod),'b','linewidth',1)
                hold on;
                %                 plot(tIndex(1:501), D_av(1:501,sti,1),'b','linewidth',1);
            case 4
                plot(tIndex(1:501), D_av(1:501,sti,Numofmethod),'b-.','linewidth',1);
                hold on;
                %                 plot(tIndex(-1:501), D_av(1:501,sti,1),'b-.','linewidth',1);
                
            case 5
                plot(tIndex(1:501), D_av(1:501,sti,Numofmethod),'r','linewidth',1);
                hold on;
                %                 plot(tIndex(1:501), D_av(1:501,sti,1),'r','linewidth',1);
            case 6
                plot(tIndex(1:501),D_av(1:501,sti,Numofmethod),'r-.','linewidth',1)
                hold on;
                %                 plot(tIndex(1:501), D_av(1:501,sti,1),'r-.','linewidth',1);
        end
        set(gca,'ydir','reverse','FontWeight','bold');
        xlim([timeStart,800]);
        ylim([-5,1]);
        hold on;
        
        if  sti ==1
            xlabel(['Time/ms'],'fontsize',16);
            ylabel(['Amplitude/\muV'],'fontsize',16);
            
        end
    end
    legend(Sti_names);
    legend('boxoff');
    tN = strcat('N2:Grand averaged waves for',32,MethodName{Numofmethod});
    title(tN);
    %%Topographies
    for sti = 1:NumSti
        if sti<4
            code = sti+3;
        else
            code = sti+6;
        end
        subplot(rowNum,columnNum,code ,'align');
        set(gca,'fontsize',16,'FontWeight','bold')
        topoplot(squeeze(Topo_av(:,sti,Numofmethod)),chanlocs,'maplimits',[-12,12]);
        hold on;
        tN = [Sti_names{sti}];
        title(tN,'fontsize',14);
        hold on;
        colormap('hot');
        if  code == 12
            last_subplot = subplot(rowNum,columnNum, code,'align');
            last_subplot_position = get(last_subplot,'position');
            colorbar_h = colorbar('peer',gca,'SouthOutside','fontsize',10);
            set(last_subplot,'pos',last_subplot_position);
        end
    end
    
end


%%-------Display the statistical analysis results to Commend window--------
for Numofmethod = 1:4
    topo_box = squeeze(TOPO_sta(:,:,Numofmethod))';
    [subNum,stiNum]= size(topo_box);
    Y = reshape(topo_box,[],1);
    stiOne =3;
    stiTwo = 2;
    stiNum = stiOne*stiTwo;
    BTFacs =[];
    WInFacs = [];
    count = 0;
    for is = 1:stiOne
        IdexStart = subNum*(is-1)*stiTwo+1;
        IdexEnd =  is*subNum*stiTwo;
        WInFacs(IdexStart:IdexEnd,1) = is;
        for iss  = 1:stiTwo
            count  = count +1;
            IdexStart = subNum*(count-1)+1;
            IdexEnd =  subNum*count;
            WInFacs(IdexStart:IdexEnd,2) = iss;
        end
    end
    
    S = [];
    for iss = 1:stiNum
        IdexStart = subNum*(iss-1)+1;
        IdexEnd =  iss*subNum;
        S(IdexStart:IdexEnd,1) =1:subNum ;
    end
    factorNames = {'Valence','Negative-category'};
    D = reshape(Y,1 ,[]);
    fprintf( ['\n\n\n\n\n'])
    fprintf( [repmat('_',1,170) '\n']);
    fprintf(['N2:Statistical analysis results for',32,MethodName{Numofmethod} ,'.\n']);
    fprintf( [repmat('--',1,170) '\n']);
    sta = f_rm_anova2(D,WInFacs,S,factorNames);
    fprintf( [repmat('_',1,170) '\n']);
end

uiwait(msgbox('The program ends'));
%% program ends
toc