bamse_vs_ukb <- function(assoc, ukb1, ukb2) {
  tot_df <- ukb1 %>% select(assay, olinkid, matches("beta|logp")) %>%
    full_join(ukb2 %>% select(assay, olinkid, matches("beta|logp")),
              relationship = "many-to-many", by = c("assay", "olinkid"))
  # To simplify the code, divide into two, convert to long format separately and merge again
  beta_df <- tot_df %>%
    select(assay, olinkid, contains("_beta")) %>%
    pivot_longer(cols = -c(assay, olinkid), names_to = "trait", values_to = "beta") %>%
    mutate(trait = str_remove(trait, "_beta"))
  logp_df <- tot_df %>%
    select(assay, olinkid, contains("_logp")) %>%
    pivot_longer(cols = -c(assay, olinkid), names_to = "trait", values_to = "logp") %>%
    mutate(trait = str_remove(trait, "_logp"))
  
  bamse_df <- assoc %>%
    filter(var != "cluster_maximum_6prot_omi") %>%
    mutate(var = case_when(var == "chc19aldy" ~ "age",
                           var == "male" ~ "sex",
                           var == "smoke_c19_3" ~ "smoking",
                           var == "BMI_c19" ~ "bmi"),
           signif_bamse = fdr_slope < 0.05) %>%
    select(assay = protein, trait = var, beta_bamse = slope, fdr_bamse = fdr_slope, signif_bamse)
  
  out_df <- beta_df %>%
    left_join(logp_df, by = c("assay", "olinkid", "trait"),
              relationship = "many-to-many") %>%
    # Number the variables for nicer axes in plot
    mutate(trait_num = as.integer(factor(trait, levels = unique(trait)))) %>%
    distinct() %>%
    group_by(assay, trait) %>% filter(logp == max(logp)) %>%
    ungroup() %>%
    rename(beta_ukb = beta, logp_ukb = logp) %>%
    mutate(signif_ukb = logp_ukb > 4.769551) %>%
    right_join(bamse_df, by = c("assay", "trait")) %>%
    filter(complete.cases(.))
  
  out_plt <- out_df %>%
    mutate(significant = case_when(signif_bamse & !signif_ukb ~ "bamse",
                                   signif_ukb & !signif_bamse ~ "ukb",
                                   signif_ukb & signif_bamse ~ "both",
                                   T ~ "none"),
           significant = factor(significant, levels = c("none", "bamse", "ukb", "both"))) %>%
    ggplot(aes(x = beta_ukb, y = beta_bamse, colour = significant)) +
    geom_hline(yintercept = 0, linetype = "dashed", colour = "grey50") +
    geom_vline(xintercept = 0, linetype = "dashed", colour = "grey50") +
    geom_point(size = 2, alpha = 0.8) +
    facet_wrap(~ trait, scales = "free") +
    scale_x_continuous(limits = ggh4x::center_limits()) +
    scale_y_continuous(limits = ggh4x::center_limits()) +
    theme_classic() +
    scale_color_manual(
      values = c("none" = "grey", 
                 "bamse" = "#FC8D62",
                 "ukb" = "#8DA0CB",
                 "both" = "#66C2A5" )  
    )
  #  scale_color_brewer( palette = "Set2")
  
  return(list(df = out_df, plot = out_plt))
}


## BAMSE vs vaccine serology:
bamse_vs_vaccserol <- function(assoc, vaccserol_df) {

  
  # To simplify the code, divide into two, convert to long format separately and merge again
  # beta_df <- tot_df %>%
  #   select(assay, olinkid, contains("_beta")) %>%
  #   pivot_longer(cols = -c(assay, olinkid), names_to = "trait", values_to = "beta") %>%
  #   mutate(trait = str_remove(trait, "_beta"))
  # logp_df <- tot_df %>%
  #   select(assay, olinkid, contains("_logp")) %>%
  #   pivot_longer(cols = -c(assay, olinkid), names_to = "trait", values_to = "logp") %>%
  #   mutate(trait = str_remove(trait, "_logp"))
  
  vaccserol_df <- vaccserol_df |>
    mutate( trait = case_when( clinvar == "age_group" ~ "age",
            T ~ clinvar),
            signif_vaccserol = fdr < 0.05)
  
  bamse_df <- assoc %>%
    filter(var != "cluster_maximum_6prot_omi") %>%
    mutate(var = case_when(var == "chc19aldy" ~ "age",
                           var == "male" ~ "sex",
                           var == "smoke_c19_3" ~ "smoking",
                           var == "BMI_c19" ~ "bmi"),
           signif_bamse = fdr_slope < 0.05) %>%
    select(assay = protein, trait = var, beta_bamse = slope, fdr_bamse = fdr_slope, signif_bamse)
  
  # out_df <- beta_df %>%
  #   left_join(logp_df, by = c("assay", "olinkid", "trait"),
  #             relationship = "many-to-many") %>%
  #   # Number the variables for nicer axes in plot
  #   mutate(trait_num = as.integer(factor(trait, levels = unique(trait)))) %>%
  #   distinct() %>%
  #   group_by(assay, trait) %>% filter(logp == max(logp)) %>%
  #   ungroup() %>%
  #   rename(beta_ukb = beta, logp_ukb = logp) %>%
  #   mutate(signif_ukb = logp_ukb > 4.769551) %>%
  out_df <- vaccserol_df |>
    right_join(bamse_df, by = c("protein" = "assay", "trait" = "trait")) %>%
    filter(complete.cases(.))
  
  out_plt <- out_df %>%
    mutate(significant = case_when(signif_bamse & !signif_vaccserol ~ "bamse",
                                   signif_vaccserol & !signif_bamse ~ "vaccserol",
                                   signif_vaccserol & signif_bamse ~ "both",
                                   T ~ "none"),
           significant = factor(significant, levels = c("none", "bamse", "vaccserol", "both"))) %>%
    ggplot(aes(x = estimate, y = beta_bamse, colour = significant)) +
    geom_hline(yintercept = 0, linetype = "dashed", colour = "grey50") +
    geom_vline(xintercept = 0, linetype = "dashed", colour = "grey50") +
    geom_point(size = 2, alpha = 0.8) +
    facet_wrap(~ trait, scales = "free") +
    scale_x_continuous(limits = ggh4x::center_limits()) +
    scale_y_continuous(limits = ggh4x::center_limits()) +
    theme_classic() +
    scale_color_manual(
      values = c("none" = "grey", 
                 "bamse" = "#FC8D62",
                 "vaccserol" = "#8DA0CB",
                 "both" = "#66C2A5" )  
    )
  #  scale_color_brewer( palette = "Set2")
  
  return(list(df = out_df, plot = out_plt))
}