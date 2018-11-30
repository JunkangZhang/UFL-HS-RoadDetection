# UFL-HS-RoadDetection

Code for our paper 

Junkang Zhang, [Siyu Xia](http://automation.seu.edu.cn/dongnan-web/teacher/space/34), Kaiyue Lu, [Hong Pan](http://automation.seu.edu.cn/dongnan-web/teacher/space/33), [A. K. Qin](http://www.alexkaiqin.org/).  <br>
**[Robust Road Detection from a Single Image](https://doi.org/10.1109/ICPR.2016.7899743)**.  <br>
23rd International Conference on Pattern Recognition (ICPR), 2016

### Introduction

This code has been tested using Matlab 2015b in Ubuntu 14.04 64-bit. It should also work on other platforms, since it's pure Matlab code. 

### Usage

For example, to get the result on After-Rain dataset 

0. Download the dataset from [http://www.josemalvarez.net/](http://www.josemalvarez.net/) and extract it to someplace. 

1. Open `main.m`, change the *route* variable (in line 7) to the location of your dataset (where the extracted `After-Rain` folder lies). 

2. (Optional) If you are using a multi-core cpu and having sufficient memory, you can use *parfor* (in line 60) to speed up the testing process. 
 
3. Run `main.m`. The P, R, F values will be printed in the command window. The detection results are stored in the *predCell* variable. 

