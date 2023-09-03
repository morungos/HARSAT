
# harsat

<!-- badges: start -->
[![lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental) ![build](https://github.com/osparcomm/harsat/actions/workflows/build.yml/badge.svg?branch=main)
<!-- badges: end -->

Requirements:

-	R programming language version 4.2.1
-	RStudio Integrated Development Environment version 2022.07.1 Build 554

Additional R packages to those which come with the standard RStudio installation. They have to be installed, either using the RStudio GUI or by the command install.packages e.g. `install.packages("lme4")`:

*	tidyverse version 2.0.0
* dplyr
* lubridate
* readr
* stringr
* tibble
* tidyr
* sf
*	lme4
* mgcv
*	mvtnorm
*	numDeriv
*	optimx
*	pbapply
* parallel
* flexsurv

The following R packages need to be installed to run the HELCOM example:

*	rmarkdown
*	htmlwidgets

File -> New Project in RStudio to create a new project. File -> New Project -> Version Control -> GIT -> https://github.com/osparcomm/HARSAT to clone from repository.

All example datasets can be run with the same basic directory structure. The following directories should be manually created:

- data
- R
- information
- output

The example scripts currently use subfolders within the data and output folders

- data
  - example_external_data
  - example_HELCOM
  - example_simple_OSPAR
- output
  - example_external_data
  - example_HELCOM
  - example_simple_OSPAR

but the data and the output can go anywhere.

Running the code will create a directory called `oddities` where data that might not comply with reporting requirements are posted (with warnings or errors).

## Installation

You can install the development version of harsat from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("osparcomm/HARSAT")
```

The stable version is similar:

``` r
# install.packages("devtools")
devtools::install_github("osparcomm/HARSAT@main")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(harsat)
## basic example code
```

The following figures are a bit out of date:

![Alt text](man/figures/fig1.jpg "Required Project File Structure for OSPAR dataset.")
<br/>
Figure 1. Required Project File Structure for OSPAR dataset.

![Alt text](man/figures/fig2.jpg "Required Project File Structure for HELCOM dataset.")
<br/>
Figure 2. Required Project File Structure for HELCOM dataset.


All R functions from the GitHub code repository should be moved to R, and csv files with the reference tables should go to ‘information’. 
It is recommended that the R files with examples, and the data and output directories should be in the same (project) directory e.g.
HARSAT\data
HARSAT\output
HARSAT\OSPAR 2022.r
although one can adjust that with the path argument to ctsm_read_data and ctsm.summary.table.
The ‘functions’ and ‘information’ directories can be anywhere (although it is recommended that they got to the same directory), with the function_path variable (at the top of OSPAR 2022.r) pointing to the former.
Data required for OSPAR:
 
![Alt text](man/figures/fig3.jpg "OSPAR data.")
<br/>
Figure 3. OSPAR data.

Data required for HELCOM:
 
![Alt text](man/figures/fig4.jpg "HELCOM data.") 
<br/>
Figure 4. HELCOM data.

HELCOM dataset requires additional R files to work, and different reference tables for ‘assessment criteria biota.csv’ and ‘assessment criteria sediment.csv’.
HELCOM also requires different information functions from the repository with a different version that has HELCOM specific functions (‘information functions v2_68.r’).

![Alt text](man/figures/fig5.jpg "Additional R files required for HELCOM dataset.") 
<br/>
Figure 5. Additional R files required for HELCOM dataset.

