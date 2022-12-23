# Introduction

We introduce here a method to calculate the distance between the gene of interest and the nearest transcription regulatory factor cluster for each transcriptional state of the target gene, and other parameters, from microscopic images obtained using the STREAMING-tag system.
These pipelines were established by Hiroaki Ohishi and Hiroshi Ochiai at Hiroshima University.


> **Note** 
> The analysis method described here uses images saved in the Nikon nd2 file format. If you wish to analyze images in a different file format, you will need to modify the code accordingly.




# Required Tools and Data

-   [Fiji] (v.2.3.0)
-   [Anaconda] (v4.13.0)
-   [VS code] (v1.69.2)
-   Script available from this github page. Download together and unzip at an arbitrary location.
-   Image files in Nikon nd2 format. 
    -   Each file contains images of three channels of SNAPtag-regulatory factor, MCP-RFP, and mTetR-GFP. See [our paper](https://www.biorxiv.org/content/10.1101/2022.01.06.472721v1.full) for imaging conditions. Test data are available from : [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.7020499.svg)](https://doi.org/10.5281/zenodo.7020499)

# Creating ROI using Fiji
1. Open Fiji.

2. Open [imagej-macro.ijm](https://github.com/Ochiai-Lab/STREAMING-tag/blob/main/imagej-macro.ijm) with Fiji. 
> **Note** 
> Lines 5\~6 may need to be changed depending on the image acquisition conditions.

3. Click on Run in the lower left corner and the following window will appear. 
  <img src="https://user-images.githubusercontent.com/111980616/186647612-b618cf36-9e70-4819-9d22-d7cde8cae79a.png" width="400px">

4. As the Input directory, specify a folder named \"nd2_files\" where nd2 files are located. As Output directory, create a folder named \"roi\" at the same level as the nd2_files folder, and specify it as the output directory. File suffix should be \".nd2\". Click OK. Multiple windows will appear.

5. First, click Synchronize All under \"Synchronize Windows\". Also, uncheck or check the boxes to match the following. 
  <img src="https://user-images.githubusercontent.com/111980616/186648227-2530fbd0-00a9-4e4a-a6c4-a83b67795287.png" width="350px">

6. The \"Merged\" and \"Stack\" images are, respectively, a continuous replay of the 10 images taken and an averaging of the 10 images; thanks to the "Synchronize Windows" tool, the cursor appears at the same XY coordinates in both images when the mouse hovers over the two images.

7. Move the cursor over the mTetR spot on the \"Stack\" image and click.
> **Note** 
> 1. If there are no mTetR spots, do nothing and click OK in the \"Action Reqired\" window.<br>
> 2. If the "Action Reqired" window is not visible, it may appear by clicking anywhere in the \"Stack\" window. If the selected mTetR spot is not the desired spot, select the ROI in the \"ROI Manager\" window and remove it with \"Delete\". <br>
> 3. If there are multiple spots, click on the mTetR spot in the \"Stack\" window while clicking the "Play" button in the lower left corner of \"Merged\" to play it.

8. After clicking all the spots, click OK in the Action Required window.

9. Repeat steps 5\~8.

# Anaconda Setup
> **Note** 
> This operation is necessary only for the first time. From the next time onward, simply start with the next section.

1. Open Anaconda Navigator.

2. Click on Environments in the upper left corner.
  <img src="https://user-images.githubusercontent.com/111980616/186648391-074e41bb-bbba-4c99-94cd-50812fcf196d.png" width="250px">

3. Click Create.

4. Enter \"STtag_analysis\" in Name.

5. Check only Python. Select the version 3.9.12. Click Create. After a few moments, the STtag_analysis environment will be created. From the next time on, simply select this environment.
  <img src="https://user-images.githubusercontent.com/111980616/186648477-7f92b007-4bd3-4e54-86ab-7cdcdd22cf56.png" width="400px">

6. Next, click the Play button on the right side of STtag_analysis and click Open Terminal. 
  <img src="https://user-images.githubusercontent.com/111980616/186648557-e9da18a8-2439-4785-8d3e-ed75df854663.png" width="400px">

7. The Terminal will then open automatically. Confirm that the left side of the window is labeled (STtag_analysis).

8. Copy and paste the following line by line in Terminal and execute.

```
pip install pims
pip install matplotlib
pip install nd2reader
pip install scikit-image
pip install trackpy
pip install read-roi
pip install seaborn
pip install statannotations
pip install statsmodels
pip install zenodo_get
```
9. Return to Home.

# Image analysis using Python
1. Open "Anaconda Navigator".

2. Select STtag_analysis from the right side of \"Applications on\". 
<img src="https://user-images.githubusercontent.com/111980616/186648673-c3ce40d8-b85c-4f71-8d3d-c084d5cbb7d1.png" width="400px">

3. Click on Lunch in "VS code".
<img src="https://user-images.githubusercontent.com/111980616/186648748-e1bbd828-ab62-4b6b-b40d-63b65d05bc7d.png" width="200px">

4. VS code will start up. Drag the Jupyter notebook file ([STtag_analysis.ipynb](https://github.com/Ochiai-Lab/STREAMING-tag/blob/main/jupyter/STtag_analysis.ipynb)) to VS code. This file is located in the "jupyter" folder in the folder downloaded from this github page. 

5. Click on the upper right corner where it says \"base(Python 3.9.12)\" or something similar and select STtag_analysis from the list of environments displayed at the top.  

6. Follow the instructions in the Jupyter notebook to proceed with the analysis.

# Citation
[Ohishi, H. *et al.* STREAMING-tag system reveals spatiotemporal relationships between transcriptional regulatory factors and transcriptional activity. *Nature Communications* 13:7672 (2022) doi:10.1038/s41467-022-35286-2](https://www.nature.com/articles/s41467-022-35286-2)

# Contact
Hiroaki Ohishi, email : hiroakioh (at) hiroshima-u dot ac dot jp  
Hiroshi Ochiai, email : ochiai (at) hiroshima-u dot ac dot jp

  [Fiji]: https://fiji.sc/
  [Anaconda]: https://www.anaconda.com/products/distribution
  [VS code]: https://code.visualstudio.com/download
