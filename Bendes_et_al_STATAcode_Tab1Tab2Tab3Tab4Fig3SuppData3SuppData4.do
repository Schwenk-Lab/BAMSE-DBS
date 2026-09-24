set maxvar 10000

do "Data\BAMSE_upto24.do"

merge 1:1 idnr using "Projekt\C19 Data\Del 2\Prel data\Checklista\checklistac19.dta"
drop _merge

merge 1:1 idnr using "Projekt\C19 Blodprov\Blodstatus\blodstatus_c19.dta"
drop _merge

merge 1:1 idnr using "Projekt\Bioimpedans\C19\bioimpedans_c19.dta"
drop _merge

merge 1:1 idnr using "Projekt\C19 Data\Del 1\Prel data\enkatc19_1.dta"
drop _merge

merge 1:1 idnr using "Projekt\C19 Data\Del 2\Prel data\enkatc19_2.dta"
drop _merge

merge 1:1 idnr using "Projekt\C19 Data\Del 3\Prel data\enkatc19_3.dta"
drop _merge

merge 1:1 idnr using "Projekt\C19 Data\Sminet\Dataset utan dubletter\BAMSE_SMINET_idnr_20220225_earliest_case_only.dta"
drop _merge

merge 1:1 idnr using "Projekt\C19 Blodprov\C19_hemprov_datum_corr.dta"
drop _merge

merge 1:1 idnr using "Projekt\C19 Blodprov\BAMSE C19 SARS-CoV-2 IgG.dta"
drop _merge

merge 1:1 idnr using "Projekt\C19 Vaccinationsregistret\Vaccinationsregistret_BAMSE_230215_2.dta"
drop _merge

merge 1:1 idnr using "Projects\BAMSE Olink 384\serology_cluster_p1_20250505.dta"
drop _merge

merge 1:1 idnr using "Projects\BAMSE Olink 384\serology_cluster_p2_20250505.dta"
drop _merge

merge 1:1 idnr using "Projects\BAMSE Olink 384\serology_cluster_p3_20250505.dta"
drop _merge

merge 1:1 idnr using "Projects\BAMSE Olink 384\DBS serology phase1.dta"
drop _merge

merge 1:1 idnr using "Projects\BAMSE Olink 384\DBS serology phase2.dta"
drop _merge

merge 1:1 idnr using "Projects\BAMSE Olink 384\DBS serology phase3.dta"
drop _merge

merge 1:1 idnr using "Projects\BAMSE Olink 384\AutoIFN ver2\autoIFN_p1_robz_T3_cat.dta"
drop _merge

merge 1:1 idnr using "Projects\BAMSE Olink 384\AutoIFN ver2\autoIFN_p2_robz_T3_cat.dta"
drop _merge

merge 1:1 idnr using "Projects\BAMSE Olink 384\AutoIFN ver2\autoIFN_p3_robz_T3_cat.dta"
drop _merge

merge 1:1 idnr using "Projects\BAMSE Olink 384\pF8S_data.dta"
drop _merge
//_______________________________________________________________

//Subject groupings
gen C19_p1_status=.
replace C19_p1_status=1 if qc19_1ifdat!=.

gen C19_p2_status=.
replace C19_p2_status=1 if qc19_2ifdat!=.

gen C19_p3_status=.
replace C19_p3_status=1 if qc19_3ifdat!=.

gen serology_long=.
replace serology_long=1 if phase1_DBSserology==1 & phase2_DBSserology==1 & phase3_DBSserology==1 

gen total_pop=.
replace total_pop=1 if phase1_DBSserology==1 | phase2_DBSserology==1 | phase3_DBSserology==1

//Covid19-follow up clinical examination

*Error in bloodstatuas data in dta on BAMSE-server, -9002 values should be zero
replace eosgran_c19=0 if eosgran_c19==-9002
replace basgran_c19=0 if basgran_c19==-9002

*BMI cat C19 phase 2
gen bmi_c19_cat=.
replace bmi_c19_cat=1 if bmi_bia_c19 <25.0
replace bmi_c19_cat=2 if bmi_bia_c19 >=25.0
replace bmi_c19_cat=. if bmi_bia_c19==.
label define bmi_c19_catlabel 1 "normal" 2 "over"
label values bmi_c19_cat bmi_c19_catlabel

//Covid19-follow up questionnaires
*categorize any self-reported symptoms phase 3
gen qc19_3q1_1_cat=.
replace qc19_3q1_1_cat=0 if qc19_3q1_1==3
replace qc19_3q1_1_cat=1 if qc19_3q1_1==1 | qc19_3q1_1==2

*Symptoms 2 months or more phase 1
gen symptoms_p1_8wormore=.
replace symptoms_p1_8wormore=1 if qc19_1q4==1 | qc19_1q4==2 | qc19_1q4==3 | qc19_1q4==4 | qc19_1q4==5 | qc19_1q4==6
replace symptoms_p1_8wormore=2 if qc19_1q4==7
 label define symptoms_p1_8wormorelabel 1 "less8w" 2 "8wormore"
label values symptoms_p1_8wormore symptoms_p1_8wormorelabel

*Symptoms 2 months or more phase 2
gen symptoms_p2_8wormore=.
replace symptoms_p2_8wormore=1 if qc19_2q4==1 | qc19_2q4==2 | qc19_2q4==3 | qc19_2q4==4 | qc19_2q4==5 | qc19_2q4==6
replace symptoms_p2_8wormore=2 if qc19_2q4==7
 label define symptoms_p2_8wormorelabel 1 "less8w" 2 "8wormore"
label values symptoms_p2_8wormore symptoms_p2_8wormorelabel

*Symptoms 2 months or more phase 3
gen symptoms_2months_q3=.
replace symptoms_2months_q3=1 if qc19_3q14==1 | (qc19_3q14==2 & (qc19_3q15_1==1 | qc19_3q15_1==2 | qc19_3q15_1==. | qc19_3q15_2==1 | qc19_3q15_2==2 | qc19_3q15_2==. | qc19_3q15_3==1 | qc19_3q15_3==2 | qc19_3q15_3==. | qc19_3q15_4==1 | qc19_3q15_4==2 | qc19_3q15_4==. | qc19_3q15_5==1 | qc19_3q15_5==2 | qc19_3q15_5==. | qc19_3q15_6==1 | qc19_3q15_6==2 | qc19_3q15_6==. | qc19_3q15_7==1 | qc19_3q15_7==2 | qc19_3q15_7==. | qc19_3q15_8==1 | qc19_3q15_8==2 | qc19_3q15_8==. | qc19_3q15_9==1 | qc19_3q15_9==2 | qc19_3q15_9==. | qc19_3q15_10==1 | qc19_3q15_10==2 | qc19_3q15_10==. | qc19_3q15_11==1 | qc19_3q15_11==2 | qc19_3q15_10==. | qc19_3q15_12==1 | qc19_3q15_12==2 | qc19_3q15_12==. | qc19_3q15_13==1 | qc19_3q15_13==2 | qc19_3q15_13==.))
replace symptoms_2months_q3=2 if qc19_3q14==2 & (qc19_3q15_1==3 | qc19_3q15_1==4 | qc19_3q15_2==3 | qc19_3q15_2==4 | qc19_3q15_3==3 | qc19_3q15_3==4 | qc19_3q15_4==3 | qc19_3q15_4==4 | qc19_3q15_5==3 | qc19_3q15_5==4 | qc19_3q15_6==3 | qc19_3q15_6==4 | qc19_3q15_7==3 | qc19_3q15_7==4 | qc19_3q15_8==3 | qc19_3q15_8==4 | qc19_3q15_9==3 | qc19_3q15_9==4 | qc19_3q15_10==3 | qc19_3q15_10==4 | qc19_3q15_11==3 | qc19_3q15_11==4 | qc19_3q15_12==3 | qc19_3q15_12==4 | qc19_3q15_13==3 | qc19_3q15_13==4)

*Symptoms 3 months or more phase 3
gen symptoms_3months_q3=.
replace symptoms_3months_q3=1 if qc19_3q14==1 | (qc19_3q14==2 & (qc19_3q15_1==1 | qc19_3q15_1==2 | qc19_3q15_1==3 | qc19_3q15_1==. | qc19_3q15_2==1 | qc19_3q15_2==2 | qc19_3q15_2==3 | qc19_3q15_2==. | qc19_3q15_3==1 | qc19_3q15_3==2 | qc19_3q15_3==3 | qc19_3q15_3==. | qc19_3q15_4==1 | qc19_3q15_4==2 | qc19_3q15_4==3 | qc19_3q15_4==. | qc19_3q15_5==1 | qc19_3q15_5==2 | qc19_3q15_5==3 | qc19_3q15_5==. | qc19_3q15_6==1 | qc19_3q15_6==2 | qc19_3q15_6==3 | qc19_3q15_6==. | qc19_3q15_7==1 | qc19_3q15_7==2 | qc19_3q15_7==3 | qc19_3q15_7==. | qc19_3q15_8==1 | qc19_3q15_8==2 | qc19_3q15_8==3 | qc19_3q15_8==. | qc19_3q15_9==1 | qc19_3q15_9==2 | qc19_3q15_9==3 | qc19_3q15_9==. | qc19_3q15_10==1 | qc19_3q15_10==2 | qc19_3q15_10==3 | qc19_3q15_10==. | qc19_3q15_11==1 | qc19_3q15_11==2 | qc19_3q15_11==3 | qc19_3q15_11==. | qc19_3q15_12==1 | qc19_3q15_12==2 | qc19_3q15_12==3 | qc19_3q15_12==. | qc19_3q15_13==1 | qc19_3q15_13==2 | qc19_3q15_13==3 | qc19_3q15_13==.))
replace symptoms_3months_q3=2 if qc19_3q14==2 & (qc19_3q15_1==4 | qc19_3q15_2==4 |qc19_3q15_3==4 | qc19_3q15_4==4 | qc19_3q15_5==4 | qc19_3q15_6==4 | qc19_3q15_7==4 | qc19_3q15_8==4 | qc19_3q15_9==4 |qc19_3q15_10==4 | qc19_3q15_11==4 | qc19_3q15_12==4 | qc19_3q15_13==4)

//C19 vaccination data

*categorical variable of first dose
gen vaccinated=.
replace vaccinated=0 if date1==.
replace vaccinated=1 if date1!=.

gen date_num_del1 = date(C19_Del1_hemprov_datum, "YMD")
gen date_num_del3 = date(C19_Del3_hemprov_datum, "YMD")

format date_num_del1 %td
format date_num_del3 %td

gen vaccinated_p1=.
replace vaccinated_p1=0 if (date1 > date_num_del1) | (date1==date_num_del1) | (date1==. & date_num_del1!=.)
replace vaccinated_p1=1 if (date1 < date_num_del1) & date_num_del1!=.
replace vaccinated_p1=. if date1==. & date_num_del1==.

gen vaccinated_p2=.
replace vaccinated_p2=0 if (date1 > chc19usd) | (date1==chc19usd) | (date1==. & chc19usd!=.)
replace vaccinated_p2=1 if (date1 < chc19usd) & chc19usd!=.
replace vaccinated_p2=. if date1==. & chc19usd==.

gen vaccinated_p2_1dose=.
replace vaccinated_p2_1dose=0 if (date1 > chc19usd) | (date1==chc19usd) | (date1==. & chc19usd!=.) 
replace vaccinated_p2_1dose=1 if (date1 < chc19usd) & chc19usd!=. & ((date2 > chc19usd) | (date2 == chc19usd))
replace vaccinated_p2_1dose=. if date1==. & chc19usd==.

gen vaccinated_p2_2doses=.
replace vaccinated_p2_2doses=0 if (date2 > chc19usd) | (date2==chc19usd) | (date2==. & chc19usd!=.)
replace vaccinated_p2_2doses=1 if (date2 < chc19usd) & chc19usd!=.
replace vaccinated_p2_2doses=. if date2==. & chc19usd==.

gen vaccinated_p2_total=.
replace vaccinated_p2_total=1 if (date1 > chc19usd) | (date1==chc19usd) | (date1==. & chc19usd!=.)
replace vaccinated_p2_total=2 if (date1 < chc19usd) & chc19usd!=. & ((date2 > chc19usd) | (date2 == chc19usd))
replace vaccinated_p2_total=3 if (date2 < chc19usd) & chc19usd!=.
replace vaccinated_p2_total=. if date1==. & date2==. & chc19usd==.
label define vaccinated_p2_total 1 "unvacc" 2 "1dose" 3 "2doses"
label values vaccinated_p2_total vaccinated_p2_totallabel

gen days_vacc1_p2=.
replace days_vacc1_p2=chc19usd-date1

gen days_vacc2_p2=.
replace days_vacc2_p2=chc19usd-date2

gen vaccinated_p3=.
replace vaccinated_p3=0 if (date1 > date_num_del3) | (date1==date_num_del3) | (date1==. & date_num_del3!=.)
replace vaccinated_p3=1 if (date1 < date_num_del3) & date_num_del3!=.
replace vaccinated_p3=. if date1==. & date_num_del3==.

gen vaccinated_p3_1dose=.
replace vaccinated_p3_1dose=0 if (date1 > date_num_del3) | (date1==date_num_del3) | (date1==. & date_num_del3!=.)
replace vaccinated_p3_1dose=1 if (date1 < date_num_del3) & date_num_del3!=. & ((date2 > date_num_del3) | (date2 == date_num_del3))
replace vaccinated_p3_1dose=. if date1==. & date_num_del3==.

gen vaccinated_p3_2doses=.
replace vaccinated_p3_2doses=0 if (date2 > date_num_del3) | (date2==date_num_del3) | (date2==. & date_num_del3!=.)
replace vaccinated_p3_2doses=1 if (date2 < date_num_del3) & date_num_del3!=. & ((date3 > date_num_del3) | (date3 == date_num_del3))
replace vaccinated_p3_2doses=. if date2==. & date_num_del3==.

gen vaccinated_p3_3doses=.
replace vaccinated_p3_3doses=0 if (date3 > date_num_del3) | (date3==date_num_del3) | (date3==. & date_num_del3!=.)
replace vaccinated_p3_3doses=1 if (date3 < date_num_del3) & date_num_del3!=.
replace vaccinated_p3_3doses=. if date3==. & date_num_del3==.

gen vaccinated_p3_total=.
replace vaccinated_p3_total=1 if (date1 > date_num_del3) | (date1==date_num_del3) | (date1==. & date_num_del3!=.)
replace vaccinated_p3_total=2 if (date1 < date_num_del3) & date_num_del3!=. & ((date2 > date_num_del3) | (date2 == date_num_del3))
replace vaccinated_p3_total=3 if (date2 < date_num_del3) & date_num_del3!=. & ((date3 > date_num_del3) | (date3 == date_num_del3))
replace vaccinated_p3_total=4 if (date3 < date_num_del3) & date_num_del3!=.
replace vaccinated_p3_total=. if date1==. & date2==. & date3==. & date_num_del3==.
label define vaccinated_p3_total 1 "unvacc" 2 "1dose" 3 "2doses" 4 "3doses"
label values vaccinated_p3_total vaccinated_p3_totallabel

gen days_vacc1_p3=.
replace days_vacc1_p3=date_num_del3-date1

gen days_vacc2_p3=.
replace days_vacc2_p3=date_num_del3-date2

gen days_vacc3_p3=.
replace days_vacc3_p3=date_num_del3-date3

//SmiNet data

gen date_sminet = date(provtagningsdatum, "YMD")
format date_sminet %td

//14 individuals lack date for testing (provtagningsdatum) in the SmiNet registry data, but have date of entry (statistikdatum), therefore I generate a second SminNet date variable for these 14 individuals
gen date_sminet_2 = date(statistikdatum, "YMD") if idnr==918 | idnr==1491 | idnr==2489 | idnr==2677 | idnr==2957 | idnr==5432 | idnr==4343 | idnr==1722 | idnr==2444 | idnr==2754 | idnr==3858 | idnr==4605 | idnr==5397 | idnr==5821
format date_sminet_2 %td

gen sminet_case_p1DBS=.
replace sminet_case_p1DBS=0 if date_num_del1!=. & (sminet_case==0 | (sminet_case==1 & date_sminet > date_num_del1) | (sminet_case==1 & date_sminet_2 > date_num_del1) )
replace sminet_case_p1DBS=1 if sminet_case==1 & (date_sminet < date_num_del1 | date_sminet_2 < date_num_del1) & date_num_del1!=.

gen sminet_case_p2DBS=.
replace sminet_case_p2DBS=0 if chc19usd!=. & (sminet_case==0 | (sminet_case==1 & date_sminet > chc19usd) | (sminet_case==1 & date_sminet_2 > chc19usd) )
replace sminet_case_p2DBS=1 if sminet_case==1 & (date_sminet < chc19usd | date_sminet_2 < chc19usd) & chc19usd!=.

gen new_sminet_case_p2DBS=.
replace new_sminet_case_p2DBS=0 if sminet_case_p2DBS==0 | (sminet_case_p2DBS==1 & sminet_case_p1DBS==1)
replace new_sminet_case_p2DBS=1 if sminet_case_p2DBS==1 & sminet_case_p1DBS==0

gen sminet_case_p3DBS=.
replace sminet_case_p3DBS=0 if date_num_del3!=. & (sminet_case==0 | (sminet_case==1 & date_sminet > date_num_del3) | (sminet_case==1 & date_sminet_2 > date_num_del3) )
replace sminet_case_p3DBS=1 if sminet_case==1 & (date_sminet < date_num_del3 | date_sminet_2 < date_num_del3 ) & date_num_del3!=.

gen new_sminet_case_p3DBS=.
replace new_sminet_case_p3DBS=0 if sminet_case_p3DBS==0 | (sminet_case_p3DBS==1 & (sminet_case_p1DBS==1 | sminet_case_p2DBS==1)) 
replace new_sminet_case_p3DBS=1 if sminet_case_p3DBS==1 & sminet_case_p1DBS==0 & sminet_case_p2DBS==0

gen days_sminet_p1=.
replace days_sminet_p1=(date_num_del1-date_sminet)
replace days_sminet_p1=(date_num_del1-date_sminet_2) if idnr==918 | idnr==1491 | idnr==2489 | idnr==2677 | idnr==2957 | idnr==5432 | idnr==4343 | idnr==1722 | idnr==2444 | idnr==2754 | idnr==3858 | idnr==4605 | idnr==5397 | idnr==5821 

gen days_sminet_p2=.
replace days_sminet_p2=(chc19usd-date_sminet)
replace days_sminet_p2=(chc19usd-date_sminet_2) if idnr==918 | idnr==1491 | idnr==2489 | idnr==2677 | idnr==2957 | idnr==5432 | idnr==4343 | idnr==1722 | idnr==2444 | idnr==2754 | idnr==3858 | idnr==4605 | idnr==5397 | idnr==5821 

gen days_sminet_p3=.
replace days_sminet_p3=(date_num_del3-date_sminet)
replace days_sminet_p3=(date_num_del3-date_sminet_2) if idnr==918 | idnr==1491 | idnr==2489 | idnr==2677 | idnr==2957 | idnr==5432 | idnr==4343 | idnr==1722 | idnr==2444 | idnr==2754 | idnr==3858 | idnr==4605 | idnr==5397 | idnr==5821

//SARS-CoV2 serology data from the Karolinska University Laboratory
encode Analysresultat, gen (KUL_num)
replace KUL_num=0 if KUL_num==1 | KUL_num==2
replace KUL_num=1 if KUL_num==3
label define KUL_numlabel 0 "negative" 1 "positive"
label values KUL_num KUL_numlabel

//Smoking status
*Phase 1
gen smokeC191_2=.
replace smokeC191_2=1 if qc19_1q42==1 | qc19_1q42==2
replace smokeC191_2=2 if qc19_1q42==3 | qc19_1q42==4
replace smokeC191_2=. if qc19_1q42==.
label define smokeC191_2label 1 "No" 2 "Yes"
label values smokeC191_2 smokeC191_2label
*Phase 2
gen smokeC192_2=.
replace smokeC192_2=1 if qc19_2q39==1 | qc19_2q39==2
replace smokeC192_2=2 if qc19_2q39==3 | qc19_2q39==4
replace smokeC192_2=. if qc19_2q39==.
label define smokeC192_2label 1 "No" 2 "Yes"
label values smokeC192_2 smokeC192_2label
*Phase 3
gen smokeC193_2=.
replace smokeC193_2=1 if qc19_3q40==1 | qc19_3q40==2
replace smokeC193_2=2 if qc19_3q40==3 | qc19_3q40==4
replace smokeC193_2=. if qc19_3q40==.
label define smokeC193_2label 1 "No" 2 "Yes"
label values smokeC193_2 smokeC193_2label

//Self-reported positive antibody- or PCR-tests phase 1
*Phase 1
gen PCRself_p1=.
replace PCRself_p1=1 if qc19_1q13==1
replace PCRself_p1=0 if (qc19_1ifdat!=. & qc19_1q13==.) | qc19_1q13==2

gen ABself_p1=.
replace ABself_p1=1 if qc19_1q11==1
replace ABself_p1=0 if (qc19_1ifdat!=. & qc19_1q11==.) | qc19_1q11==2

gen PCRABself_p1=.
replace PCRABself_p1=1 if qc19_1q13==1 | qc19_1q11==1
replace PCRABself_p1=0 if (qc19_1ifdat!=. & qc19_1q13==. & qc19_1q11==.) | (qc19_1q13==2 & qc19_1q11==2) | (qc19_1q13==2 & qc19_1q11==.) | (qc19_1q13==. & qc19_1q11==2)

*Phase 2
gen PCRself_p2=.
replace PCRself_p2=1 if qc19_2q15==1
replace PCRself_p2=0 if (qc19_2ifdat!=. & qc19_2q15==.) | qc19_2q15==2

gen ABself_p2=.
replace ABself_p2=1 if qc19_2q12==1
replace ABself_p2=0 if (qc19_2ifdat!=. & qc19_2q12==.) | qc19_2q12==2

gen PCRABself_p2=.
replace PCRABself_p2=1 if qc19_2q15==1 | qc19_2q12==1
replace PCRABself_p2=0 if (qc19_2ifdat!=. & qc19_2q15==. & qc19_2q12==.) | (qc19_2q15==2 & qc19_2q12==2) | (qc19_2q15==2 & qc19_2q12==.) | (qc19_2q15==. & qc19_2q12==2)

*Phase 3/ever
gen PCR_ever=.
replace PCR_ever=0 if qc19_3q1_2==3 | qc19_3q1_2==4
replace PCR_ever=1 if qc19_3q1_2==1 | qc19_3q1_2==2

gen AB_ever=.
replace AB_ever=0 if qc19_3q1_3==3 | qc19_3q1_3==4
replace AB_ever=1 if qc19_3q1_3==1 | qc19_3q1_3==2

gen PCRAB_ever=.
replace PCRAB_ever=1 if PCR_ever==1 | AB_ever==1
replace PCRAB_ever=0 if (PCR_ever==0 & AB_ever==0) | (PCR_ever==0 & AB_ever==.) | (PCR_ever==. & AB_ever==0) | (PCR_ever==. & AB_ever==.)

//Groupings by auto-IFN status
gen pos_any_p1=.
replace pos_any_p1=1 if ifngr2_p1_robz_T3p5_cat==1 | ifnlr1_p1_robz_T3p5_cat==1 | ifna5_p1_robz_T3p5_cat==1 | ifna6_p1_robz_T3p5_cat==1 | ifnl3_p1_robz_T3p5_cat==1 | ifnl2_p1_robz_T3p5_cat==1 | ifna2_p1_robz_T3p5_cat==1 | ifna7_p1_robz_T3p5_cat==1 | ifna4_p1_robz_T3p5_cat==1 | ifna1_p1_robz_T3p5_cat==1 | ifna10_p1_robz_T3p5_cat==1 | ifna14_p1_robz_T3p5_cat==1 | ifna8_p1_robz_T3p5_cat==1 | ifna16_p1_robz_T3p5_cat==1 | ifna21_p1_robz_T3p5_cat==1 | ifnar2_p1_robz_T3p5_cat==1 | ifna17_p1_robz_T3p5_cat==1 | ifnw1_p1_robz_T3p5_cat==1 | ifng_p1_robz_T3p5_cat==1 | ifnar1_p1_robz_T3p5_cat==1 | ifnl1_p1_robz_T3p5_cat==1
replace pos_any_p1=0 if ifngr2_p1_robz_T3p5_cat==0 & ifnlr1_p1_robz_T3p5_cat==0 & ifna5_p1_robz_T3p5_cat==0 & ifna6_p1_robz_T3p5_cat==0 & ifnl3_p1_robz_T3p5_cat==0 & ifnl2_p1_robz_T3p5_cat==0 & ifna2_p1_robz_T3p5_cat==0 & ifna7_p1_robz_T3p5_cat==0 & ifna4_p1_robz_T3p5_cat==0 & ifna1_p1_robz_T3p5_cat==0 & ifna10_p1_robz_T3p5_cat==0 & ifna14_p1_robz_T3p5_cat==0 & ifna8_p1_robz_T3p5_cat==0 & ifna16_p1_robz_T3p5_cat==0 & ifna21_p1_robz_T3p5_cat==0 & ifnar2_p1_robz_T3p5_cat==0 & ifna17_p1_robz_T3p5_cat==0 & ifnw1_p1_robz_T3p5_cat==0 & ifng_p1_robz_T3p5_cat==0 & ifnar1_p1_robz_T3p5_cat==0 & ifnl1_p1_robz_T3p5_cat==0

gen pos_any_p2=.
replace pos_any_p2=1 if ifngr2_p2_robz_T3p5_cat==1 | ifnlr1_p2_robz_T3p5_cat==1 | ifna5_p2_robz_T3p5_cat==1 | ifna6_p2_robz_T3p5_cat==1 | ifnl3_p2_robz_T3p5_cat==1 | ifnl2_p2_robz_T3p5_cat==1 | ifna2_p2_robz_T3p5_cat==1 | ifna7_p2_robz_T3p5_cat==1 | ifna4_p2_robz_T3p5_cat==1 | ifna1_p2_robz_T3p5_cat==1 | ifna10_p2_robz_T3p5_cat==1 | ifna14_p2_robz_T3p5_cat==1 | ifna8_p2_robz_T3p5_cat==1 | ifna16_p2_robz_T3p5_cat==1 | ifna21_p2_robz_T3p5_cat==1 | ifnar2_p2_robz_T3p5_cat==1 | ifna17_p2_robz_T3p5_cat==1 | ifnw1_p2_robz_T3p5_cat==1 | ifng_p2_robz_T3p5_cat==1 | ifnar1_p2_robz_T3p5_cat==1 | ifnl1_p2_robz_T3p5_cat==1
replace pos_any_p2=0 if ifngr2_p2_robz_T3p5_cat==0 & ifnlr1_p2_robz_T3p5_cat==0 & ifna5_p2_robz_T3p5_cat==0 & ifna6_p2_robz_T3p5_cat==0 & ifnl3_p2_robz_T3p5_cat==0 & ifnl2_p2_robz_T3p5_cat==0 & ifna2_p2_robz_T3p5_cat==0 & ifna7_p2_robz_T3p5_cat==0 & ifna4_p2_robz_T3p5_cat==0 & ifna1_p2_robz_T3p5_cat==0 & ifna10_p2_robz_T3p5_cat==0 & ifna14_p2_robz_T3p5_cat==0 & ifna8_p2_robz_T3p5_cat==0 & ifna16_p2_robz_T3p5_cat==0 & ifna21_p2_robz_T3p5_cat==0 & ifnar2_p2_robz_T3p5_cat==0 & ifna17_p2_robz_T3p5_cat==0 & ifnw1_p2_robz_T3p5_cat==0 & ifng_p2_robz_T3p5_cat==0 & ifnar1_p2_robz_T3p5_cat==0 & ifnl1_p2_robz_T3p5_cat==0

gen pos_any_p3=.
replace pos_any_p3=1 if ifngr2_p3_robz_T3p5_cat==1 | ifnlr1_p3_robz_T3p5_cat==1 | ifna5_p3_robz_T3p5_cat==1 | ifna6_p3_robz_T3p5_cat==1 | ifnl3_p3_robz_T3p5_cat==1 | ifnl2_p3_robz_T3p5_cat==1 | ifna2_p3_robz_T3p5_cat==1 | ifna7_p3_robz_T3p5_cat==1 | ifna4_p3_robz_T3p5_cat==1 | ifna1_p3_robz_T3p5_cat==1 | ifna10_p3_robz_T3p5_cat==1 | ifna14_p3_robz_T3p5_cat==1 | ifna8_p3_robz_T3p5_cat==1 | ifna16_p3_robz_T3p5_cat==1 | ifna21_p3_robz_T3p5_cat==1 | ifnar2_p3_robz_T3p5_cat==1 | ifna17_p3_robz_T3p5_cat==1 | ifnw1_p3_robz_T3p5_cat==1 | ifng_p3_robz_T3p5_cat==1 | ifnar1_p3_robz_T3p5_cat==1 | ifnl1_p3_robz_T3p5_cat==1
replace pos_any_p3=0 if ifngr2_p3_robz_T3p5_cat==0 & ifnlr1_p3_robz_T3p5_cat==0 & ifna5_p3_robz_T3p5_cat==0 & ifna6_p3_robz_T3p5_cat==0 & ifnl3_p3_robz_T3p5_cat==0 & ifnl2_p3_robz_T3p5_cat==0 & ifna2_p3_robz_T3p5_cat==0 & ifna7_p3_robz_T3p5_cat==0 & ifna4_p3_robz_T3p5_cat==0 & ifna1_p3_robz_T3p5_cat==0 & ifna10_p3_robz_T3p5_cat==0 & ifna14_p3_robz_T3p5_cat==0 & ifna8_p3_robz_T3p5_cat==0 & ifna16_p3_robz_T3p5_cat==0 & ifna21_p3_robz_T3p5_cat==0 & ifnar2_p3_robz_T3p5_cat==0 & ifna17_p3_robz_T3p5_cat==0 & ifnw1_p3_robz_T3p5_cat==0 & ifng_p3_robz_T3p5_cat==0 & ifnar1_p3_robz_T3p5_cat==0 & ifnl1_p3_robz_T3p5_cat==0

**Generate 3 categories for robust z-scores threshold 3.5 over phases, always negative, always positive, changing

gen ifngr2_robz_3cat=.
replace ifngr2_robz_3cat=1 if ifngr2_p1_robz_T3p5_cat==0 & ifngr2_p2_robz_T3p5_cat==0 & ifngr2_p3_robz_T3p5_cat==0
replace ifngr2_robz_3cat=2 if ifngr2_p1_robz_T3p5_cat==1 & ifngr2_p2_robz_T3p5_cat==1 & ifngr2_p3_robz_T3p5_cat==1
replace ifngr2_robz_3cat=3 if (ifngr2_p1_robz_T3p5_cat==0 & ifngr2_p2_robz_T3p5_cat==0 & ifngr2_p3_robz_T3p5_cat==1) | (ifngr2_p1_robz_T3p5_cat==0 & ifngr2_p2_robz_T3p5_cat==1 & ifngr2_p3_robz_T3p5_cat==1) | (ifngr2_p1_robz_T3p5_cat==0 & ifngr2_p2_robz_T3p5_cat==1 & ifngr2_p3_robz_T3p5_cat==0) | (ifngr2_p1_robz_T3p5_cat==1 & ifngr2_p2_robz_T3p5_cat==0 & ifngr2_p3_robz_T3p5_cat==0) | (ifngr2_p1_robz_T3p5_cat==1 & ifngr2_p2_robz_T3p5_cat==0 & ifngr2_p3_robz_T3p5_cat==1) | (ifngr2_p1_robz_T3p5_cat==1 & ifngr2_p2_robz_T3p5_cat==1 & ifngr2_p3_robz_T3p5_cat==0)

gen ifnlr1_robz_3cat=.
replace ifnlr1_robz_3cat=1 if ifnlr1_p1_robz_T3p5_cat==0 & ifnlr1_p2_robz_T3p5_cat==0 & ifnlr1_p3_robz_T3p5_cat==0
replace ifnlr1_robz_3cat=2 if ifnlr1_p1_robz_T3p5_cat==1 & ifnlr1_p2_robz_T3p5_cat==1 & ifnlr1_p3_robz_T3p5_cat==1
replace ifnlr1_robz_3cat=3 if (ifnlr1_p1_robz_T3p5_cat==0 & ifnlr1_p2_robz_T3p5_cat==0 & ifnlr1_p3_robz_T3p5_cat==1) | (ifnlr1_p1_robz_T3p5_cat==0 & ifnlr1_p2_robz_T3p5_cat==1 & ifnlr1_p3_robz_T3p5_cat==1) | (ifnlr1_p1_robz_T3p5_cat==0 & ifnlr1_p2_robz_T3p5_cat==1 & ifnlr1_p3_robz_T3p5_cat==0) | (ifnlr1_p1_robz_T3p5_cat==1 & ifnlr1_p2_robz_T3p5_cat==0 & ifnlr1_p3_robz_T3p5_cat==0) | (ifnlr1_p1_robz_T3p5_cat==1 & ifnlr1_p2_robz_T3p5_cat==0 & ifnlr1_p3_robz_T3p5_cat==1) | (ifnlr1_p1_robz_T3p5_cat==1 & ifnlr1_p2_robz_T3p5_cat==1 & ifnlr1_p3_robz_T3p5_cat==0)

gen ifna5_robz_3cat=.
replace ifna5_robz_3cat=1 if ifna5_p1_robz_T3p5_cat==0 & ifna5_p2_robz_T3p5_cat==0 & ifna5_p3_robz_T3p5_cat==0
replace ifna5_robz_3cat=2 if ifna5_p1_robz_T3p5_cat==1 & ifna5_p2_robz_T3p5_cat==1 & ifna5_p3_robz_T3p5_cat==1
replace ifna5_robz_3cat=3 if (ifna5_p1_robz_T3p5_cat==0 & ifna5_p2_robz_T3p5_cat==0 & ifna5_p3_robz_T3p5_cat==1) | (ifna5_p1_robz_T3p5_cat==0 & ifna5_p2_robz_T3p5_cat==1 & ifna5_p3_robz_T3p5_cat==1) | (ifna5_p1_robz_T3p5_cat==0 & ifna5_p2_robz_T3p5_cat==1 & ifna5_p3_robz_T3p5_cat==0) | (ifna5_p1_robz_T3p5_cat==1 & ifna5_p2_robz_T3p5_cat==0 & ifna5_p3_robz_T3p5_cat==0) | (ifna5_p1_robz_T3p5_cat==1 & ifna5_p2_robz_T3p5_cat==0 & ifna5_p3_robz_T3p5_cat==1) | (ifna5_p1_robz_T3p5_cat==1 & ifna5_p2_robz_T3p5_cat==1 & ifna5_p3_robz_T3p5_cat==0)

gen ifna6_robz_3cat=.
replace ifna6_robz_3cat=1 if ifna6_p1_robz_T3p5_cat==0 & ifna6_p2_robz_T3p5_cat==0 & ifna6_p3_robz_T3p5_cat==0
replace ifna6_robz_3cat=2 if ifna6_p1_robz_T3p5_cat==1 & ifna6_p2_robz_T3p5_cat==1 & ifna6_p3_robz_T3p5_cat==1
replace ifna6_robz_3cat=3 if (ifna6_p1_robz_T3p5_cat==0 & ifna6_p2_robz_T3p5_cat==0 & ifna6_p3_robz_T3p5_cat==1) | (ifna6_p1_robz_T3p5_cat==0 & ifna6_p2_robz_T3p5_cat==1 & ifna6_p3_robz_T3p5_cat==1) | (ifna6_p1_robz_T3p5_cat==0 & ifna6_p2_robz_T3p5_cat==1 & ifna6_p3_robz_T3p5_cat==0) | (ifna6_p1_robz_T3p5_cat==1 & ifna6_p2_robz_T3p5_cat==0 & ifna6_p3_robz_T3p5_cat==0) | (ifna6_p1_robz_T3p5_cat==1 & ifna6_p2_robz_T3p5_cat==0 & ifna6_p3_robz_T3p5_cat==1) | (ifna6_p1_robz_T3p5_cat==1 & ifna6_p2_robz_T3p5_cat==1 & ifna6_p3_robz_T3p5_cat==0)

gen ifnl3_robz_3cat=.
replace ifnl3_robz_3cat=1 if ifnl3_p1_robz_T3p5_cat==0 & ifnl3_p2_robz_T3p5_cat==0 & ifnl3_p3_robz_T3p5_cat==0
replace ifnl3_robz_3cat=2 if ifnl3_p1_robz_T3p5_cat==1 & ifnl3_p2_robz_T3p5_cat==1 & ifnl3_p3_robz_T3p5_cat==1
replace ifnl3_robz_3cat=3 if (ifnl3_p1_robz_T3p5_cat==0 & ifnl3_p2_robz_T3p5_cat==0 & ifnl3_p3_robz_T3p5_cat==1) | (ifnl3_p1_robz_T3p5_cat==0 & ifnl3_p2_robz_T3p5_cat==1 & ifnl3_p3_robz_T3p5_cat==1) | (ifnl3_p1_robz_T3p5_cat==0 & ifnl3_p2_robz_T3p5_cat==1 & ifnl3_p3_robz_T3p5_cat==0) | (ifnl3_p1_robz_T3p5_cat==1 & ifnl3_p2_robz_T3p5_cat==0 & ifnl3_p3_robz_T3p5_cat==0) | (ifnl3_p1_robz_T3p5_cat==1 & ifnl3_p2_robz_T3p5_cat==0 & ifnl3_p3_robz_T3p5_cat==1) | (ifnl3_p1_robz_T3p5_cat==1 & ifnl3_p2_robz_T3p5_cat==1 & ifnl3_p3_robz_T3p5_cat==0)

gen ifnl2_robz_3cat=.
replace ifnl2_robz_3cat=1 if ifnl2_p1_robz_T3p5_cat==0 & ifnl2_p2_robz_T3p5_cat==0 & ifnl2_p3_robz_T3p5_cat==0
replace ifnl2_robz_3cat=2 if ifnl2_p1_robz_T3p5_cat==1 & ifnl2_p2_robz_T3p5_cat==1 & ifnl2_p3_robz_T3p5_cat==1
replace ifnl2_robz_3cat=3 if (ifnl2_p1_robz_T3p5_cat==0 & ifnl2_p2_robz_T3p5_cat==0 & ifnl2_p3_robz_T3p5_cat==1) | (ifnl2_p1_robz_T3p5_cat==0 & ifnl2_p2_robz_T3p5_cat==1 & ifnl2_p3_robz_T3p5_cat==1) | (ifnl2_p1_robz_T3p5_cat==0 & ifnl2_p2_robz_T3p5_cat==1 & ifnl2_p3_robz_T3p5_cat==0) | (ifnl2_p1_robz_T3p5_cat==1 & ifnl2_p2_robz_T3p5_cat==0 & ifnl2_p3_robz_T3p5_cat==0) | (ifnl2_p1_robz_T3p5_cat==1 & ifnl2_p2_robz_T3p5_cat==0 & ifnl2_p3_robz_T3p5_cat==1) | (ifnl2_p1_robz_T3p5_cat==1 & ifnl2_p2_robz_T3p5_cat==1 & ifnl2_p3_robz_T3p5_cat==0)

gen ifna2_robz_3cat=.
replace ifna2_robz_3cat=1 if ifna2_p1_robz_T3p5_cat==0 & ifna2_p2_robz_T3p5_cat==0 & ifna2_p3_robz_T3p5_cat==0
replace ifna2_robz_3cat=2 if ifna2_p1_robz_T3p5_cat==1 & ifna2_p2_robz_T3p5_cat==1 & ifna2_p3_robz_T3p5_cat==1
replace ifna2_robz_3cat=3 if (ifna2_p1_robz_T3p5_cat==0 & ifna2_p2_robz_T3p5_cat==0 & ifna2_p3_robz_T3p5_cat==1) | (ifna2_p1_robz_T3p5_cat==0 & ifna2_p2_robz_T3p5_cat==1 & ifna2_p3_robz_T3p5_cat==1) | (ifna2_p1_robz_T3p5_cat==0 & ifna2_p2_robz_T3p5_cat==1 & ifna2_p3_robz_T3p5_cat==0) | (ifna2_p1_robz_T3p5_cat==1 & ifna2_p2_robz_T3p5_cat==0 & ifna2_p3_robz_T3p5_cat==0) | (ifna2_p1_robz_T3p5_cat==1 & ifna2_p2_robz_T3p5_cat==0 & ifna2_p3_robz_T3p5_cat==1) | (ifna2_p1_robz_T3p5_cat==1 & ifna2_p2_robz_T3p5_cat==1 & ifna2_p3_robz_T3p5_cat==0)

gen ifna7_robz_3cat=.
replace ifna7_robz_3cat=1 if ifna7_p1_robz_T3p5_cat==0 & ifna7_p2_robz_T3p5_cat==0 & ifna7_p3_robz_T3p5_cat==0
replace ifna7_robz_3cat=2 if ifna7_p1_robz_T3p5_cat==1 & ifna7_p2_robz_T3p5_cat==1 & ifna7_p3_robz_T3p5_cat==1
replace ifna7_robz_3cat=3 if (ifna7_p1_robz_T3p5_cat==0 & ifna7_p2_robz_T3p5_cat==0 & ifna7_p3_robz_T3p5_cat==1) | (ifna7_p1_robz_T3p5_cat==0 & ifna7_p2_robz_T3p5_cat==1 & ifna7_p3_robz_T3p5_cat==1) | (ifna7_p1_robz_T3p5_cat==0 & ifna7_p2_robz_T3p5_cat==1 & ifna7_p3_robz_T3p5_cat==0) | (ifna7_p1_robz_T3p5_cat==1 & ifna7_p2_robz_T3p5_cat==0 & ifna7_p3_robz_T3p5_cat==0) | (ifna7_p1_robz_T3p5_cat==1 & ifna7_p2_robz_T3p5_cat==0 & ifna7_p3_robz_T3p5_cat==1) | (ifna7_p1_robz_T3p5_cat==1 & ifna7_p2_robz_T3p5_cat==1 & ifna7_p3_robz_T3p5_cat==0)

gen ifna4_robz_3cat=.
replace ifna4_robz_3cat=1 if ifna4_p1_robz_T3p5_cat==0 & ifna4_p2_robz_T3p5_cat==0 & ifna4_p3_robz_T3p5_cat==0
replace ifna4_robz_3cat=2 if ifna4_p1_robz_T3p5_cat==1 & ifna4_p2_robz_T3p5_cat==1 & ifna4_p3_robz_T3p5_cat==1
replace ifna4_robz_3cat=3 if (ifna4_p1_robz_T3p5_cat==0 & ifna4_p2_robz_T3p5_cat==0 & ifna4_p3_robz_T3p5_cat==1) | (ifna4_p1_robz_T3p5_cat==0 & ifna4_p2_robz_T3p5_cat==1 & ifna4_p3_robz_T3p5_cat==1) | (ifna4_p1_robz_T3p5_cat==0 & ifna4_p2_robz_T3p5_cat==1 & ifna4_p3_robz_T3p5_cat==0) | (ifna4_p1_robz_T3p5_cat==1 & ifna4_p2_robz_T3p5_cat==0 & ifna4_p3_robz_T3p5_cat==0) | (ifna4_p1_robz_T3p5_cat==1 & ifna4_p2_robz_T3p5_cat==0 & ifna4_p3_robz_T3p5_cat==1) | (ifna4_p1_robz_T3p5_cat==1 & ifna4_p2_robz_T3p5_cat==1 & ifna4_p3_robz_T3p5_cat==0)

gen ifna1_robz_3cat=.
replace ifna1_robz_3cat=1 if ifna1_p1_robz_T3p5_cat==0 & ifna1_p2_robz_T3p5_cat==0 & ifna1_p3_robz_T3p5_cat==0
replace ifna1_robz_3cat=2 if ifna1_p1_robz_T3p5_cat==1 & ifna1_p2_robz_T3p5_cat==1 & ifna1_p3_robz_T3p5_cat==1
replace ifna1_robz_3cat=3 if (ifna1_p1_robz_T3p5_cat==0 & ifna1_p2_robz_T3p5_cat==0 & ifna1_p3_robz_T3p5_cat==1) | (ifna1_p1_robz_T3p5_cat==0 & ifna1_p2_robz_T3p5_cat==1 & ifna1_p3_robz_T3p5_cat==1) | (ifna1_p1_robz_T3p5_cat==0 & ifna1_p2_robz_T3p5_cat==1 & ifna1_p3_robz_T3p5_cat==0) | (ifna1_p1_robz_T3p5_cat==1 & ifna1_p2_robz_T3p5_cat==0 & ifna1_p3_robz_T3p5_cat==0) | (ifna1_p1_robz_T3p5_cat==1 & ifna1_p2_robz_T3p5_cat==0 & ifna1_p3_robz_T3p5_cat==1) | (ifna1_p1_robz_T3p5_cat==1 & ifna1_p2_robz_T3p5_cat==1 & ifna1_p3_robz_T3p5_cat==0)

gen ifna10_robz_3cat=.
replace ifna10_robz_3cat=1 if ifna10_p1_robz_T3p5_cat==0 & ifna10_p2_robz_T3p5_cat==0 & ifna10_p3_robz_T3p5_cat==0
replace ifna10_robz_3cat=2 if ifna10_p1_robz_T3p5_cat==1 & ifna10_p2_robz_T3p5_cat==1 & ifna10_p3_robz_T3p5_cat==1
replace ifna10_robz_3cat=3 if (ifna10_p1_robz_T3p5_cat==0 & ifna10_p2_robz_T3p5_cat==0 & ifna10_p3_robz_T3p5_cat==1) | (ifna10_p1_robz_T3p5_cat==0 & ifna10_p2_robz_T3p5_cat==1 & ifna10_p3_robz_T3p5_cat==1) | (ifna10_p1_robz_T3p5_cat==0 & ifna10_p2_robz_T3p5_cat==1 & ifna10_p3_robz_T3p5_cat==0) | (ifna10_p1_robz_T3p5_cat==1 & ifna10_p2_robz_T3p5_cat==0 & ifna10_p3_robz_T3p5_cat==0) | (ifna10_p1_robz_T3p5_cat==1 & ifna10_p2_robz_T3p5_cat==0 & ifna10_p3_robz_T3p5_cat==1) | (ifna10_p1_robz_T3p5_cat==1 & ifna10_p2_robz_T3p5_cat==1 & ifna10_p3_robz_T3p5_cat==0)

gen ifna14_robz_3cat=.
replace ifna14_robz_3cat=1 if ifna14_p1_robz_T3p5_cat==0 & ifna14_p2_robz_T3p5_cat==0 & ifna14_p3_robz_T3p5_cat==0
replace ifna14_robz_3cat=2 if ifna14_p1_robz_T3p5_cat==1 & ifna14_p2_robz_T3p5_cat==1 & ifna14_p3_robz_T3p5_cat==1
replace ifna14_robz_3cat=3 if (ifna14_p1_robz_T3p5_cat==0 & ifna14_p2_robz_T3p5_cat==0 & ifna14_p3_robz_T3p5_cat==1) | (ifna14_p1_robz_T3p5_cat==0 & ifna14_p2_robz_T3p5_cat==1 & ifna14_p3_robz_T3p5_cat==1) | (ifna14_p1_robz_T3p5_cat==0 & ifna14_p2_robz_T3p5_cat==1 & ifna14_p3_robz_T3p5_cat==0) | (ifna14_p1_robz_T3p5_cat==1 & ifna14_p2_robz_T3p5_cat==0 & ifna14_p3_robz_T3p5_cat==0) | (ifna14_p1_robz_T3p5_cat==1 & ifna14_p2_robz_T3p5_cat==0 & ifna14_p3_robz_T3p5_cat==1) | (ifna14_p1_robz_T3p5_cat==1 & ifna14_p2_robz_T3p5_cat==1 & ifna14_p3_robz_T3p5_cat==0)

gen ifna8_robz_3cat=.
replace ifna8_robz_3cat=1 if ifna8_p1_robz_T3p5_cat==0 & ifna8_p2_robz_T3p5_cat==0 & ifna8_p3_robz_T3p5_cat==0
replace ifna8_robz_3cat=2 if ifna8_p1_robz_T3p5_cat==1 & ifna8_p2_robz_T3p5_cat==1 & ifna8_p3_robz_T3p5_cat==1
replace ifna8_robz_3cat=3 if (ifna8_p1_robz_T3p5_cat==0 & ifna8_p2_robz_T3p5_cat==0 & ifna8_p3_robz_T3p5_cat==1) | (ifna8_p1_robz_T3p5_cat==0 & ifna8_p2_robz_T3p5_cat==1 & ifna8_p3_robz_T3p5_cat==1) | (ifna8_p1_robz_T3p5_cat==0 & ifna8_p2_robz_T3p5_cat==1 & ifna8_p3_robz_T3p5_cat==0) | (ifna8_p1_robz_T3p5_cat==1 & ifna8_p2_robz_T3p5_cat==0 & ifna8_p3_robz_T3p5_cat==0) | (ifna8_p1_robz_T3p5_cat==1 & ifna8_p2_robz_T3p5_cat==0 & ifna8_p3_robz_T3p5_cat==1) | (ifna8_p1_robz_T3p5_cat==1 & ifna8_p2_robz_T3p5_cat==1 & ifna8_p3_robz_T3p5_cat==0)

gen ifna16_robz_3cat=.
replace ifna16_robz_3cat=1 if ifna16_p1_robz_T3p5_cat==0 & ifna16_p2_robz_T3p5_cat==0 & ifna16_p3_robz_T3p5_cat==0
replace ifna16_robz_3cat=2 if ifna16_p1_robz_T3p5_cat==1 & ifna16_p2_robz_T3p5_cat==1 & ifna16_p3_robz_T3p5_cat==1
replace ifna16_robz_3cat=3 if (ifna16_p1_robz_T3p5_cat==0 & ifna16_p2_robz_T3p5_cat==0 & ifna16_p3_robz_T3p5_cat==1) | (ifna16_p1_robz_T3p5_cat==0 & ifna16_p2_robz_T3p5_cat==1 & ifna16_p3_robz_T3p5_cat==1) | (ifna16_p1_robz_T3p5_cat==0 & ifna16_p2_robz_T3p5_cat==1 & ifna16_p3_robz_T3p5_cat==0) | (ifna16_p1_robz_T3p5_cat==1 & ifna16_p2_robz_T3p5_cat==0 & ifna16_p3_robz_T3p5_cat==0) | (ifna16_p1_robz_T3p5_cat==1 & ifna16_p2_robz_T3p5_cat==0 & ifna16_p3_robz_T3p5_cat==1) | (ifna16_p1_robz_T3p5_cat==1 & ifna16_p2_robz_T3p5_cat==1 & ifna16_p3_robz_T3p5_cat==0)

gen ifna21_robz_3cat=.
replace ifna21_robz_3cat=1 if ifna21_p1_robz_T3p5_cat==0 & ifna21_p2_robz_T3p5_cat==0 & ifna21_p3_robz_T3p5_cat==0
replace ifna21_robz_3cat=2 if ifna21_p1_robz_T3p5_cat==1 & ifna21_p2_robz_T3p5_cat==1 & ifna21_p3_robz_T3p5_cat==1
replace ifna21_robz_3cat=3 if (ifna21_p1_robz_T3p5_cat==0 & ifna21_p2_robz_T3p5_cat==0 & ifna21_p3_robz_T3p5_cat==1) | (ifna21_p1_robz_T3p5_cat==0 & ifna21_p2_robz_T3p5_cat==1 & ifna21_p3_robz_T3p5_cat==1) | (ifna21_p1_robz_T3p5_cat==0 & ifna21_p2_robz_T3p5_cat==1 & ifna21_p3_robz_T3p5_cat==0) | (ifna21_p1_robz_T3p5_cat==1 & ifna21_p2_robz_T3p5_cat==0 & ifna21_p3_robz_T3p5_cat==0) | (ifna21_p1_robz_T3p5_cat==1 & ifna21_p2_robz_T3p5_cat==0 & ifna21_p3_robz_T3p5_cat==1) | (ifna21_p1_robz_T3p5_cat==1 & ifna21_p2_robz_T3p5_cat==1 & ifna21_p3_robz_T3p5_cat==0)

gen ifnar2_robz_3cat=.
replace ifnar2_robz_3cat=1 if ifnar2_p1_robz_T3p5_cat==0 & ifnar2_p2_robz_T3p5_cat==0 & ifnar2_p3_robz_T3p5_cat==0
replace ifnar2_robz_3cat=2 if ifnar2_p1_robz_T3p5_cat==1 & ifnar2_p2_robz_T3p5_cat==1 & ifnar2_p3_robz_T3p5_cat==1
replace ifnar2_robz_3cat=3 if (ifnar2_p1_robz_T3p5_cat==0 & ifnar2_p2_robz_T3p5_cat==0 & ifnar2_p3_robz_T3p5_cat==1) | (ifnar2_p1_robz_T3p5_cat==0 & ifnar2_p2_robz_T3p5_cat==1 & ifnar2_p3_robz_T3p5_cat==1) | (ifnar2_p1_robz_T3p5_cat==0 & ifnar2_p2_robz_T3p5_cat==1 & ifnar2_p3_robz_T3p5_cat==0) | (ifnar2_p1_robz_T3p5_cat==1 & ifnar2_p2_robz_T3p5_cat==0 & ifnar2_p3_robz_T3p5_cat==0) | (ifnar2_p1_robz_T3p5_cat==1 & ifnar2_p2_robz_T3p5_cat==0 & ifnar2_p3_robz_T3p5_cat==1) | (ifnar2_p1_robz_T3p5_cat==1 & ifnar2_p2_robz_T3p5_cat==1 & ifnar2_p3_robz_T3p5_cat==0)

gen ifna17_robz_3cat=.
replace ifna17_robz_3cat=1 if ifna17_p1_robz_T3p5_cat==0 & ifna17_p2_robz_T3p5_cat==0 & ifna17_p3_robz_T3p5_cat==0
replace ifna17_robz_3cat=2 if ifna17_p1_robz_T3p5_cat==1 & ifna17_p2_robz_T3p5_cat==1 & ifna17_p3_robz_T3p5_cat==1
replace ifna17_robz_3cat=3 if (ifna17_p1_robz_T3p5_cat==0 & ifna17_p2_robz_T3p5_cat==0 & ifna17_p3_robz_T3p5_cat==1) | (ifna17_p1_robz_T3p5_cat==0 & ifna17_p2_robz_T3p5_cat==1 & ifna17_p3_robz_T3p5_cat==1) | (ifna17_p1_robz_T3p5_cat==0 & ifna17_p2_robz_T3p5_cat==1 & ifna17_p3_robz_T3p5_cat==0) | (ifna17_p1_robz_T3p5_cat==1 & ifna17_p2_robz_T3p5_cat==0 & ifna17_p3_robz_T3p5_cat==0) | (ifna17_p1_robz_T3p5_cat==1 & ifna17_p2_robz_T3p5_cat==0 & ifna17_p3_robz_T3p5_cat==1) | (ifna17_p1_robz_T3p5_cat==1 & ifna17_p2_robz_T3p5_cat==1 & ifna17_p3_robz_T3p5_cat==0)

gen ifnw1_robz_3cat=.
replace ifnw1_robz_3cat=1 if ifnw1_p1_robz_T3p5_cat==0 & ifnw1_p2_robz_T3p5_cat==0 & ifnw1_p3_robz_T3p5_cat==0
replace ifnw1_robz_3cat=2 if ifnw1_p1_robz_T3p5_cat==1 & ifnw1_p2_robz_T3p5_cat==1 & ifnw1_p3_robz_T3p5_cat==1
replace ifnw1_robz_3cat=3 if (ifnw1_p1_robz_T3p5_cat==0 & ifnw1_p2_robz_T3p5_cat==0 & ifnw1_p3_robz_T3p5_cat==1) | (ifnw1_p1_robz_T3p5_cat==0 & ifnw1_p2_robz_T3p5_cat==1 & ifnw1_p3_robz_T3p5_cat==1) | (ifnw1_p1_robz_T3p5_cat==0 & ifnw1_p2_robz_T3p5_cat==1 & ifnw1_p3_robz_T3p5_cat==0) | (ifnw1_p1_robz_T3p5_cat==1 & ifnw1_p2_robz_T3p5_cat==0 & ifnw1_p3_robz_T3p5_cat==0) | (ifnw1_p1_robz_T3p5_cat==1 & ifnw1_p2_robz_T3p5_cat==0 & ifnw1_p3_robz_T3p5_cat==1) | (ifnw1_p1_robz_T3p5_cat==1 & ifnw1_p2_robz_T3p5_cat==1 & ifnw1_p3_robz_T3p5_cat==0)

gen ifng_robz_3cat=.
replace ifng_robz_3cat=1 if ifng_p1_robz_T3p5_cat==0 & ifng_p2_robz_T3p5_cat==0 & ifng_p3_robz_T3p5_cat==0
replace ifng_robz_3cat=2 if ifng_p1_robz_T3p5_cat==1 & ifng_p2_robz_T3p5_cat==1 & ifng_p3_robz_T3p5_cat==1
replace ifng_robz_3cat=3 if (ifng_p1_robz_T3p5_cat==0 & ifng_p2_robz_T3p5_cat==0 & ifng_p3_robz_T3p5_cat==1) | (ifng_p1_robz_T3p5_cat==0 & ifng_p2_robz_T3p5_cat==1 & ifng_p3_robz_T3p5_cat==1) | (ifng_p1_robz_T3p5_cat==0 & ifng_p2_robz_T3p5_cat==1 & ifng_p3_robz_T3p5_cat==0) | (ifng_p1_robz_T3p5_cat==1 & ifng_p2_robz_T3p5_cat==0 & ifng_p3_robz_T3p5_cat==0) | (ifng_p1_robz_T3p5_cat==1 & ifng_p2_robz_T3p5_cat==0 & ifng_p3_robz_T3p5_cat==1) | (ifng_p1_robz_T3p5_cat==1 & ifng_p2_robz_T3p5_cat==1 & ifng_p3_robz_T3p5_cat==0)

gen ifnar1_robz_3cat=.
replace ifnar1_robz_3cat=1 if ifnar1_p1_robz_T3p5_cat==0 & ifnar1_p2_robz_T3p5_cat==0 & ifnar1_p3_robz_T3p5_cat==0
replace ifnar1_robz_3cat=2 if ifnar1_p1_robz_T3p5_cat==1 & ifnar1_p2_robz_T3p5_cat==1 & ifnar1_p3_robz_T3p5_cat==1
replace ifnar1_robz_3cat=3 if (ifnar1_p1_robz_T3p5_cat==0 & ifnar1_p2_robz_T3p5_cat==0 & ifnar1_p3_robz_T3p5_cat==1) | (ifnar1_p1_robz_T3p5_cat==0 & ifnar1_p2_robz_T3p5_cat==1 & ifnar1_p3_robz_T3p5_cat==1) | (ifnar1_p1_robz_T3p5_cat==0 & ifnar1_p2_robz_T3p5_cat==1 & ifnar1_p3_robz_T3p5_cat==0) | (ifnar1_p1_robz_T3p5_cat==1 & ifnar1_p2_robz_T3p5_cat==0 & ifnar1_p3_robz_T3p5_cat==0) | (ifnar1_p1_robz_T3p5_cat==1 & ifnar1_p2_robz_T3p5_cat==0 & ifnar1_p3_robz_T3p5_cat==1) | (ifnar1_p1_robz_T3p5_cat==1 & ifnar1_p2_robz_T3p5_cat==1 & ifnar1_p3_robz_T3p5_cat==0)

gen ifnl1_robz_3cat=.
replace ifnl1_robz_3cat=1 if ifnl1_p1_robz_T3p5_cat==0 & ifnl1_p2_robz_T3p5_cat==0 & ifnl1_p3_robz_T3p5_cat==0
replace ifnl1_robz_3cat=2 if ifnl1_p1_robz_T3p5_cat==1 & ifnl1_p2_robz_T3p5_cat==1 & ifnl1_p3_robz_T3p5_cat==1
replace ifnl1_robz_3cat=3 if (ifnl1_p1_robz_T3p5_cat==0 & ifnl1_p2_robz_T3p5_cat==0 & ifnl1_p3_robz_T3p5_cat==1) | (ifnl1_p1_robz_T3p5_cat==0 & ifnl1_p2_robz_T3p5_cat==1 & ifnl1_p3_robz_T3p5_cat==1) | (ifnl1_p1_robz_T3p5_cat==0 & ifnl1_p2_robz_T3p5_cat==1 & ifnl1_p3_robz_T3p5_cat==0) | (ifnl1_p1_robz_T3p5_cat==1 & ifnl1_p2_robz_T3p5_cat==0 & ifnl1_p3_robz_T3p5_cat==0) | (ifnl1_p1_robz_T3p5_cat==1 & ifnl1_p2_robz_T3p5_cat==0 & ifnl1_p3_robz_T3p5_cat==1) | (ifnl1_p1_robz_T3p5_cat==1 & ifnl1_p2_robz_T3p5_cat==1 & ifnl1_p3_robz_T3p5_cat==0)
//_______________________________________________________________

***Bendes et al Nat Com 2026 Tables

**TABLE 1: PHASE 1
tab total_pop
tab total_pop male, col row
bys total_pop: sum qc19_1aldy, d
bys male: sum qc19_1aldy if total_pop==1, d
ranksum qc19_1aldy if total_pop==1, by(male)
tab total_pop smokeC191_2, col row
tab male smokeC191_2 if total_pop==1, col row chi2 exact
tab total_pop sminet_case_p1DBS, col row
tab male sminet_case_p1DBS if total_pop==1, col row chi2 exact
tab total_pop vaccinated_p1, col row
tab male vaccinated_p1 if total_pop==1, col row chi2 exact

**TABLE 1: PHASE 2
bys total_pop: sum qc19_2aldy, d
bys male: sum qc19_2aldy if total_pop==1, d
ranksum qc19_2aldy if total_pop==1, by(male)
tab total_pop smokeC192_2, col row
tab male smokeC192_2 if total_pop==1, col row chi2 exact
return list
tab total_pop bmi_c19_cat, col row
tab male bmi_c19_cat if total_pop==1, col row chi2 exact
return list
bys total_pop: sum bmi_bia_c19, d
bys male: sum bmi_bia_c19 if total_pop==1, d
ranksum bmi_bia_c19 if total_pop==1, by(male)
return list
bys total_pop: sum fatp_c19, d
bys male: sum fatp_c19 if total_pop==1, d
ranksum fatp_c19 if total_pop==1, by(male)
return list
tab total_pop sminet_case_p2DBS, col row
tab male sminet_case_p2DBS if total_pop==1, col row chi2 exact
return list
tab total_pop vaccinated_p2, col row
tab male vaccinated_p2 if total_pop==1, col row chi2 exact
return list
tab total_pop vaccinated_p2_total, col row
tab male vaccinated_p2_total if total_pop==1, col row chi2 exact
return list

**TABLE 1: PHASE 3
bys total_pop: sum qc19_3aldy, d
bys male: sum qc19_3aldy if total_pop==1, d
ranksum qc19_3aldy if total_pop==1, by(male)
return list
tab total_pop smokeC193_2, col row
tab male smokeC193_2 if total_pop==1, col row chi2 exact
return list
tab total_pop sminet_case_p3DBS, col row
tab male sminet_case_p3DBS if total_pop==1, col row chi2 exact
return list
tab total_pop vaccinated_p3, col row
tab male vaccinated_p3 if total_pop==1, col row chi2 exact
return list
tab total_pop vaccinated_p3_total, col row
tab male vaccinated_p3_total if total_pop==1, col row chi2 exact
return list

**TABLE 2: PHASE 1
tab serology_cluster_p1
tab serology_cluster_p1 male if serology_cluster_p1==1 | serology_cluster_p1==2, col row exact
return list
bys serology_cluster_p1: sum qc19_1aldy if serology_cluster_p1==1 | serology_cluster_p1==2, d
ranksum qc19_1aldy if serology_cluster_p1==1 | serology_cluster_p1==2, by(serology_cluster_p1)
return list
tab serology_cluster_p1 smokeC191_2 if serology_cluster_p1==1 | serology_cluster_p1==2, col row exact
return list
tab serology_cluster_p1 qc19_1q2 if serology_cluster_p1==1 | serology_cluster_p1==2, col row exact
return list
tab serology_cluster_p1 symptoms_p1_8wormore if serology_cluster_p1==1 | serology_cluster_p1==2, col row exact
return list
tab serology_cluster_p1 PCRself_p1 if serology_cluster_p1==1 | serology_cluster_p1==2, col row exact
return list
tab serology_cluster_p1 ABself_p1 if serology_cluster_p1==1 | serology_cluster_p1==2, col row exact
return list
tab serology_cluster_p1 PCRABself_p1 if serology_cluster_p1==1 | serology_cluster_p1==2, col row exact
return list
tab serology_cluster_p1 sminet_case_p1DBS if serology_cluster_p1==1 | serology_cluster_p1==2, col row exact
return list
bys serology_cluster_p1: sum days_sminet_p1 if days_sminet_p1>0, d
tab serology_cluster_p1 vaccinated_p1 if serology_cluster_p1==1 | serology_cluster_p1==2, col row exact
return list

**TABLE 2: PHASE 2
tab serology_cluster_p2
tab serology_cluster_p2 male if serology_cluster_p2!=3, col row exact
return list
bys serology_cluster_p2: sum qc19_2aldy if serology_cluster_p2!=3, d
kwallis qc19_2aldy if serology_cluster_p2!=3, by(serology_cluster_p2)
disp chi2tail(r(df), r(chi2))
tab serology_cluster_p2 smokeC192_2 if serology_cluster_p2!=3, col row exact
return list
tab serology_cluster_p2 qc19_2q1 if serology_cluster_p2!=3, col row exact
return list
tab serology_cluster_p2 symptoms_p2_8wormore if serology_cluster_p2!=3, col row exact
return list
tab serology_cluster_p2 PCRself_p2 if serology_cluster_p2!=3, col row exact
return list
tab serology_cluster_p2 ABself_p2 if serology_cluster_p2!=3, col row exact
return list
tab serology_cluster_p2 PCRABself_p2 if serology_cluster_p2!=3, col row exact
return list
tab serology_cluster_p2 sminet_case_p2DBS if serology_cluster_p2!=3, col row exact
return list
bys serology_cluster_p2: sum days_sminet_p2 if days_sminet_p2>0 & serology_cluster_p2!=3, d
kwallis days_sminet_p2 if days_sminet_p2>0 & serology_cluster_p2!=3, by(serology_cluster_p2)
disp chi2tail(r(df), r(chi2))
tab serology_cluster_p2 new_sminet_case_p2DBS if serology_cluster_p2!=3, col row exact
return list
tab serology_cluster_p2 vaccinated_p2 if serology_cluster_p2!=3, col row exact
return list
tab serology_cluster_p2 vaccinated_p2_total if serology_cluster_p2!=3, col row exact
return list
bys serology_cluster_p2: sum days_vacc1_p2 if vaccinated_p2==1 & serology_cluster_p2!=3, d
kwallis days_vacc1_p2 if vaccinated_p2==1 & serology_cluster_p2!=3, by(serology_cluster_p2)
disp chi2tail(r(df), r(chi2))
bys serology_cluster_p2: sum days_vacc2_p2 if vaccinated_p2_total==3 & serology_cluster_p2!=3, d
kwallis days_vacc2_p2 if vaccinated_p2_total==3 & serology_cluster_p2!=3, by(serology_cluster_p2)
disp chi2tail(r(df), r(chi2))
tab serology_cluster_p2 KUL_num if serology_cluster_p2!=3, col row exact
return list

**TABLE 2: PHASE 3
tab serology_cluster_p3
tab serology_cluster_p3 male, col row exact
return list
bys serology_cluster_p3: sum qc19_3aldy, d
kwallis qc19_3aldy, by(serology_cluster_p3)
disp chi2tail(r(df), r(chi2))
tab serology_cluster_p3 smokeC193_2, col row exact
return list
tab serology_cluster_p3 symptoms_2months_q3, col row exact
return list
tab serology_cluster_p3 symptoms_3months_q3, col row exact
return list
tab serology_cluster_p3 AB_ever, col row exact
return list
tab serology_cluster_p3 PCR_ever, col row exact
return list
tab serology_cluster_p3 PCRAB_ever, col row exact
return list
tab serology_cluster_p3 sminet_case_p3DBS, col row exact
return list
bys serology_cluster_p3: sum days_sminet_p3 if days_sminet_p3>0, d
kwallis days_sminet_p3 if days_sminet_p3>0, by(serology_cluster_p3)
disp chi2tail(r(df), r(chi2))
tab serology_cluster_p3 new_sminet_case_p3DBS, col row exact
return list
tab serology_cluster_p3 vaccinated_p3, col row exact
return list
tab serology_cluster_p3 vaccinated_p3_total, col row chi2
return list
bys serology_cluster_p3: sum days_vacc1_p3 if vaccinated_p3==1, d
kwallis days_vacc1_p3 if vaccinated_p3==1, by(serology_cluster_p3)
disp chi2tail(r(df), r(chi2))
bys serology_cluster_p3: sum days_vacc2_p3 if vaccinated_p3_total==3, d
kwallis days_vacc2_p3 if vaccinated_p3_total==3, by(serology_cluster_p3)
disp chi2tail(r(df), r(chi2))
bys serology_cluster_p3: sum days_vacc3_p3 if vaccinated_p3_total==4, d
kwallis days_vacc3_p3 if vaccinated_p3_total==4, by(serology_cluster_p3)
disp chi2tail(r(df), r(chi2))

**TABLE 3
foreach var of varlist ifngr2_p1_robz_T3p5_cat ifngr2_p2_robz_T3p5_cat ifngr2_p3_robz_T3p5_cat  {
tab `var'
}
foreach var of varlist ifnlr1_p1_robz_T3p5_cat ifnlr1_p2_robz_T3p5_cat ifnlr1_p3_robz_T3p5_cat  {
tab `var'
}
foreach var of varlist ifna5_p1_robz_T3p5_cat ifna5_p2_robz_T3p5_cat ifna5_p3_robz_T3p5_cat  {
tab `var'
}
foreach var of varlist ifna6_p1_robz_T3p5_cat ifna6_p2_robz_T3p5_cat ifna6_p3_robz_T3p5_cat  {
tab `var'
}
foreach var of varlist ifnl3_p1_robz_T3p5_cat ifnl3_p2_robz_T3p5_cat ifnl3_p3_robz_T3p5_cat  {
tab `var'
}
foreach var of varlist ifnl2_p1_robz_T3p5_cat ifnl2_p2_robz_T3p5_cat ifnl2_p3_robz_T3p5_cat  {
tab `var'
}
foreach var of varlist ifna2_p1_robz_T3p5_cat ifna2_p2_robz_T3p5_cat ifna2_p3_robz_T3p5_cat  {
tab `var'
}
foreach var of varlist ifna7_p1_robz_T3p5_cat ifna7_p2_robz_T3p5_cat ifna7_p3_robz_T3p5_cat  {
tab `var'
}
foreach var of varlist ifna4_p1_robz_T3p5_cat ifna4_p2_robz_T3p5_cat ifna4_p3_robz_T3p5_cat  {
tab `var'
}
foreach var of varlist ifna1_p1_robz_T3p5_cat ifna1_p2_robz_T3p5_cat ifna1_p3_robz_T3p5_cat  {
tab `var'
}
foreach var of varlist ifna10_p1_robz_T3p5_cat ifna10_p2_robz_T3p5_cat ifna10_p3_robz_T3p5_cat  {
tab `var'
}
foreach var of varlist ifna14_p1_robz_T3p5_cat ifna14_p2_robz_T3p5_cat ifna14_p3_robz_T3p5_cat  {
tab `var'
}
foreach var of varlist ifna8_p1_robz_T3p5_cat ifna8_p2_robz_T3p5_cat ifna8_p3_robz_T3p5_cat  {
tab `var'
}
foreach var of varlist ifna16_p1_robz_T3p5_cat ifna16_p2_robz_T3p5_cat ifna16_p3_robz_T3p5_cat  {
tab `var'
}
foreach var of varlist ifna21_p1_robz_T3p5_cat ifna21_p2_robz_T3p5_cat ifna21_p3_robz_T3p5_cat  {
tab `var'
}
foreach var of varlist ifnar2_p1_robz_T3p5_cat ifnar2_p2_robz_T3p5_cat ifnar2_p3_robz_T3p5_cat  {
tab `var'
}
foreach var of varlist ifna17_p1_robz_T3p5_cat ifna17_p2_robz_T3p5_cat ifna17_p3_robz_T3p5_cat  {
tab `var'
}
foreach var of varlist ifnw1_p1_robz_T3p5_cat ifnw1_p2_robz_T3p5_cat ifnw1_p3_robz_T3p5_cat  {
tab `var'
}
foreach var of varlist ifng_p1_robz_T3p5_cat ifng_p2_robz_T3p5_cat ifng_p3_robz_T3p5_cat  {
tab `var'
}
foreach var of varlist ifnar1_p1_robz_T3p5_cat ifnar1_p2_robz_T3p5_cat ifnar1_p3_robz_T3p5_cat  {
tab `var'
}
foreach var of varlist ifnl1_p1_robz_T3p5_cat ifnl1_p2_robz_T3p5_cat ifnl1_p3_robz_T3p5_cat  {
tab `var'
}
foreach var of varlist ifngr2_robz_3cat-ifnl1_robz_3cat {
tab `var'
}

**TABLE 4
bys total_pop: sum basgran_c19, d
bys total_pop: sum eosgran_c19, d
bys total_pop: sum leukocyt_c19, d
bys total_pop: sum lymfocyt_c19, d
bys total_pop: sum monocyt_c19, d
bys total_pop: sum neutgran_c19, d
bys total_pop: sum erytrocyt_c19, d
bys total_pop: sum evf_c19, d
bys total_pop: sum hemoglobin_c19, d
bys total_pop: sum trombcyt_c19, d
bys total_pop: sum ercMCV_c19, d
bys total_pop: sum ercMCH_c19, d
bys total_pop: sum HbA1c_C19, d
bys serology_cluster_p2: sum basgran_c19 if serology_cluster_p2!=3, d
kwallis basgran_c19 if serology_cluster_p2!=3, by(serology_cluster_p2)
disp chi2tail(r(df), r(chi2))
bys serology_cluster_p2: sum eosgran_c19 if serology_cluster_p2!=3, d
kwallis eosgran_c19 if serology_cluster_p2!=3, by(serology_cluster_p2)
disp chi2tail(r(df), r(chi2))
bys serology_cluster_p2: sum leukocyt_c19 if serology_cluster_p2!=3, d
kwallis leukocyt_c19 if serology_cluster_p2!=3, by(serology_cluster_p2)
disp chi2tail(r(df), r(chi2))
bys serology_cluster_p2: sum lymfocyt_c19 if serology_cluster_p2!=3, d
kwallis lymfocyt_c19 if serology_cluster_p2!=3, by(serology_cluster_p2)
disp chi2tail(r(df), r(chi2))
bys serology_cluster_p2: sum monocyt_c19 if serology_cluster_p2!=3, d
kwallis monocyt_c19 if serology_cluster_p2!=3, by(serology_cluster_p2)
disp chi2tail(r(df), r(chi2))
bys serology_cluster_p2: sum neutgran_c19 if serology_cluster_p2!=3, d
kwallis neutgran_c19 if serology_cluster_p2!=3, by(serology_cluster_p2)
disp chi2tail(r(df), r(chi2))
bys serology_cluster_p2: sum erytrocyt_c19 if serology_cluster_p2!=3, d
kwallis erytrocyt_c19 if serology_cluster_p2!=3, by(serology_cluster_p2)
disp chi2tail(r(df), r(chi2))
bys serology_cluster_p2: sum evf_c19 if serology_cluster_p2!=3, d
kwallis evf_c19 if serology_cluster_p2!=3, by(serology_cluster_p2)
disp chi2tail(r(df), r(chi2))
bys serology_cluster_p2: sum hemoglobin_c19 if serology_cluster_p2!=3, d
kwallis hemoglobin_c19 if serology_cluster_p2!=3, by(serology_cluster_p2)
disp chi2tail(r(df), r(chi2))
bys serology_cluster_p2: sum trombcyt_c19 if serology_cluster_p2!=3, d
kwallis trombcyt_c19 if serology_cluster_p2!=3, by(serology_cluster_p2)
disp chi2tail(r(df), r(chi2))
bys serology_cluster_p2: sum ercMCV_c19 if serology_cluster_p2!=3, d
kwallis ercMCV_c19 if serology_cluster_p2!=3, by(serology_cluster_p2)
disp chi2tail(r(df), r(chi2))
bys serology_cluster_p2: sum ercMCH_c19 if serology_cluster_p2!=3, d
kwallis ercMCH_c19 if serology_cluster_p2!=3, by(serology_cluster_p2)
disp chi2tail(r(df), r(chi2))
bys serology_cluster_p2: sum HbA1c_C19 if serology_cluster_p2!=3, d
kwallis HbA1c_C19 if serology_cluster_p2!=3, by(serology_cluster_p2)
disp chi2tail(r(df), r(chi2))

**SUPPLEMENTARY DATA 3
foreach var of varlist ifngr2_robz_3cat ifnl3_robz_3cat ifna2_robz_3cat ifna8_robz_3cat ifnw1_robz_3cat ifng_robz_3cat ifnar1_robz_3cat ifnl1_robz_3cat{
tab `var' male, col row exact
}

foreach var of varlist ifngr2_robz_3cat ifnl3_robz_3cat ifna2_robz_3cat ifna8_robz_3cat ifnw1_robz_3cat ifng_robz_3cat ifnar1_robz_3cat ifnl1_robz_3cat{
tab `var' bmi_c19_cat, col row exact
}

foreach var of varlist ifngr2_robz_3cat ifnl3_robz_3cat ifna2_robz_3cat ifna8_robz_3cat ifnw1_robz_3cat ifng_robz_3cat ifnar1_robz_3cat ifnl1_robz_3cat{
tab `var' symptoms_2months_q3, col row exact
}

foreach var of varlist ifngr2_robz_3cat ifnl3_robz_3cat ifna2_robz_3cat ifna8_robz_3cat ifnw1_robz_3cat ifng_robz_3cat ifnar1_robz_3cat ifnl1_robz_3cat{
tab `var' symptoms_3months_q3, col row exact
}

foreach var of varlist ifngr2_robz_3cat ifnl3_robz_3cat ifna2_robz_3cat ifna8_robz_3cat ifnw1_robz_3cat ifng_robz_3cat ifnar1_robz_3cat ifnl1_robz_3cat{
tab `var' qc19_1q32_5, col row exact
}

foreach var of varlist ifngr2_robz_3cat ifnl3_robz_3cat ifna2_robz_3cat ifna8_robz_3cat ifnw1_robz_3cat ifng_robz_3cat ifnar1_robz_3cat ifnl1_robz_3cat{
tab `var' sminet_case_p3DBS, col row exact
}

foreach var of varlist ifngr2_robz_3cat ifnl3_robz_3cat ifna2_robz_3cat ifna8_robz_3cat ifnw1_robz_3cat ifng_robz_3cat ifnar1_robz_3cat ifnl1_robz_3cat{
tab `var' vaccinated_p3, col row exact
}

foreach var of varlist ifngr2_robz_3cat ifnl3_robz_3cat ifna2_robz_3cat ifna8_robz_3cat ifnw1_robz_3cat ifng_robz_3cat ifnar1_robz_3cat ifnl1_robz_3cat{
tab `var' serology_cluster_p3, col row exact
}

**SUPPLEMENTARY DATA 4
mlogit ifnar1_robz_3cat symptoms_2months_q3 male bmi_c19_cat serology_cluster_p3, rr
mlogit ifnar1_robz_3cat symptoms_3months_q3 male bmi_c19_cat serology_cluster_p3, rr
mlogit ifngr2_robz_3cat symptoms_2months_q3 male bmi_c19_cat serology_cluster_p3, rr
mlogit ifngr2_robz_3cat symptoms_3months_q3 male bmi_c19_cat serology_cluster_p3, rr
mlogit ifnar1_robz_3cat symptoms_2months_q3 male bmi_c19_cat serology_cluster_p3 qc19_1q32_5, rr
mlogit ifnar1_robz_3cat symptoms_3months_q3 male bmi_c19_cat serology_cluster_p3 qc19_1q32_5, rr
mlogit ifngr2_robz_3cat symptoms_2months_q3 male bmi_c19_cat serology_cluster_p3 qc19_1q32_5, rr
mlogit ifngr2_robz_3cat symptoms_3months_q3 male bmi_c19_cat serology_cluster_p3 qc19_1q32_5, rr
mlogit ifnar1_robz_3cat symptoms_2months_q3 male bmi_c19_cat serology_cluster_p3 qc19_1q32_5 rs2229207_C_0_1, rr
mlogit ifnar1_robz_3cat symptoms_3months_q3 male bmi_c19_cat serology_cluster_p3 qc19_1q32_5 rs2229207_C_0_1, rr
mlogit ifngr2_robz_3cat symptoms_2months_q3 male bmi_c19_cat serology_cluster_p3 qc19_1q32_5 rs2229207_C_0_1, rr
mlogit ifngr2_robz_3cat symptoms_3months_q3 male bmi_c19_cat serology_cluster_p3 qc19_1q32_5 rs2229207_C_0_1, rr