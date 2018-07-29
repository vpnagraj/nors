/* code for linegraph of foodborne illness outbreaks by month and etiology */

#delim ;
import delimited ../data/count_by_month_wide.csv, clear;

line salmonella month, lwidth(vthick) col("0 158 115") ylabel(0(50)450)

|| line norovirus month, lwidth(vthick) col("86 180 233")

|| line campylobacter month, lwidth(vthick) col("black")

|| line staph month, lwidth(vthick) col("240 228 66")

|| line clostridium month, lwidth(vthick) col("230 159 0")

|| line total month, lwidth(vthick) lpattern(dot) col("gray")

title(Total Number of Foodborne Outbreaks by Month and Etiology)
subtitle(United States (1998-2016))
note("Data Source: NORS")
xlabel(1(1)12)
ylabel(0(50)700, angle(horizontal))
scheme(s1manual)
;

graph export ../plots/linegraph_by_month_etiology.png;
