# NORS Visualizations

---

Food contaminated with viruses, bacteria or parasites can lead to illness when consumed by humans. According to the Centers for Disease Control and Prevention (CDC), in the United States the five most common microbial causes of foodborne illness are: Norovirus, Salmonella, Clostridium perfringens, Campylobacter and Staphylococcus aureus (Staph). Using publicly available data, one can describe and compare the prevalence of outbreaks caused by these germs, as well as characterize seasonal (by year or month) and geographic (by state or region) variation in these events. There are a number of studies of foodborne illness outbreaks in the United States, including some that specifically investigate seasonal and geographic characteristics. This brief aims to provide descriptive visualizations that facilitate comparisons between the burden of disease caused by each of these five germs. 

The code generates visualizations based on data retrieved from the National Outbreak Reporting System (NORS) Dashboard: 

<https://wwwn.cdc.gov/norsdashboard/>

---

To replicate the analysis:

1. Clone this repository
2. Download the NORS data from 1998-2016 using the "Download all NORS Dashboard data (Excel)" link at the site above
3. Convert the `.xslx` file to `.csv`
4. Place the `NationalOutbreakPublicDataTool.csv` file in the `data/` directory
5. Run the `prep.R` script to generate intermediary datasets ()
6. Run the visualization scripts of interest (located in `misc/`, `geographic/` and `seasonal/`)

Note that the visualization scripts are written relative to the root of this repository structure. Before running them make sure that the `prep.R` script has generated the prepped datasets, and that you are using the appropriate working directory.

For example, the following will generate the choropleth maps if you have the NORS data in the `data/` folder and you begin working from the repository root:

```
source("prep.R")
setwd("geographic")
source("choropleth.R")
```

