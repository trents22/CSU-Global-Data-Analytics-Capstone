ods noproctitle;
ods graphics / imagemap=on;

*******************************************************************************************************;

*DATA CLEANING (DROP 2 OUTLIERS);
*Drop outlier (coolant temperature) rows 2424 and 15124;
data MIS581.OUTLIER_ENGINE;
    set MIS581.ENGINE;
    if _N_ = 15124 then delete;
    if _N_ = 2424 then delete;
run;

*******************************************************************************************************;

*DESCRIPTIVE ANALYTICS;
*Summary statistics for numeric variables;
proc means data=MIS581.OUTLIER_ENGINE chartype mean std min max median nmiss vardef=df 
		qmethod=os;
	var rpm oil_pres fuel_pres coolant_pres oil_temp coolant_temp;
run;

*Summary statistics for numeric variables grouped by engine condition;
proc means data=MIS581.OUTLIER_ENGINE chartype mean std min max median nmiss vardef=df 
		qmethod=os;
	var rpm oil_pres fuel_pres coolant_pres oil_temp coolant_temp;
	class engine_condition;
run;

*Correlation analysis;
proc corr data=MIS581.OUTLIER_ENGINE pearson nosimple noprob plots=none;
	var rpm oil_pres fuel_pres coolant_pres oil_temp coolant_temp;
run;

*One-way frequency for engine condition;
proc freq data=MIS581.OUTLIER_ENGINE;
	tables engine_condition / nocum;
run;

*Distribution analysis;
proc univariate data=MIS581.OUTLIER_ENGINE;
	ods select Histogram;
	var rpm oil_pres fuel_pres coolant_pres oil_temp coolant_temp;
	histogram rpm oil_pres fuel_pres coolant_pres oil_temp coolant_temp / normal;
	inset mean median skewness kurtosis / position=ne;
run;
