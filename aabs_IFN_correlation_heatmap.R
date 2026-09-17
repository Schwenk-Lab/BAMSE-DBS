#title: "Anti-IFN prevalence correlation within sampling phases"
#author: "Simon Kebede Merid"

library(dplyr)
library(readxl)
library(gplots)
library(tidyverse)
for( i in c("Phase 1","Phase 2","Phase 3")){#"Any phase",
  AutoIFN_posvsneg <- read_excel("aab levels_binary robust z scores thr 3p5_by_phase_250930.xlsx", sheet =i)
  rownames(AutoIFN_posvsneg)<-AutoIFN_posvsneg$idnr
  
  cor_matrix <- cor(AutoIFN_posvsneg[,-c(1:3)],method = "pearson")
  
  # Heatmap with scaled legend and correlation color scale
  
  png(paste0("correlation_heatmap_robust_zscores_thr_3p5_by_phase_250930_",i,".png"), width = 3000, height = 3000, res = 600)
  
  # Create heatmap
  heatmap.2(cor_matrix,
            main = i,
            col = bluered(256),
            breaks = seq(-0.5, 1, length.out = 257),  # Force color mapping from -1 to 1
            trace = "none",
            key = TRUE,
            key.title = "Correlation",
            key.xlab = "Correlation Level",
            density.info = "none",
            scale = "none",
            cexRow =0.8, cexCol = 0.8,
            margins = c(6, 6))
  
  # Close device
  dev.off()
}