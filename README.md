# DavisGroupMatlab
MATLAB analysis suite for Davis group STM data 

Data analysis tools only, No data files should be included. 

Suggestion for importing into local machine:
1. In your prefered directory, usually documents/MATLAB, create 2 folders: "STM" and "STMdata"
2. Pull all files from here to "STM"
3. Any data files/analysis result should go to "STMdata"
4. Once downloaded, you will need to change the file path in whichever files where path error occurs.
	- suggestion: change from
```
color_map_path = 'C:\Users\chong\Documents\MATLAB\STM\MATLAB\STM View\Color Maps\';
```
to 
```matlab
color_map_path = fullfile(fileparts(mfilename('fullpath')),'..','..','\STM View\Color Maps\');
```
and also update this Github.
