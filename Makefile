YEARS = 2013 2014 2015 2016 2017 2018 2019 2020 2021 2022 2023 2024 2025 2026

URL_2013 = https://www.cityofchicago.org/content/dam/city/depts/obm/supp_info/2013%20Budget/2013BUDGETRECFINAL.pdf
URL_2014 = https://www.cityofchicago.org/content/dam/city/depts/obm/supp_info/2014%20Budget/2014RecBook.pdf
URL_2015 = https://www.cityofchicago.org/content/dam/city/depts/obm/supp_info/2015Budget/2015_Budget_REC_web.pdf
URL_2016 = https://www.cityofchicago.org/content/dam/city/depts/obm/supp_info/2016Budget/2016BudgetRecommendations.pdf
URL_2017 = https://www.cityofchicago.org/content/dam/city/depts/obm/supp_info/2017%20Budget/2017BudgetRecommendations.pdf
URL_2018 = https://www.cityofchicago.org/content/dam/city/depts/obm/supp_info/2018Budget/2018_Budget_Recommendations.pdf
URL_2019 = https://www.cityofchicago.org/content/dam/city/depts/obm/supp_info/2019Budget/2019BudgetRecommendations.pdf
URL_2020 = https://www.cityofchicago.org/content/dam/city/depts/obm/supp_info/2020Budget/2020BudgetRecommendations.pdf
URL_2021 = https://www.chicago.gov/content/dam/city/depts/obm/supp_info/2021Budget/2021%20RECOMMENDATIONS.pdf
URL_2022 = https://www.chicago.gov/content/dam/city/depts/obm/supp_info/2022Budget/2022BudgetRecommendation.pdf
URL_2023 = https://www.chicago.gov/content/dam/city/depts/obm/supp_info/2023Budget/REC%202023.pdf
URL_2024 = https://www.chicago.gov/content/dam/city/depts/obm/supp_info/2024Budget/2024-Budget-Recommendations_CityofChicago.pdf
URL_2025 = https://www.chicago.gov/content/dam/city/depts/obm/supp_info/2025Budget/2025_RecBook_final-Digital.pdf
URL_2026 = https://www.chicago.gov/content/dam/city/depts/obm/supp_info/2026Budget/2026%20Budget%20Recommendation%20Book.pdf

PG_2013 = 43-488
PG_2014 = 44-496
PG_2015 = 45-506
PG_2016 = 55-507
PG_2017 = 46-510
PG_2018 = 45-515
PG_2019 = 50-521
PG_2020 = 50-548
PG_2021 = 49-552
PG_2022 = 52-551
PG_2023 = 53-541
PG_2024 = 55-573
PG_2025 = 52-577
PG_2026 = 52-610

GRANT_PG_2013 = 492-509
GRANT_PG_2014 = 500-517
GRANT_PG_2015 = 510-525
GRANT_PG_2016 = 511-523
GRANT_PG_2017 = 514-527
GRANT_PG_2018 = 519-533
GRANT_PG_2019 = 525-538
GRANT_PG_2020 = 552-565
GRANT_PG_2021 = 556-573
GRANT_PG_2022 = 555-573
GRANT_PG_2023 = 545-562
GRANT_PG_2024 = 577-596
GRANT_PG_2025 = 581-590
GRANT_PG_2026 = 614-624

GRANT_COLS = 470,546,626,691
GRANT_COLS_2021 = 470,546,620,691
GRANT_COLS_2022 = 470,546,620,691
GRANT_COLS_2023 = 470,546,620,691
GRANT_COLS_2024 = 470,546,620,691
GRANT_COLS_2025 = 470,546,620,691
GRANT_COLS_2026 = 470,546,620,691

GENERATED_FILES = output/general.csv output/grants.csv $(foreach y, $(YEARS), output/general/$(y).csv output/grants/$(y).csv)

.PHONY: all clean

.PRECIOUS: output/%.csv input/%.pdf

all: $(GENERATED_FILES)

clean:
	rm -f input/*.pdf output/*.csv output/general/*.csv output/grants/*.csv

output/grants.csv: $(foreach y, $(YEARS), output/grants/$(y).csv)
	csvstack $^ > $@

output/general.csv: $(foreach y, $(YEARS), output/general/$(y).csv)
	csvstack $^ > $@

output/grants/%.csv: input/%.pdf tabula.jar
	java -jar tabula.jar -p $(GRANT_PG_$*) -c $(or $(GRANT_COLS_$*),$(GRANT_COLS)) $< | \
	python scripts/process_grants.py $* > $@

output/general/%.csv: input/%.pdf tabula.jar
	java -jar tabula.jar -p $(PG_$*) -c 283,366,437,507,579 $< | \
	python scripts/process_pdf.py $* > $@

input/%.pdf:
	wget -O $@ $(URL_$*)

tabula.jar:
	wget -O $@ https://github.com/tabulapdf/tabula-java/releases/download/v1.0.2/tabula-1.0.2-jar-with-dependencies.jar
