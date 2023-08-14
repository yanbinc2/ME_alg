# ME_alg
ME algorithm for phase III and phase IV

File description:

main_iii.ipynb: main fuction for phase III

main_iv.ipynb: main fuction for phase V

CNN_Modules_1D.py:  CNN function for 1D data

CNN_Modules.py:  CNN function for 2D data

data.zip: iuput data (download from specific place https://www.dropbox.com/sh/9citjss0waz25zd/AADcjlzm-Mz4swQrMTUSyvF_a?dl=0)


Execute procedure
Phase III: 
1. Unzip file data.zip. This zip is 200m which is too large to deposit in the githup. You may download it from the specific place mentioned above.
2. Run main_iii.ipynb. The input files are in the ./data
3. It will output several immediate pickle files and three mat files, as follows. Those three mat files if for next phase IV.
   "results_of_original.mat"
   "results_of_combination.mat"
   "results_of_removal.maT"
   
Phase V: 
1. Unzip file data.zip. The same procedure with step 1 in Phase III.
2. Run main_v.ipynb. The input files are in the ./data
3. It will output accu_history.csv
