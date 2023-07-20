# Notes for Pipeline #

This pipeline will require a lot of computational resources, utilize your University's super computer (Argon for U of Iowa).

Before running the pipeline you will need to install the following:
\n*miniconda3* version 4.11.0
\n*perlbrew* followed by *perl* version 5.16.3
*python* version 3.7.0
*metaWRAP* (.yml file included or use: https://github.com/bxlab/metaWRAP) # make a conda enviornment for *metaWRAP*
*HLAminer* (.yml file included or use: https://github.com/bcgsc/HLAminer) # make a conda environment for *HLAminer*

### metaWRAP Notes:###
You must set up the bmtagger database, none of the other databases are necessary for this analysis. 
(https://github.com/bxlab/metaWRAP/blob/master/installation/database_installation.md)

### HLAminer Notes: ###
Once these are all set up change the path names in the necessary scripts from hlaminer. This includes
your perl and bwa paths.
(.pl and .sh files in "/Users/YOURUSERNAME/HLAminer-1.4/HLAminer_v1.4/bin/" )

Also download all necessary packages (fully described on github page). This includes:
- blast
- bwa
- perl-bio-searchio-hmmer

Throughout *MetaWrap_HLAMiner_Pipeline.sh* there are notes to indicate where the user needs to change the paths/directories. 
Specifcally look for:

**## INFORMATION ABOUT PATH ##**
