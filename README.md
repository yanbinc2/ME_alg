#==========================================================
#### ME Algorithm, 2023
#### Yan-Bin Chen (陳彥賓)  yanbin@stat.sinica.edu.tw; Chen-Hsiang Yeang (楊振翔)   chyeang@stat.sinica.edu.tw
#### Institute of Statistical Science, Academia Sinica, Taipei, Taiwan. August, 2023 
#==========================================================
#
(a) File description:
1. "phase2_generate_seedregions_package.m"

    Function: generate seed regions from the input data.

    Inputs: embeded data, region labels, several free parameters.
  
    Outputs: indices of seed regions and the valid image labels in all regions.

2. "phase3_three_predicted_results.ipynb"

   Function: generate three CNN predicted results, "orginal", "combinational" and "removal" in MATLAB format for the evaluation of four scores.

   Inputs: following files specified by the path are the input data. The files presented here are provided as examples for instructional guidance. Users can input their own data based on their specific applications.
   
       PATH1='./Data/NCT_VGG16_K200_seedinds_version2_valid.txt'  -->  This is the seed regions given by the phase 2.
  
       PATH2='./Data/NCT_VGG16_K200_bilabels_version2.txt'  --> This is the data file to indicate which labels are effective given by phase 2.
  
       PATH3='./Data/VGG16_CRC_100K_tSNE_Spec.csv'  --> This is the data file to specify the region index.
  
       PATH4='./Data/NCT_VGG16_K200_neighborregions_version2_valid.txt'  --> This is the data file to specify the neighboring regions of seed regions.
  
       PATH5='./Data/20230106_NCT_Vgg16_test_label.pickle'  --> This is the embedded data.
  
    Outputs: output three CNN predicted files for the four scores evaluation. They are "results_of_original.mat"
  "results_of_combination.mat", and "results_of_removal.mat".


3. "phase4_merge_seedregions_package.m"

    Function: merge seed regions according to the three predicted files (mat files).

    Inputs: information about regions and seed regions, prediction outcomes.

    Outputs: identities of merged seed regions.

4. "phase5_merge_then_expand.ipynb"

    Function: merges seed regions, then expands seed regions iteratively.
  
    Inputs: following files specified by the path are the input data. The files presented here are provided as examples for instructional guidance. Users can input their own data based on their specific applications. 

       PATH3='./Data/VGG16_CRC_100K_tSNE_Spec.csv'--> This is the data file to specify the region index.
  
       PATH5='./Data/20230106_NCT_Vgg16_test_label.pickle' --> This is the true labels for the accuracy evaluation.
  
       PATH6='./Data/NCT_VGG16_K200_mergedseedclasslabels_version2.txt' --> This is the merged results given by the phase 4.
  
       PATH7='./Data/region_for_phaseIV.pickle'  --> This is the file to setup the initial conditions.
  
    Outputs: output the accuracy table.

5. "CNN_Modules_1D.py" --> This is the module file (function call) for the 1D CNN.

6. "CNN_Modules.py" --> This is the module file (function call) for the 2D CNN.


#
(b) Execution procedures:
1. Run the Phase 2, which is "phase2_generate_seedregions_package.m" to generate the seed regions.
2. Run "phase3.ipynb". It outputs several immediate pickle files and three mat files. The users may ignore pickle files. Three mat files are the data prepared for the next phase 4. The three mat files are "results_of_original.mat", "results_of_combination.mat" and "results_of_removal.mat".
3. Run the Phase 4, which is  "phase4_merge_seedregions_package.m" to get merged tables.
4. Run "phase5.ipynb" to obtain the clustering results. It outputs "accu_history.csv" to evaluate the accuracy as well.
