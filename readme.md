[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.22807719.svg)](https://doi.org/10.5281/zenodo.22807719)

### Molecular profiling of repeated self-sampled blood reveals dynamic immune phenotypes in young adults
<hr>

Annika Bendes<sup>#+</sup>, Sophia Björkander<sup>#+</sup>‚ Maura M. Kere<sup>+</sup>, Simon Kebede Merid<sup>+</sup>, Ashish Kumar<sup>+</sup>, Leo Dahl<sup>+</sup>, Tess D. Pottinger, Zhebin Yu, Anna Gardell, Amelie Vogt, Changil Kim, Qiang Pan-Hammarström, Anna Bergström, Inger Kull, Anne-Sophie Merritt, Sandra Ekström, Alexandra Lövquist, Ben Murrell<sup>+</sup>, Niclas Roxhed, Erik Melén<sup>$</sup>\*, and Jochen M. Schwenk<sup>$</sup>\*


This repository contains code for analysis and visualisation to accompany the publication  
_Molecular profiling of repeated self-sampled blood reveals dynamic immune phenotypes in young adults_.

<br><br>

<code>aab inf cutoff generation.qmd</code>, <code>bamse_ben_norm_IgM.Rmd</code>, <code>ben_mixmod.jl</code>, <code>julia_env.yml</code>  
Perform mixed model normalisation of serology data, with a Conda environment for Julia.

<code>BAMSE_explore_data norm.R</code>  
Normalise proteomics data using ProtPQN.

<code>bamse_vs_ukb.R</code>  
Compare protein-trait associations between this study and other studies mentioned in the article.

<code>aabs_IFN_correlation_heatmap.R</code>  
Visualise IFN AAb correlations.

<code>comp_groups.R</code>  
Perform group comparisons with statistical testing.


<hr>

<sub><sup>#</sup> contributed equally</sub>  
<sub><sup>+</sup> developed the code and software found here</sub>  
<sub><sup>$</sup> supervised jointly</sub>  
<sub>* corresponding author</sub>  