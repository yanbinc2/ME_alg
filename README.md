#==========================================================
#### ME Algorithm, 2023
#### Yan-Bin Chen (陳彥賓)  yanbin@stat.sinica.edu.tw; Chen-Hsiang Yeang   chyeang@stat.sinica.edu.tw
#### Institute of Statistical Science, Academia Sinica, Taipei, Taiwan. August, 2023 
#==========================================================
#
(a) File description:
1. "main_phase3.ipynb"

   Function: The main fuction for the phase 3 of ME algorithm.

   Input: Following files specified by the path are the input data. These files are the examples. The users may have their own input data. 
   
       PATH1='./Data/NCT_VGG16_K200_seedinds_version2_valid.txt'  -->  This is the seed regions given by the phase 2.
  
       PATH2='./Data/NCT_VGG16_K200_bilabels_version2.txt'  --> This is the file given by phase 2 to indicate which labels are effective.
  
       PATH3='./Data/VGG16_CRC_100K_tSNE_Spec.csv'  --> To specify the region index.
  
       PATH4='./Data/NCT_VGG16_K200_neighborregions_version2_valid.txt'  --> To specify the neighborregions of seed regions.
  
       PATH5='./Data/20230106_NCT_Vgg16_test_label.pickle'  --> This is the embedded data.
  
    Output: It will output three files for the 4 scores in the phase 4. They are "results_of_original.mat"
  "results_of_combination.mat", and "results_of_removal.mat".


2. "main_phase5.ipynb"

    Function: The main fuction for phase 5 of the ME algorithm.
  
    Input: Following files specified by the path are the input data. These files are the examples. The users may have their own input data. 

       PATH3='./Data/VGG16_CRC_100K_tSNE_Spec.csv'--> To specify the region index.
  
       PATH5='./Data/20230106_NCT_Vgg16_test_label.pickle' --> This is the true lables for the accuracy evaluation.
  
       PATH6='./Data/NCT_VGG16_K200_mergedseedclasslabels_version2.txt' --> This is the merged results given by the phase 4.
  
       PATH7='./Data/region_for_phaseIV.pickle'  --> Initial conditions.
  
    Output: It will output accuracy table.

3. "CNN_Modules_1D.py" --> This is the module file (function call) for the 1D CNN.

5. "CNN_Modules.py" --> This is the module file (function call) for the 2D CNN.


#
(b) Execution procedures:
1. Run the Phase 2, which is "generate_seedregions_package.m" to generate the seed regions.
2. Run "main_phase3.ipynb" to get 4 scores. It will output several immediate pickle files and three mat files. Three mat files are the inputs for next phase 4, which are "results_of_original.mat", "results_of_combination.mat" and "results_of_removal.mat".
3. Run the Phase 4, which is  "merge_seedregions_package.m" to get merged tables.
4. Run "main_phase5.ipynb" to obtain the cluster reults. It will output "accu_history.csv".

