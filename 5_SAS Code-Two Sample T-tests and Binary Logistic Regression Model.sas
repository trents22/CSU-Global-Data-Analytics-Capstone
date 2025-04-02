ods noproctitle;
ods graphics / imagemap=on;

*******************************************************************************************************;

*TWO-SAMPLE T-TESTS;
*T-test rpm;
proc ttest data=MIS581.ENGINE sides=2 h0=0 plots=none;
	class engine_condition;
	var rpm;
run;

*T-test Fuel pressure;
proc ttest data=MIS581.ENGINE sides=2 h0=0 plots=none;
	class engine_condition;
	var fuel_pres;
run;

*T-test Coolant pressure;
proc ttest data=MIS581.ENGINE sides=2 h0=0 plots=none;
	class engine_condition;
	var coolant_pres;
run;

*T-test Coolant temperature;
proc ttest data=MIS581.ENGINE sides=2 h0=0 plots=none;
	class engine_condition;
	var coolant_temp;
run;

*T-test Oil pressure;
proc ttest data=MIS581.ENGINE sides=2 h0=0 plots=none;
	class engine_condition;
	var oil_pres;
run;

*T-test Oil temperature;
proc ttest data=MIS581.ENGINE sides=2 h0=0 plots=none;
	class engine_condition;
	var oil_temp;
run;

*******************************************************************************************************;

*BINARY LOGSITIC REGRESSION;
*Model creation with training data;
proc logistic data=MIS581.ENGINE_TRAIN outmodel=ENGINE_MODEL plots(maxpoints=none);
	model engine_condition(event='0') = rpm fuel_pres coolant_pres coolant_temp 
		oil_pres oil_temp / link=logit selection=backward slstay=0.05 
		hierarchy=single technique=fisher;
run;

*****MODEL ANALYSIS WITH TRAINING DATA*****
*Score the training dataset using the saved model;
proc logistic inmodel=ENGINE_MODEL;
    score data=MIS581.ENGINE_TRAIN 
          outroc=ROC_TRAIN
          out=PRED_TRAIN;
run;

*Prepare the ROC dataset by renaming variables;
data ROC_TRAIN2;
    set ROC_TRAIN;
    false_positive_rate = _1MSPEC_;
    true_positive_rate  = _SENSIT_;
run;

*Plot the ROC curve for the training data;
proc sgplot data=ROC_TRAIN2;
    series x=false_positive_rate y=true_positive_rate / markers;
    lineparm x=0 y=0 slope=1 / lineattrs=(pattern=shortdash);
    xaxis label="False Positive Rate";
    yaxis label="True Positive Rate";
    title "ROC Curve for Training Data";
run;

*Create a predicted classification variable based on a 0.5 cutoff;
data PRED_TRAIN;
    set PRED_TRAIN;
    if P_0 >= 0.5 then pred_class = '0';
    else pred_class = '1';
    correct = (engine_condition = pred_class);
run;

*Create a confusion matrix;
proc tabulate data=PRED_TRAIN;
    class engine_condition pred_class;
    table engine_condition='Actual',
          (pred_class='Predicted' all)*(n='Count')
          / misstext='0';
    title "Confusion Matrix for Training Data";
run;

data CONFUSION_TRAIN;
    set PRED_TRAIN;
    *Event of interest = '0' (positive). 0 shows a maintenance event;
    if engine_condition = '0' and pred_class = '0' then TP = 1; else TP = 0;
    if engine_condition = '0' and pred_class = '1' then FN = 1; else FN = 0;
    if engine_condition = '1' and pred_class = '0' then FP = 1; else FP = 0;
    if engine_condition = '1' and pred_class = '1' then TN = 1; else TN = 0;
run;

*Summarize TP, FP, TN, FN;
proc means data=CONFUSION_TRAIN noprint;
    var TP FN FP TN;
    output out=STATS_TRAIN sum=TP_sum FN_sum FP_sum TN_sum;
run;

*Calculate sensitivity, specificity, sccuracy;
data METRICS_TRAIN;
    set STATS_TRAIN;
    sensitivity = TP_sum / (TP_sum + FN_sum);
    specificity = TN_sum / (TN_sum + FP_sum);
    accuracy    = (TP_sum + TN_sum) / (TP_sum + TN_sum + FP_sum + FN_sum);
run;

*Clean up table;
proc print data=METRICS_TRAIN noobs label;
    var sensitivity specificity accuracy;
    format sensitivity specificity accuracy percent8.2;
    label sensitivity = "Sensitivity"
          specificity = "Specificity"
          accuracy    = "Accuracy";
    title "Model Performance Metrics for Training Data (Event = '0')";
run;

*****MODEL ANALYSIS WITH VALIDATION DATA*****
*Score the validation dataset using the saved model;
proc logistic inmodel=ENGINE_MODEL;
    score data=MIS581.ENGINE_VALIDATION 
          outroc=ROC_VALIDATION
          out=PRED_VALIDATION;
run;

*Prepare the ROC dataset by renaming variables;
data ROC_VALIDATION2;
    set ROC_VALIDATION;
    false_positive_rate = _1MSPEC_;
    true_positive_rate  = _SENSIT_;
run;

*Plot the ROC curve for the validation data;
proc sgplot data=ROC_VALIDATION2;
    series x=false_positive_rate y=true_positive_rate / markers;
    lineparm x=0 y=0 slope=1 / lineattrs=(pattern=shortdash);
    xaxis label="False Positive Rate";
    yaxis label="True Positive Rate";
run;

*Create a predicted classification variable based on a 0.5 cutoff;
data PRED_VALIDATION;
    set PRED_VALIDATION;
    if P_0 >= 0.5 then pred_class = '0';
    else pred_class = '1';
    correct = (engine_condition = pred_class);
run;

*Create a confusion matrix;
proc tabulate data=PRED_VALIDATION;
    class engine_condition pred_class;
    table engine_condition='Actual',
          (pred_class='Predicted' all)*(n='Count')
          / misstext='0';
    title "Confusion Matrix for Validation Data";
run;

data CONFUSION_VALIDATION;
    set PRED_VALIDATION;
    *Event of interest = '0' (positive). 0 shows a maintenance event;
    if engine_condition = '0' and pred_class = '0' then TP = 1; else TP = 0;
    if engine_condition = '0' and pred_class = '1' then FN = 1; else FN = 0;
    if engine_condition = '1' and pred_class = '0' then FP = 1; else FP = 0;
    if engine_condition = '1' and pred_class = '1' then TN = 1; else TN = 0;
run;

*Summarize TP, FP, TN, FN;
proc means data=CONFUSION_VALIDATION noprint;
    var TP FN FP TN;
    output out=STATS_VALIDATION sum=TP_sum FN_sum FP_sum TN_sum;
run;

*Calculate sensitivity, specificity, sccuracy;
data METRICS_VALIDATION;
    set STATS_VALIDATION;
    sensitivity = TP_sum / (TP_sum + FN_sum);
    specificity = TN_sum / (TN_sum + FP_sum);
    accuracy    = (TP_sum + TN_sum) / (TP_sum + TN_sum + FP_sum + FN_sum);
run;

*Clean up table;
proc print data=METRICS_VALIDATION noobs label;
    var sensitivity specificity accuracy;
    format sensitivity specificity accuracy percent8.2;
    label sensitivity = "Sensitivity"
          specificity = "Specificity"
          accuracy    = "Accuracy";
    title "Model Performance Metrics for Validation Data (Event = '0')";
run;
