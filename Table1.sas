/*Table1*/
/*detail crude(supple)*/
proc surveyfreq data=b.kyrbs_12_22 nomcar;
table region*period sex*period bmi_g*period alcohol_freq*period smoking*period PARENTS_EDU*period
e_ses*period e_s_rcrd*period depression*period violence*period /cl row column; run;

/*total crude(supple)*/
proc surveyfreq data=b.kyrbs_12_22 nomcar;
table region sex bmi_g alcohol_freq smoking PARENTS_EDU
e_ses e_s_rcrd depression violence /cl row column; run;

/*about age*/
proc means data=b.kyrbs_12_22 mean std; var age ; run;
proc means data=b.kyrbs_12_22 mean std; var age ; class period; run;
proc sort data= b.kyrbs_12_22; by period; run;

/*weighted total*/
proc surveyfreq data=b.kyrbs_12_22 nomcar;
strata strata;
cluster cluster;
weight weight;
table
sex 
region
parents_edu
smoking
alcohol_freq
bmi_g
e_s_rcrd
e_ses 
depression
violence
/cl row column;
 run;

/*weighted detail(period)*/
proc surveyfreq data=b.kyrbs_12_22;
strata strata;
cluster cluster;
weight weight;
table 
region*period 
sex*period
bmi_g*period 
alcohol_freq*period 
smoking*period 
edu_m*period 
edu_f*period 
parents_edu*period
e_ses*period 
e_s_rcrd*period 
depression*period 
violence*period
/cl row column;
run;
