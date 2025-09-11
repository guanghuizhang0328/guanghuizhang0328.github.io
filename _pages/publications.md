---
layout: archive
title: "Publications"
permalink: /publications/
author_profile: true
---
1 EEG dataset  and Matlab script code for ['Single-trial-based Temporal Principal Component Analysis on Extracting Event-related Potentials of Interest for an Individual Subject'](https://doi.org/10.1016/j.jneumeth.2022.109768)
------   

* **EEG dataset**: (a) Experimental paradigm - Within-subject design with two-factor: Valence (extreme, moderate, and neutral) x Negative-category (disgusting and fearful) and the details can be found in [(Lu et al., 2016)](https://doi.org/10.1080/17470919.2015.1120238). (b) Preprocessed EEG datasets for different participants - [Sub#1](../_publications/Zhang_et_al_2022_Sub1.rar); [Sub#2](../_publications/Zhang_et_al_2022_Sub2.rar); [Sub#3](../_publications/Zhang_et_al_2022_Sub3.rar);  [Sub#4](../_publications/Zhang_et_al_2022_Sub4.rar); [Sub#7](../_publications/Zhang_et_al_2022_Sub5.rar); [Sub#8](../_publications/Zhang_et_al_2022_Sub6.rar); [Sub#9](../_publications/Zhang_et_al_2022_Sub7.rar); [Sub#10](../_publications/Zhang_et_al_2022_Sub8.rar); [Sub#13](../_publications/Zhang_et_al_2022_Sub9.rar); [Sub#14](../_publications/Zhang_et_al_2022_Sub10.rar); [Sub#15](../_publications/Zhang_et_al_2022_Sub11.rar); [Sub#16](../_publications/Zhang_et_al_2022_Sub12.rar); 
[Sub#18](../_publications/Zhang_et_al_2022_Sub13.rar); [Sub#19](../_publications/Zhang_et_al_2022_Sub14.rar); [Sub#20](../_publications/Zhang_et_al_2022_Sub15.rar); [Sub#21](../_publications/Zhang_et_al_2022_Sub16.rar); [Sub#22](../_publications/Zhang_et_al_2022_Sub17.rar); [Sub#24](../_publications/Zhang_et_al_2022_Sub18.rar); [Sub#25](../_publications/Zhang_et_al_2022_Sub19.rar); [Sub#26](../_publications/Zhang_et_al_2022_Sub20.rar).

* **Matlab script code:** Four different techniqes are used to extract N2 of interest from 20 participants and P2 from 17 participants ([Download Matlab script codes](../_publications/Zhang_et_al_2022_within-subject PCA.rar) & [Read me](../_publications/Read me_Zhang_et_al_2022_within-subject_PCA.docx)). (a) 'Conventional time-domain analysis': P2 and N2 are quantified from preprocessed ERP data directly at group analysis; (b) 'Trial-averaged group PCA': Both ERP components are measured from the averaged ERP data of all subject simultaneously by using temporal principal component analysis and Promax rotation. 
(c) 'Single-trial-based group PCA': Both ERP components are measured from the single-trial EEG data of all subject simultaneously by using temporal principal component analysis and Promax rotation.
(d)'Within-subject PCA': Both ERP components are separately quantified from the single-trial EEG of  an individual using temporal principal component analysis and Promax rotation. 

* **Citation:**  **(a) Guanghui Zhang**, Xueyan Li, Yingzhi Lu, Timo Tiihonen, Zheng Chang, and Fengyu Cong. (2022). Single-trial-based Temporal Principal Component Analysis on Extracting Event-related Potentials of Interest for an Individual Subject.Journal of Neuroscience Method. DOI:[10.1016/j.jneumeth.2022.109768](https://doi.org/10.1016/j.jneumeth.2022.109768). **(b) Yingzhi Lu**,Yu Luo,Yi Lei,Kyle J. Jaquess,Chenglin Zhou   and Hong Li. (2016). Decomposing valence intensity effects in disgusting and fearful stimuli: an event-related potential study. Social neuroscience, 11(6), 618-626. DOI:[10.1080/17470919.2015.1120238](https://doi.org/10.1080/17470919.2015.1120238). **(c) Guanghui Zhang**, Xueyan Li, and Fengyu Cong (2020). Objective Extraction of Evoked Event-Related Oscillation from Time-Frequency Representation of Event-Related Potentials, Neural Plasticity, vol. 2020, Article ID 8841354, 20 pages. DOI:[10.1155/2020/8841354](https://doi.org/10.1155/2020/8841354). 


2 Other Matlab script codes
------   
* **Toolbox:** **Evoked ERP_ERO_v1.1**. **(a)** Author:Guanghui Zhang, and Fengyu Cong. **(b)** Introduction: This toolbox provides some advanced signal processing and analysis methods based on temporal principal component analysis (t-PCA)/morlet continuous wavelet transform to rapidly and objectively extract the event-related potential (ERP)/event-related oscillation (ERO) of interest from the averaged ERP dataset at group-level([Download toolbox: Evoked ERP ERO_V1.1](../_publications/Evoked ERP ERO_v1.1.zip) /[Download demo datasets](../_publications/Evoked ERP ERO_v1.1 Demo data.zip) / [Download codes for forming a fourth-order tensor](../_publications/Evoked ERP ERO_v1.1_Forming_fourth_order_tensor_demo data.zip)). Please add EEGLAB, for example, [eeglab14_1_2b](../_publications/eeglab14_1_2b.zip), into Matlab path before use this toolbox to process ERP signals. **(c)** Signal type for processing: The averaged signal, a fourth-order tensor, is collected from the within-subject (one-factor, two-factor, three-factor) or between-subject (two-factor, three-factor) experiment designs.  **(d)** Function: Using t-PCA and Promax rotation/continuous wavelet transform to extract the ERPs/EROs of interest from the original input/the filtered signal (FFT filter or wavelet filter), and exporting the data at the specific electrodes with the time-window of interest as an excel file, which can be imported to SPSS. **(e)** Cite this toolbox:  **Guanghui Zhang**, Xueyan Li, and Fengyu Cong. Objective Extraction of Evoked Event-Related Oscillation from Time-Frequency Representation of Event-Related Potentials, Neural Plasticity, vol. 2020, Article ID 8841354, 20 pages. DOI:[10.1155/2020/8841354](https://doi.org/10.1155/2020/8841354).


* **Principal component analysis (PCA)**: Group PCA analysis for single trial EEG data or averaged ERP data; Individual-subject PCA analysis (See 1.EEG datasets  and Matlab script codes for'Single-trial-based Temporal Principal Component Analysis on Extracting Event-related Potentials of Interest for an Individual Subject').

* **Independent component analysis (ICA)**: Applications of ICA on [low-dense](../_publications/WaveletFilter-ICA_ERP_lowDenseEEG_20160513.rar)/[high-dense](../_publications/WaveletFilter-ICA_ERP_highDenseEEG.zip) EEG data.

* **Tensor decomposition**: [Nonnegative canonical polyadic decomposition (NCPD)](../_publications/NTF_CP_ERP-Tensor-TFR_2018.rar); [Nonnegative Tucker decomposition(NTD)](../_publications/NTF_Tucker_ERP-Tensor-TFR_2018.rar).

* **Repeated  measurement analysis of variance (rm-ANOVA)**: Within-subject analysis includes [one factor](../_publications/Within-subject rm-ANOVA_one factor.zip), [two factors](../_publications/Within-subject rm-ANOVA_two factors.zip), and [three factors](../_publications/Within-subject rm-ANOVA_three factors.zip); Between-subject analysis contains [two factors](../_publications/Between-subject_twofactors.zip) and three factors (Not avaliable).

* **Time frequency analysis**: Computing time frequency representation for the signal of interest using Morlet Wavelet trasformation ([Here, the Matab Script Demo is provided for EEG signal](../_publications/Time_frequency_analysis_Matlab_Demo_code.tar)).


3 Journal  papers 
------
* [24]. **Guanghui Zhang** & Steven J. Luck. (2025).  Assessing the impact of artifact correction and artifact rejection on the performance of SVM and LDA-based decoding of EEG signals. Neuroimage. DOI:[10.1016/j.neuroimage.2025.121304](https://doi.org/10.1016/j.neuroimage.2025.121304)
  
* [23]. **Guanghui Zhang**, Carlos D. Carrasco, Kurt Winsler, Brett Bahle, Fengyu Cong, and Steven J. Luck. (2024).  Assessing the effectiveness of spatial PCA on SVM-based decoding of EEG data. Neuroimage. DOI:[10.1016/j.neuroimage.2024.120625](https://doi.org/10.1016/j.neuroimage.2024.120625)

* [22]. **Guanghui Zhang**, David R. Garrett & Steven J. Luck. (2024). Optimal Filters for ERP Research II: Recommended Settings for Seven Common ERP Components. Psychophysiology. DOI:[10.1111/psyp.14530](https://doi.org/10.1111/psyp.14530).
  
* [21]. **Guanghui Zhang**, David R. Garrett & Steven J. Luck. (2024). Optimal Filters for ERP Research I: A General Approach for Selecting Filter Settings. Psychophysiology. DOI:[10.1111/psyp.14531](https://doi.org/10.1111/psyp.14531).

* [20]. **Guanghui Zhang**, David R. Garrett, Aaron M. Simmons, John E. Kiat,  & Steven J. Luck (2024). Evaluating the Effectiveness of Artifact Correction and Rejection in Event-related Potential Research. Psychophysiology. DOI:[10.1111/psyp.14511](https://doi.org/10.1111/psyp.14511).
  
* [19]. **Guanghui Zhang** & Steven J. Luck (2023). Variations in ERP Data Quality Across Paradigms, Participants, and Scoring Procedures. Psychophysiology, DOI:[10.1111/psyp.14264](https://doi.org/10.1111/psyp.14264).

* [18]. **Guanghui Zhang**, Xueyan Li, Yingzhi Lu, Timo Tiihonen, Zheng Chang, and Fengyu Cong (2022). Single-trial-based Temporal Principal Component Analysis on Extracting Event-related Potentials of Interest for an Individual Subject.  Journal of Neuroscience Methods, 109768. DOI:[10.1016/j.jneumeth.2022.109768](https://doi.org/10.1016/j.jneumeth.2022.109768).

* [17]. **Guanghui Zhang**, Chi Zhang, Shuo Cao, Xue Xia, Xin Tan, Lichengxi Si, Chenxin Wang, Xiaochun Wang, Chenglin Zhou, Tapani Ristaniemi, and Fengyu Cong (2020). Multi-domain Features of the Non-phase-locked Component of Interest Extracted from ERP Data by Tensor Decomposition. Brain Topography, 33(1), 37-47. DOI: [10.1007/s10548-019-00750-8](https://doi.org/10.1007/s10548-019-00750-8).

* [16]. **Guanghui Zhang**, Xueyan Li, and Fengyu Cong (2020) Objective Extraction of Evoked Event-Related Oscillation from Time-Frequency Representation of Event-Related Potentials, Neural Plasticity, vol. 2020, Article ID 8841354, 20 pages. DOI:[10.1155/2020/8841354](https://doi.org/10.1155/2020/8841354)

* [15]. Liting Song, **Guanghui Zhang\*** (corresponding author),  Johanna Silvennoinen & Fengyu Cong (2025). Electroencephalographic (EEG) analysis of hue perception differences between art and non-art majors: insights from the P2 and P3 components. BMC Psychology,13,891 .  DOI:[10.1186/s40359-025-03121-0](https://doi.org/10.1186/s40359-025-03121-0).
  
* [14]. Liting Song, **Guanghui Zhang\*** (corresponding author),  Lan Ma, Johanna Silvennoinen & Fengyu Cong (2025). Comparative analysis of color emotional perception in art and non-art university students: hue, saturation, and brightness effects in the Munsell color system. BMC Psychology , 13(1), 650.  DOI:[10.1186/s40359-025-03034-y](https://doi.org/10.1186/s40359-025-03034-y).

* [13]. Liting Song, **Guanghui Zhang\*** (corresponding author), Xiaoshuang Wang, Lan Ma, Johanna Silvennoinen & Fengyu Cong (2024). Does artistic training affect color perception? A study of ERPs and EROs in experiencing colors of different brightness. Biological Psychology, 188, 108787.  DOI:[10.1016/j.biopsycho.2024.108787](https://doi.org/10.1016/j.biopsycho.2024.108787).

* [12]. Junfu Tian, **Guanghui Zhang**, Qi Zhao & Yingzhi Lu (2025). Action complexity modulates motor performance in the emotional oddball task. Journal of Neurophysiology, 133(4), 1245-1255.  DOI:[10.1152/jn.00480.2023](https://doi.org/10.1152/jn.00480.2023).
  
* [11]. Reza Mahini, **Guanghui Zhang**, Tiina Parviainen, Rainer Düsing, Asoke K. Nandi, Fengyu Cong & Timo Hämäläinen (2024). Brain Evoked Response Qualification Using Multi-set Consensus Clustering: Toward Single-trial EEG Analysis. Brain Topography, 1-23.  DOI:[10.1007/s10548-024-01074-y](https://doi.org/10.1007/s10548-024-01074-y).


* [10]. Xiaoshuang Wang, **Guanghui Zhang**, Ying Wang, Lin Yang, Zhanhua Liang & Fengyu Cong. (2022). One-Dimensional Convolutional Neural Networks Combined with Channel Selection Strategy for Seizure Prediction Using Long-Term Intracranial EEG. International Journal of Neural Systems, 32(02), 2150048.  DOI:[10.1142/S0129065721500489](https://doi.org/10.1142/S0129065721500489).

* [9]. XueyanLi, JiayiSun, HuiliWang, QianruXu, **GuanghuiZhang**, and XiaoshuangWang. (2022). Dynamic impact of intelligence on verbal-humor processing: Evidence from ERPs and EROs. Journal of Neurolinguistics, 62, 101057.  DOI:[10.1016/j.jneuroling.2022.101057](https://doi.org/10.1016/j.jneuroling.2022.101057).

* [8]. Xiawen Li, Yu Zhou, **Guanghui Zhang**, Yingzhi Lu, Chenglin Zhou, and Hongbiao Wang. (2022). Behavioral and Brain Reactivity Associated With Drug-Related and Non-Drug-Related Emotional Stimuli in Methamphetamine Addicts. Frontiers in Human Neuroscience, 16. DOI:[10.3389/fnhum.2022.894911](https://doi.org/10.3389/fnhum.2022.894911).
  
* [7]. Yingying Wang, Qingchun Ji, Rao Fu, **Guanghui Zhang**, Yingzhi Lu,  and Chenglin Zhou(2021). Hand‐related action words impair action anticipation in expert table tennis players: Behavioral and neural evidence. Psychophysiology, e13942.  DOI:[10.1111/psyp.13942](https://doi.org/10.1111/psyp.13942).

* [6]. Shuo Cao, Yanzhang Wang, Huili Wang, Hongjun Chen, **Guanghui Zhang**, and Kritikos Ada (2020). A Facilitatory Effect of Perceptual Incongruity on Target-Source Matching in Pictorial Metaphors of Chinese Advertising: EEG Evidence. Advances in Cognitive Psychology, 16(1), 1. DOI: [10.5709/acp-0279-z](https://doi.org/10.5709/acp-0279-z).

* [5]. Jiaxin Yu, Yan Wang, Jianling Yu, **Guanghui Zhang**, and Fengyu Cong (2020). Nudge for justice: An ERP investigation of default effects on trade-offs between equity and efficiency. Neuropsychologia. DOI:[10.1016/j.neuropsychologia.2020.107663](https://doi.org/10.1016/j.neuropsychologia.2020.107663).
  
* [4]. XueYan Li, HuiLi Wang, Pertti Saariluoma, **GuangHui Zhang**, YongJie Zhu, Chi Zhang，YuCong Feng，and Tapani Ristaniemi (2019). Processing Mechanism of Chinese Verbal Jokes: Evidence from ERP and Neural Oscillations. Journal of Electronic Science and Technology, 17(3), 260-277. DOI: [10.11989/JEST.1674-862X.80520017](https://doi.org/10.11989/JEST.1674-862X.80520017).

* [3]. Jiacheng Chen,Yanan Li, **Guanghui Zhang**, Xinhong Jin,Yingzhi Lua, and Chenglin Zhou (2019). Enhanced inhibitory control during re-engagement processing in badminton athletes: An event-related potential study. Journal of Sport and Health Science, 8(6), 585-594. DOI: [10.1016/j.jshs.2019.05.005](https://doi.org/10.1016/j.jshs.2019.05.005).

  
* [2]. Xiawen Li, **Guanghui Zhang**, Chenglin Zhou, and Xiaochun Wang. (2019). Negative emotional state slows down movement speed: behavioral and neural evidence. PeerJ, 7, e7591. DOI: [10.7717/peerj.7591](https://doi.org/10.7717/peerj.7591).

* [1]. Xue Xia, **Guanghui Zhang**, and Xiaochun Wang. Anger weakens behavioral inhibition selectively in contact athletes. Frontiers in Human Neuroscience 12 (2018): 463. DOI: [10.3389/fnhum.2018.00463](https://doi.org/10.3389/fnhum.2018.00463).

4 Conference papers
------
* [1]. **Guanghui Zhang**, Lili Tian, Huaming Chen, Peng Li, Tapani Ristaniemi, Huili Wang, Hong Li, Hongjun Chen, and Fengyu Cong (2018). Effect of parametric variation of center frequency and bandwidth of morlet wavelet transform on time-frequency analysis of event-related potentials. In Chinese intelligent systems conference (pp. 693-702). Springer, Singapore. DOI: [10.1007/978-981-10-6496-8_63](https://doi.org/10.1007/978-981-10-6496-8_63).

5 Manuscripts in Progress
------

* [6]. Limin Hou, **Guanghui Zhang\*** (corresponding author), Xiawen Li,  Tiina Parviainen,Fengyu Cong & Tommi Kärkkäinen. Neurocognitive Dynamics of Icon Design: EEG Evidence from Style and Activation Effects on Visual Search Efficiency.  **Submitted to International Journal of Human–Computer Interaction**.
  
* [5]. Limin Hou, **Guanghui Zhang\*** (corresponding author), Xiawen Li, Dong Tang, Tiina Parviainen,Fengyu Cong & Tommi Kärkkäinen. EEG-based analyses reveal different temporal processing patterns in aesthetic evaluation.  **Submitted to BMC Psychology**.
  
* [4]. **Guanghui Zhang\*** & Steven J. Luck. Maximizing EEG decoding for experimental designs with different numbers of trials per condition. **in preparation**.

* [3]. **Guanghui Zhang\***, Xinran Wang & Steven J. Luck. Evaluating the effects of regularization strengths and number of crossfolds on the performance of  SVM-based decoding of EEG data. **in preparation**.

* [2]. **Guanghui Zhang**, Xinran Wang, Ying Xin,Weiqi He & Wenbo Luo.  The impact of downsampling on data quality, univariate measurement and multivariate pattern analysis in event-related potential research. **Submitted to Cortex**.

* [1]. **Guanghui Zhang**, Ying Xin, Liting Song, Xinran Wang, Lihong Chen, Weiqi He & Wenbo Luo.  Temporal dynamics of perceptual integrity and semantic congruency during color-word processing: An ERP and decoding study. **Submitted to NeuroImage**.


6 Dissertation
------
* [2]. **Guanghui Zhang**, Methods to extract multi-dimensional features of event-related brain activities from EEG data, University of Jyväskylä, Finland. August 12 2021 [(Download dissertation)](https://jyx.jyu.fi/handle/123456789/76955#).

* [1]. **Feiyang Shen**, Event-related Potential Based Brain Connectivity Analysis in Hyperscanning [(Download it)](../_publications/ShenFeiYang-BachelorThesis-2021-June.pdf) (the contents are in Chinese and the PCA analysis in this thesis is based on the ERP_ERO toolbox).


