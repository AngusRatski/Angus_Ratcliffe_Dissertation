import excel "C:\Users\angus\OneDrive\Documents\Dissertation\Data\Gravity Model.xlsx", sheet("Sheet1") cellrange(A1:Y1316) firstrow

# Alias variable names
rename lnGDPProduct lnGDPProd
rename GDPDistance GDPDist
rename GCFDistance GCFDist
rename CommonOfficialLanguage ComOffLang

# Clean data
drop GoodsValueofExportsFreeon GoodsValueofImportsCostI GoodsValueofImportsFreeon TradeVolume GDPCurrentUS UKGDPCurrentUS WorldGDPCurrentUS
replace lnTrade=. if lnTrade==0
replace lnGDPProd=. if lnGDPProd==0
replace GDPDist=. if GDPDist==0
replace Remoteness=. if Remoteness==0
replace PartnerGrossCapitalFormation=. if PartnerGrossCapitalFormation==0
replace GCFDist=. if GCFDist==0
replace GCFDist=. if PartnerGrossCapitalFormation==.

# Install ppml
ssc install ppml

# OLS regression of traditional model
reg lnTrade lnGDPProd lnDist

# Fixed Effects
global id id
global t t
global ylist lnTrade
global xlist lnGDPProd GDPDist Remoteness
sort $id $t
xtset $id $t
xtreg $ylist $xlist Scale GCFDist ComOffLang FTA, fe robust

# Hypothesis testing
test Scale
test FTA

# Hausman diagnostic test
quietly xtreg $ylist $xlist Scale GCFDist ComOffLang FTA, fe 
estimates store fixed
quietly xtreg $ylist $xlist Scale GCFDist ComOffLang FTA, re 
estimates store random
hausman fixed random

# PPML regression
ppml lnTrade lnGDPProd GDPDist Remoteness Scale GCFDist ComOffLang FTA