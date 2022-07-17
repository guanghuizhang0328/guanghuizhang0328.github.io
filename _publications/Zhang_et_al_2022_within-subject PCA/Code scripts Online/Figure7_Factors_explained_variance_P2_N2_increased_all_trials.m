clear
clc
close all
%%
tic

pathName = strcat('Factors_three_PCA_methods_increased_trials and all trials',filesep);
%%----------Proportion of explained variance for Factors for P2 for increased trials and all trials --------------------------------

%%Load lambda of factors for withinsubject PCA
X = importdata([pathName, 'P2_withinsubject_PCA_factor_lambda.mat']);
X_mean(1,:) = squeeze(mean(X,2));
X_std(1,:)  = squeeze(std(X,0,2))/sqrt(17);
X1 = importdata([pathName,'P2_withinsubject_PCA_factor_lambda_all_trials.mat']);
X_mean(1,34) = squeeze(mean(X1,1));
X_std(1,34)  = squeeze(std(X1,0,1))/sqrt(17);

%%%Load lambda of factors for trial-averaged group PCA
X_mean(2,1:33) = importdata([pathName,'P2_Group_averaged_PCA_factor_lambda.mat']);
X_std(2,:)  = 0;
X_mean(2,34) = 2.703;
X_std(2,34)  = 0;

%%Load lambda of factors for single-trial-based group PCA
X_mean(3,1:33) = importdata([pathName,'P2_Group_single_PCA_factor_lambda.mat']);
X_std(3,:)  = 0;
X_mean(3,34) = 4.54;
X_std(3,34)  = 0;

X_mean = X_mean([2 3 1],:);
X_std =X_std([2 3 1],:);

figure;
set(gcf,'outerposition',get(0,'screensize'));
subplot(2,1,1,'align');
hold on;
hold on;
set(gca,'fontsize',14);
B_set = bar(X_mean','hist');
B_set(3).FaceColor = 'b';
B_set(3).FaceAlpha = 0.5;
B_set(2).FaceColor = 'r';
B_set(2).FaceAlpha = 0.5;
B_set(1).FaceColor = 'k';
B_set(1).FaceAlpha = 0.5;

ylabel(['Percentage/%']);
xlabel(['Number of trials']);

numgroups = size(X_mean, 2);
numbars = size(X_mean, 1);
xlim([0 35]);
ylim([0 15]);
hold on;
title(['P2:Proportion of explained variance for selected factors for increased trials and all trials for three PCA-based methods'])

legend({'Trial-averaged group-PCA','Single-trial-based group PCA','Winthin-subject PCA'});
legend('boxoff');
set(gca,'xtick',[0:35]);
set(gca,'ytick',[0:5:15]);


count = 1;
xtick_labels{1} ='';
for ii = 10:42
    count = count+1;
    xtick_labels{count} = num2str(ii);
end
xtick_labels{count+1} ='All';
set(gca,'XTickLabel',xtick_labels);%%,'XTickLabelRotation',45


groupwidth = min(0.8, numbars/(numbars+1.5));
for i = 3:3%Error bar for within-subject PCA
    X= (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
    hErr =   errorbar(X, X_mean(i,:)', X_std(i,:), 'k', 'linestyle', 'none', 'LineWidth', 1);
    mult = 0.3;                               % twice as long
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
    hold on;
end


%%%--------------------------Proportion of explained variance for Factors for N2--------------------------------
%%Load lambda of factors for withinsubject PCA
X_mean =[];
X_std = [];
X = importdata([pathName, 'N2_withinsubject_PCA_factor_lambda.mat']);
X_mean(1,:) = squeeze(mean(X,2));
X_std(1,:)  = squeeze(std(X,0,2))/sqrt(20);
X1 = importdata([pathName,'N2_withinsubject_PCA_factor_lambda_all_trials.mat']);
X_mean(1,34) = squeeze(mean(X1,1));
X_std(1,34)  = squeeze(std(X1,0,1))/sqrt(20);

%%%Load lambda of factors for trial-averaged group PCA
X_mean(2,1:33) = importdata([pathName,'N2_Group_averaged_PCA_factor_lambda.mat']);
X_std(2,:)  = 0;
X_mean(2,34) = 10.847;
X_std(2,34)  = 0;

%%Load lambda of factors for single-trial-based group PCA
X_mean(3,1:33) = importdata([pathName,'N2_Group_single_PCA_factor_lambda.mat']);
X_std(3,:)  = 0;
X_mean(3,34) = 12.389;
X_std(3,34)  = 0;


X_mean = X_mean([2 3 1],:);
X_std =X_std([2 3 1],:);
RowNum =2;
ColumnNum=2;

set(gcf,'outerposition',get(0,'screensize'));
subplot(2,1,2,'align');
hold on;
hold on;
set(gca,'fontsize',14);
B_set = bar(X_mean','hist');
B_set(3).FaceColor = 'b';
B_set(3).FaceAlpha = 0.5;
B_set(2).FaceColor = 'r';
B_set(2).FaceAlpha = 0.5;
B_set(1).FaceColor = 'k';
B_set(1).FaceAlpha = 0.5;

tN = strcat('Mean measurement');
title(tN,'fontsize',14);
% xlim([10 42]);

ylabel(['Percentage/%']);
xlabel(['Number of trials']);

numgroups = size(X_mean, 2);
numbars = size(X_mean, 1);
xlim([0 35]);

ylim([0 90]);
hold on;

title(['N2:Proportion of explained variance for selected factors for increased trials and all trials for three PCA-based methods']);
legend({'Trial-averaged group-PCA','Single-trial-based group PCA','Winthin-subject PCA'});
legend('boxoff');
set(gca,'xtick',[0:35]);
set(gca,'ytick',[0:30:90]);

count = 1;
xtick_labels{1} ='';
for ii = 10:42
    count = count+1;
    xtick_labels{count} = num2str(ii);
end
xtick_labels{count+1} ='All';
set(gca,'XTickLabel',xtick_labels);%%,'XTickLabelRotation',45

% set(gca,'YTickLabel',[-6:4:18]);
groupwidth = min(0.8, numbars/(numbars+1.5));
for i = 3:3% Errorbar for withinsubject PCA
    X= (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
    hErr =   errorbar(X, X_mean(i,:)', X_std(i,:), 'k', 'linestyle', 'none', 'LineWidth', 1);
    mult = 0.3;
    b = hErr.Bar;
    drawnow;
    vd = b.VertexData;
    N = numel(X);                           % number of error bars
    capLength = vd(1,2*N+2,1) - vd(1,1,1);  % assumes equal length on all
    newLength = capLength * mult;
    leftInds = N*2+1:2:N*6;
    rightInds = N*2+2:2:N*6;
    vd(1,leftInds,1) = [X-newLength, X-newLength];
    vd(1,rightInds,1) = [X+newLength, X+newLength];
    b.VertexData = vd;
    hold on;
end
%%
toc