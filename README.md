#==========================================================
#### ME Algorithm, 2023
#### Yan-Bin Chen (陳彥賓)  yanbin@stat.sinica.edu.tw; Chen-Hsiang Yeang   chyeang@stat.sinica.edu.tw
#### Institute of Statistical Science, Academia Sinica, Taipei, Taiwan. August, 2023 
#==========================================================
#
(a) File description:
1. main_phase3.ipynb: 
  function:　The main fuction for the phase 3 of ME algorithm.
  
  Input: Following files specified by the path are the input data.
  PATH1='./Data/NCT_VGG16_K200_seedinds_version2_valid.txt'  -->  This is the seed regions given by the phase 2.
  PATH2='./Data/NCT_VGG16_K200_bilabels_version2.txt'  --> This is the file given by phase 2 to indicate which labels are effective.
  PATH3='./Data/VGG16_CRC_100K_tSNE_Spec.csv'  --> To specify the region index
  PATH4='./Data/NCT_VGG16_K200_neighborregions_version2_valid.txt'  --> To specify the neighborregions of seed regions
  PATH5='./Data/20230106_NCT_Vgg16_test_label.pickle'  --> embedded data
  
  Output: It will output three files for the 4 scores in the phase 4.
  "results_of_original.mat"
  "results_of_combination.mat"
  "results_of_removal.mat"


2. main_phase5.ipynb:
  function:  The main fuction for phase 5 of the ME algorithm.
  
  Input: Following files specified by the path are the input data.
  PATH3='./Data/VGG16_CRC_100K_tSNE_Spec.csv'--> To specify the region index
  PATH5='./Data/20230106_NCT_Vgg16_test_label.pickle' --> True lables for the accuracy evaluation.
  PATH6='./Data/NCT_VGG16_K200_mergedseedclasslabels_version2.txt' --> The merged results given by the phase 4
  PATH7='./Data/region_for_phaseIV.pickle'  --> Initial conditions

  Output: It will output accuracy table.


3. CNN_Modules_1D.py:
function: This is the function for the 1D CNN.

4. CNN_Modules.py:
function: This is the function for the 1D CNN.


#
(b) Execution procedures:
#
1. Download an example from following address to get "Example_input_data.zip". All input files are stored in the folder "/Data" in this zip file.
https://www.dropbox.com/sh/9citjss0waz25zd/AADcjlzm-Mz4swQrMTUSyvF_a?dl=0
2. Run the Phase 2, which is "generate_seedregions_package.m" 
3. Run "main_phase3.ipynb" to get 4 scores. Their input files are in the "./Data". It will output several immediate pickle files and three mat files, as follows. Those three mat files are for next phase 4.
   "results_of_original.mat"
   "results_of_combination.mat"
   "results_of_removal.mat"
4. Run "merge_seedregions_package.m" to get merged tables. This is the phase 4 of ME algorithm..
5. Run "main_phase5.ipynb" to obtain the cluster reults. The input files are in the "./Data". This file will output "accu_history.csv"

