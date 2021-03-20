mkdir -p systems

# This is expensive, try to be a good citizen and not use all the server resources at once...

# first run pre-computes wdata
Rscript generate_wdraws.R 

for sys in "xj4wang_run1" "run1" "BBGhelani2" "cu_dbmi_bm25_2" "IRIT_marked_base" "OHSU_RUN2" "sab20.1.meta.docs" "T5R1" "UIUC_DMG_setrank_ret" "BioinfoUA-emb" "UP-rrf5rnd1" "dmis-rnd1-run3"
do
    Rscript generate_urisk_2.R "$sys" & 
done
wait

for sys in "PS-r1-bm25all" "uogTrDPH_QE" "Technion-JPD" "smith.rm3" "elhuyar_rRnk_cbert" "azimiv_wk1" "jlbase" "poznan_runi1" "10x20.prf.unipd.it" "UIowaS_Run3" "SinequaR1_2" "bm25t5" "baseline"
do
    Rscript generate_urisk_2.R "$sys" & 
done
wait

for sys in "ixa-ir-filter-query" "NTU_NMLAB_BM25_Hum2" "KU_run3" "udel_fang_run2" "SINEQUA" "wistud_bing" "TU_Vienna_TKL_1" "RMITBM1" "ir_covid19_cle_dfr" "CSIROmed_PE" "BITEM_df" "irc_pubmed" "tcs_ilabs_gg_r1" "sheikh_bm25_all" "UB_NLP_RUN_1" "CBOWexp.0" 
do
    Rscript generate_urisk_2.R "$sys" & 
done
wait

Rscript build_dataset.R 1
Rscript build_dataset.R 2
