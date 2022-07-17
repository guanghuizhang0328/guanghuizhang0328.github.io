function stats = f_rm_anova2(Y,WInFacs,S,FACTNAMES)
%
% function stats = rm_anova2(Y,S,F1,F2,FACTNAMES)
%
% Two-factor, within-subject repeated measures ANOVA.
% For designs with two within-subject factors.
%
% Parameters:
%    Y          dependent variable (numeric) in a column vector
%    S          grouping variable for SUBJECT
%    F1         grouping variable for factor #1
%    F2         grouping variable for factor #2
%    FACTNAMES  a cell array w/ two char arrays: {'factor1', 'factor2'}
%
%    Y should be a 1-d column vector with all of your data (numeric).
%    The grouping variables should also be 1-d numeric, each with same
%    length as Y. Each entry in each of the grouping vectors indicates the
%    level # (or subject #) of the corresponding entry in Y.
%
% Returns:
%    stats is a cell array with the usual ANOVA table:
%      Source / ss / df / ms / F / p
%
% Notes:
%    Program does not do any input validation, so it is up to you to make
%    sure that you have passed in the parameters in the correct form:
%
%       Y, S, F1, and F2 must be numeric vectors all of the same length.
%
%       There must be at least one value in Y for each possible combination
%       of S, F1, and F2 (i.e. there must be at least one measurement per
%       subject per condition).
%
%       If there is more than one measurement per subject X condition, then
%       the program will take the mean of those measurements.
%
% Aaron Schurger (2005.02.04)
%   Derived from Keppel & Wickens (2004) "Design and Analysis" ch. 18
%

%
% Revision history...
%
% 11 December 2009 (Aaron Schurger)
% 
% Fixed error under "bracket terms"
% was: expY = sum(Y.^2);
% now: expY = sum(sum(sum(MEANS.^2)));
%
BTFacs = [];
F1 =WInFacs(:,1);
F2= WInFacs(:,2);
[EpsHF EpsGG] = GenCalcHFEps(Y',BTFacs,WInFacs,S);


stats = cell(4,5);

F1_lvls = unique(F1);
F2_lvls = unique(F2);
Subjs = unique(S);

a = length(F1_lvls); % # of levels in factor 1
b = length(F2_lvls); % # of levels in factor 2
n = length(Subjs); % # of subjects

INDS = cell(a,b,n); % this will hold arrays of indices
CELLS = cell(a,b,n); % this will hold the data for each subject X condition
MEANS = zeros(a,b,n); % this will hold the means for each subj X condition

% Calculate means for each subject X condition.
% Keep data in CELLS, because in future we may want to allow options for
% how to compute the means (e.g. leaving out outliers > 3stdev, etc...).
for i=1:a % F1
    for j=1:b % F2
        for k=1:n % Subjs
            INDS{i,j,k} = find(F1==F1_lvls(i) & F2==F2_lvls(j) & S==Subjs(k));
            CELLS{i,j,k} = Y(INDS{i,j,k});
            MEANS(i,j,k) = mean(CELLS{i,j,k});
        end
    end
end

% make tables (see table 18.1, p. 402)
AB = reshape(sum(MEANS,3),a,b); % across subjects
AS = reshape(sum(MEANS,2),a,n); % across factor 2
BS = reshape(sum(MEANS,1),b,n); % across factor 1

A = sum(AB,2); % sum across columns, so result is ax1 column vector
B = sum(AB,1); % sum across rows, so result is 1xb row vector
S = sum(AS,1); % sum across columns, so result is 1xs row vector
T = sum(sum(A)); % could sum either A or B or S, choice is arbitrary

% degrees of freedom
dfA = a-1;
dfA_G = dfA*EpsGG(1);
dfA_H = dfA*EpsHF(1);


dfB = b-1;
dfB_G = dfB*EpsGG(2);
dfB_H = dfB*EpsHF(2);


dfAB = (a-1)*(b-1);
dfAB_G = dfAB*EpsGG(3);
dfAB_H = dfAB*EpsHF(3);

dfS = n-1;

dfAS = (a-1)*(n-1);
dfAS_G = dfAS*EpsGG(1);
dfAS_H = dfAS*EpsHF(1);

dfBS = (b-1)*(n-1);
dfBS_G = dfBS*EpsGG(2);
dfBS_H = dfBS*EpsHF(2);

dfABS = (a-1)*(b-1)*(n-1);
dfABS_G = dfABS*EpsGG(3);
dfABS_H = dfABS*EpsHF(3);

% bracket terms (expected value)
expA = sum(A.^2)./(b*n);
expB = sum(B.^2)./(a*n);
expAB = sum(sum(AB.^2))./n;
expS = sum(S.^2)./(a*b);
expAS = sum(sum(AS.^2))./b;
expBS = sum(sum(BS.^2))./a;
expY = sum(sum(sum(MEANS.^2))); %sum(Y.^2);
expT = T^2 / (a*b*n);

% sums of squares
ssA = expA - expT;
ssB = expB - expT;
ssAB = expAB - expA - expB + expT;
ssS = expS - expT;
ssAS = expAS - expA - expS + expT;
ssBS = expBS - expB - expS + expT;
ssABS = expY - expAB - expAS - expBS + expA + expB + expS - expT;
ssTot = expY - expT;



% mean squares
% FACTOR A
msA = ssA / dfA;
msA_G = ssA / dfA_G;
msA_H = ssA / dfA_H;

msAS = ssAS / dfAS;
msAS_G = ssAS / dfAS_G;
msAS_H = ssAS / dfAS_H;

% FACTOR B
msB = ssB / dfB;
msB_G = ssB / dfB_G;
msB_H = ssB / dfB_H;

msBS = ssBS / dfBS;
msBS_G = ssBS / dfBS_G;
msBS_H = ssBS / dfBS_H;
% INTERACTION BETWEEN A AND B
msAB = ssAB / dfAB;
msAB_G = ssAB / dfAB_G;
msAB_H = ssAB / dfAB_H;

msABS = ssABS / dfABS;
msABS_G = ssABS / dfABS_G;
msABS_H = ssABS / dfABS_H;

msS = ssS / dfS;

% f statistic
fA = msA / msAS;
fB = msB / msBS;
fAB = msAB / msABS;
pA = 1-fcdf(fA,dfA,dfAS);
pA_G = 1-fcdf(fA,dfA_G,dfAS_G);
pA_H = 1-fcdf(fA,dfA_H,dfAS_H);

pB = 1-fcdf(fB,dfB,dfBS);
pB_G = 1-fcdf(fB,dfB_G,dfBS_G);
pB_H = 1-fcdf(fB,dfB_H,dfBS_H);

pAB = 1-fcdf(fAB,dfAB,dfABS);
pAB_G = 1-fcdf(fAB,dfAB_G,dfABS_G);
pAB_H = 1-fcdf(fAB,dfAB_H,dfABS_H);
% return values
stats = {'Source','Correction Method','SS','df','MS','F','p';... 
         FACTNAMES{1}, 'Sphericity Assumed',roundn(ssA,-3), roundn(dfA,-3), roundn(msA,-3), roundn(fA,-3), roundn(pA,-3);...
         [],  'Greenhouse-Geisser',roundn(ssA,-3),roundn(dfA_G,-3), roundn(msA_G,-3), roundn(fA,-3), roundn(pA_G,-3);...
         [], 'Huynd-Feldt',roundn(ssA,-3), roundn(dfA_H,-3), roundn(msA_H,-3), roundn(fA,-3), roundn(pA_H,-3);...
         ['Error(',FACTNAMES{1} ')'],'Sphericity Assumed', roundn(ssAS,-3), roundn(dfAS,-3), roundn(msAS,-3), [], [];...
         [],'Greenhouse-Geisser', roundn(ssAS,-3), roundn(dfAS_G,-3), roundn(msAS_G,-3), [], [];...
         [], 'Huynd-Feldt',roundn(ssAS,-3), roundn(dfAS_H,-3), roundn(msAS_H,-3), [], [];...
         
         FACTNAMES{2}, 'Sphericity Assumed', ssB, dfB, msB, fB, pB;...
         [],'Greenhouse-Geisser', roundn(ssB,-3), roundn(dfB_G,-3), roundn(msB_G,-3), roundn(fB,-3), roundn(pB_G,-3);...
         [], 'Huynd-Feldt',roundn(ssB,-3), roundn(dfB_H,-3), roundn(msB_H,-3), roundn(fB,-3), roundn(pB_H,-3);...
         ['Error(',FACTNAMES{2} ')'],'Sphericity Assumed', roundn(ssBS,-3), roundn(dfBS,-3), roundn(msBS,-3), [], [];...
         [],'Greenhouse-Geisser', roundn(ssBS,-3), roundn(dfBS_G,-3), roundn(msBS_G,-3), [], [];...
         [],'Huynd-Feldt', roundn(ssBS,-3), roundn(dfBS_H,-3), roundn(msBS_H,-3), [], [];...
         
         
         [FACTNAMES{1} ' x ' FACTNAMES{2}], 'Sphericity Assumed', ssAB, dfAB, msAB, fAB, pAB;...
         [],'Greenhouse-Geisser', roundn(ssAB,-3), roundn(dfAB_G,-3), roundn(msAB_G,-3), roundn(fAB,-3), roundn(pAB_G,-3);...
         [], 'Huynd-Feldt', roundn(ssAB,-3), roundn(dfAB_H,-3), roundn(msAB_H,-3), roundn(fAB,-3), roundn(pAB_H,-3);...
         ['(Error(',FACTNAMES{1} ' x ' FACTNAMES{2} ')'], 'Sphericity Assumed', roundn(ssABS,-3), roundn(dfABS,-3), roundn(msABS,-3), [], [];...
         [], 'Greenhouse-Geisser', roundn(ssABS,-3), roundn(dfABS_G,-3), roundn(msABS_G,-3), [], [];...
         [], 'Huynd-Feldt', roundn(ssABS,-3), roundn(dfABS_H,-3), roundn(msABS_H,-3), [], []}
 return