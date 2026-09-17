#                           BAMSE - Olink data and normalization
#
# description:  Olink Explore data and protPQN norm


# required_packages: tidyverse, reshape2, scales

library(OlinkAnalyze)
library(tidyverse)
library(ProtPQN)

# Function for reading Olink Explore data:

load_data <- function(data_file, extra_sinfo) {
  long_file <- read_NPX(data_file) %>% rename_with(.fn = function(x) {
    x %>% tolower() %>% str_replace_all(" ", "_")
  })  %>%
    dplyr::mutate(panel_short = substr(panel, 1,3) %>% toupper())
  
    # Use the unique assay name column for analysis, but keep the old one in the data
    #dplyr::rename(assay_short = assay) %>%
    #mutate(assay = paste0(assay_short, ".", panel_short))
 
  # Binders with just NA (labelled "EXCLUDED") to be excluded
  excl_assays <- long_file %>% filter(assay_warning == "EXCLUDED") %>% distinct(assay) %>% pull(assay)
  
  # Make wide files to take less space
  npx <- long_file %>%
    select(sampleid, assay, npx) %>%
    pivot_wider(id_cols = sampleid, names_from = assay, values_from = npx) %>%
    select(-!!excl_assays)
  
  binfo <- long_file %>%
    select(assay, uniprot, olinkid, panel, panel_short, plateid, lod, missingfreq, normalization) %>% #assay_short
    distinct() %>% mutate(missingfreq = as.numeric(missingfreq))
  
  # Check if any sample type column and keep if yes
  if ("sample_type" %in% colnames(long_file))
  {sinfo_cols <- c("sampleid", "sample_type", "index", "plateid")} else
  {sinfo_cols <- c("sampleid", "index", "plateid")}
  
  sinfo <- long_file %>%
    select(!!sinfo_cols) %>%
    distinct() %>%
    # Bind together rows with same sample id but different plate id
    dplyr::group_by(across(all_of(sinfo_cols[!sinfo_cols == "plateid"]))) %>%
    dplyr::summarise(plateid = paste0(plateid, collapse = ";"), .groups = "keep") %>%
    ungroup()
  
  # Read extra sample info, if any
  #if (!is.null(extra_sinfo)) {
  #  # Set locale to use "," as decimal mark, ensure that sampleid is a character vector
  #  extra_sinfo <- read_delim(extra_sinfo, delim = "," )#, locale = locale(decimal_mark = "."))
  #  sinfo <- left_join(sinfo, extra_sinfo, by = "sampleid")
  #}
  
  # QC warnings column seems to sometimes refer to samples and sometimes to proteins, needs to be its own data frame
  qc_warnings <- long_file %>% select(sampleid, assay, qc_warning, assay_warning)
  
  out_list <- list("npx" = npx, "binfo" = binfo, "sinfo" = sinfo, "qc_warnings" = qc_warnings, "long_data" = long_file)
  return(out_list)
}

d_bamse_in <-  load_data("bamse_olink_explore_data.csv", "bamse_sampleid_key.csv")

################              ProtPQN normalize:
data_frame <- d_bamse_in

# Remove olink controls, blanks and pool samples and rename columns to make it compatible with protpqn function
protein_data_long <- data_frame$long_data |>
filter(!grepl("Blank|SC1|SC2|-P0|P24-01", sampleid)) |>
  mutate( sample_id = sampleid,
          protein = assay,
          value = npx,
          kit = panel)
  

normalized_data_long <- apply_protpqn(protein_data_long,
                                      transform = TRUE,
                                      kitwise = TRUE,
                                      long_format = TRUE)


olink_bamse_protpqn_blank_rm_intnorm <- normalized_data_long |> select(protein, sample_id, value) |>
  pivot_wider( names_from = protein, values_from = value)
