/* code to create barplot of foodborne illness outbreak counts by etiology */

#delim ;

import delimited ../data/count_by_etiology.csv, clear;

graph hbar (first) count, over(etiology, sort(count) descending) 
ytitle(Total Number of Outbreaks) 
ylabel(#10, format(%9.0f)) 
title(Distribution of Foodborne Outbreaks by Etiology)
subtitle(United States (1998-2016))
note("Data Source: NORS")
scheme(s1manual);

graph export ../plots/barplot_by_etiology.png;
