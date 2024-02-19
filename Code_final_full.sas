libname a 'C:\Users\user\OneDrive\?? ??\????\KYRBS\data'; /*for new data*/
libname b 'C:\Users\user\OneDrive\?? ??\????\KYRBS\data'; /*for new data*/

/*data preprocessing*/
/*columns extract*/
data kyrbs2012; set a.kyrbs2012; keep V_TRT strata cluster w obs year ctype age sex ht wt ac_days tc_lt e_edu_m e_edu_f e_ses e_s_rcrd m_sad  grade; run;
data kyrbs2013; set a.kyrbs2013; keep V_TRT strata cluster w obs year ctype age sex ht wt ac_days tc_lt e_edu_m e_edu_f e_ses e_s_rcrd m_sad  grade; run;
data kyrbs2014; set a.kyrbs2014; keep V_TRT strata cluster w obs year ctype age sex ht wt ac_days tc_lt e_edu_m e_edu_f e_ses e_s_rcrd m_sad  grade; run;
data kyrbs2015; set a.kyrbs2015; keep V_TRT strata cluster w obs year ctype age sex ht wt ac_days tc_lt e_edu_m e_edu_f e_ses e_s_rcrd m_sad  grade; run;
data kyrbs2016; set a.kyrbs2016; keep V_TRT strata cluster w obs year ctype age sex ht wt ac_days tc_lt e_edu_m e_edu_f e_ses e_s_rcrd m_sad  grade; run;
data kyrbs2017; set a.kyrbs2017; keep V_TRT strata cluster w obs year ctype age sex ht wt ac_days tc_lt e_edu_m e_edu_f e_ses e_s_rcrd m_sad  grade; run;
data kyrbs2018; set a.kyrbs2018; keep V_TRT strata cluster w obs year ctype age sex ht wt ac_days tc_lt e_edu_m e_edu_f e_ses e_s_rcrd m_sad  grade; run;
data kyrbs2019; set a.kyrbs2019; keep V_TRT strata cluster w obs year ctype age sex ht wt ac_days tc_lt e_edu_m e_edu_f e_ses e_s_rcrd m_sad  grade; run;
data kyrbs2020; set a.kyrbs2020; keep V_TRT strata cluster w obs year ctype age sex ht wt ac_days tc_lt e_edu_m e_edu_f e_ses e_s_rcrd m_sad  grade; run;
data kyrbs2021; set a.kyrbs2021; keep V_TRT strata cluster w obs year ctype age sex ht wt ac_days tc_lt e_edu_m e_edu_f e_ses e_s_rcrd m_sad  grade; run;
data kyrbs2022; set a.kyrbs2022; keep V_TRT strata cluster w obs year ctype age sex ht wt ac_days tc_lt e_edu_m e_edu_f e_ses e_s_rcrd m_sad  grade; run;

/*total*/
data kyrbs_12_22; set kyrbs2012 kyrbs2013 kyrbs2014 kyrbs2015 kyrbs2016 kyrbs2017 kyrbs2018 kyrbs2019 kyrbs2020 kyrbs2021 kyrbs2022; run; 
/*n=693,517*/

/*for checking*/
proc freq data=kyrbs_12_22; table V_TRT; run;

/*checking missing data*/
/*continuous value about missing data*/
proc means data=kyrbs_12_22 min max;
class sex;
var ht wt;
run;
/*categorical value about missing data*/
proc freq data=kyrbs_12_22; table ctype age sex ac_days tc_lt e_edu_m e_edu_f e_ses e_s_rcrd m_sad; run;
/*age=3147, E_EDU_M=2, E_EDU_F=1, E_SES(ecnomic)=3, E_S_RCRD(study)=2*/

/*residence*/
proc freq data=b.kyrbs_12_22; table ctype; run;
data b.kyrbs_12_22; set kyrbs_12_22;
if ctype='???' then region=1;
else region=2; run;
proc freq data=b.kyrbs_12_22; table region; run;

/*age*/
proc means data=b.kyrbs_12_22 min max; var age; run;
data b.kyrbs_12_22; set b.kyrbs_12_22;
if age in (8888 9999 .)  then delete; run; 
/*n=693,517-->690,370*/
proc freq data=b.kyrbs_12_22; table ctype age sex ac_days tc_lt e_edu_m e_edu_f e_ses e_s_rcrd m_sad; run;

/*sex*/
proc freq data=b.kyrbs_12_22; table sex; run;

/*bmi*/
data b.kyrbs_12_22; set b.kyrbs_12_22;
h_100=ht/100; 
bmi=wt/(h_100*h_100); run;
data b.kyrbs_12_22; set b.kyrbs_12_22;
drop h_100; run;

proc means data= b.kyrbs_12_22 min max; var bmi; run;
proc sort data= b.kyrbs_12_22; by bmi; run;

proc means data= b.kyrbs_12_22 p5 p95;
var bmi; run;

data b.kyrbs_12_22; set b.kyrbs_12_22;
if 10<=bmi< 16.4365549 then bmi_g=1; *underweight;
else if  16.4365549<bmi<24.524346347 then bmi_g=2; *normal;
else if 24.524346347<=bmi<27.6225028 then bmi_g=3; *overweight;
else if 27.6225028<=bmi then bmi_g=4; *obese;
else bmi_g=0; *unknown;
run;

/*drinking*/
proc freq data=b.kyrbs_12_22; table AC_DAYS; run;
data b.kyrbs_12_22; set b.kyrbs_12_22;
if AC_DAYS=2 or AC_DAYS=3 then alcohol_freq=1;
else if 4<=AC_DAYS<=7 then alcohol_freq=2;
else alcohol_freq=0; run;
proc freq data=b.kyrbs_12_22; table alcohol_freq; run;

/*smoking*/
proc freq data=b.kyrbs_12_22; table TC_LT; run;
data b.kyrbs_12_22; set b.kyrbs_12_22;
if TC_LT=1 then smoking =0;
else if TC_LT=2 then smoking=1;
run;

/*economic status*/
proc freq data=b.kyrbs_12_22; table e_ses; run;
data b.kyrbs_12_22; set b.kyrbs_12_22;
if e_ses=. then delete; run; 
proc freq data=b.kyrbs_12_22; table e_ses; run;
/*n=690,370-->690,367*/

/*academic*/
proc freq data=b.kyrbs_12_22; table e_s_rcrd; run;
data b.kyrbs_12_22; set b.kyrbs_12_22; run; 

/*depression*/
proc freq data=b.kyrbs_12_22; table m_sad; run;
data b.kyrbs_12_22; set b.kyrbs_12_22;
if m_sad=1 then depression=0;
else if m_sad=2 then depression=1;
run;
proc freq data=b.kyrbs_12_22; table depression; run; 

/*parents academic*/
data b.kyrbs_12_22; set b.kyrbs_12_22;
if E_EDU_M=1 or E_EDU_M=2 then EDU_M=1; 
else if E_EDU_M=3 then EDU_M=2; 
else EDU_M=0;
run;
/*unknown processing*/
proc freq data=b.kyrbs_12_22; table EDU_M; run;

data b.kyrbs_12_22; set b.kyrbs_12_22;
if e_edu_f=1 or e_edu_f=2 then edu_f=1; 
else if e_edu_f=3 then edu_f=2; 
else edu_f=0;
run; 

proc freq data=b.kyrbs_12_22; table edu_f; run;
proc freq data=b.kyrbs_12_22; table EDU_M edu_f; run;

/*parents academic setting using max*/
data b.kyrbs_12_22; set b.kyrbs_12_22;
PARENTS_EDU=max(EDU_M, edu_f); run;

proc freq data=b.kyrbs_12_22; table PARENTS_EDU; run;
data b.kyrbs_12_22; set b.kyrbs_12_22;
PARENTS_EDU=max(EDU_M, edu_f); run;

/*violence*/
proc freq data=b.kyrbs_12_22; table V_TRT; run;
data b.kyrbs_12_22; set b.kyrbs_12_22;
if V_TRT=1 then violence=0;
else violence=1;
run;
proc freq data=b.kyrbs_12_22; table violence; run;

/*periods group 2012-2014 2015-2017 2018-2019 2020 2021 2022*/
data b.kyrbs_12_22; set b.kyrbs_12_22;
if 2012<=year<=2014 then period=1;
else if 2015<=year<=2017 then period=2;
else if 2018<=year<=2019 then period=3;
else if 2020=year then period=4;
else if 2021=year then period=5;
else if 2022=year then period=6; run;

/*weight ratio*/
data b.kyrbs_12_22; set b.kyrbs_12_22;
if period=1 then do;
weight=w*(1/3); end; 
if period=2 then do;
weight=w*(1/3); end; 
if period=3 then do;
weight=w*(1/2); end; 
if period=4 then do;
weight=w; end;
if period=5 then do;
weight=w; end;
if period=6 then do;
weight=w; end;
run;

/*about pandemic*/
data before_pandemic; set b.kyrbs_12_22;
if period in (1 2 3) then output before_pandemic; run;
proc freq data=before_pandemic; table period; run;

data after_pandemic ;set b.kyrbs_12_22;
if period in (3 4 5 6) then output after_pandemic; run;
proc freq data=after_pandemic; table period; run;


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

/*Table2*/
/*binary processing_violence(dg)*/
data vio_1; set b.kyrbs_12_22;

/*violence prevalence*/
if violence=0 then vio_dg=0;
else if violence=1 then vio_dg=1;

if violence=1 and sex=1 then vio_male=1;
else if violence=0 and sex=1 then vio_male=0;
if violence=1 and sex=2 then vio_female=1;
else if violence=0 and sex=2 then vio_female=0;

if violence=1 and e_s_rcrd=1 then vio_grade1=1;
else if violence=0 and e_s_rcrd=1 then vio_grade1=0;
if violence=1 and e_s_rcrd=2 then vio_grade2=1;
else if violence=0 and e_s_rcrd=2 then vio_grade2=0;
if violence=1 and e_s_rcrd=3 then vio_grade3=1;
else if violence=0 and e_s_rcrd=3 then vio_grade3=0;
if violence=1 and e_s_rcrd=4 then vio_grade4=1;
else if violence=0 and e_s_rcrd=4 then vio_grade4=0;
if violence=1 and e_s_rcrd=5 then vio_grade5=1;
else if violence=0 and e_s_rcrd=5 then vio_grade5=0;

if violence=1 and e_ses=1 then vio_econ1=1;
else if violence=0 and e_ses=1 then vio_econ1=0;
if violence=1 and e_ses=2 then vio_econ2=1;
else if violence=0 and e_ses=2 then vio_econ2=0;
if violence=1 and e_ses=3 then vio_econ3=1;
else if violence=0 and e_ses=3 then vio_econ3=0;
if violence=1 and e_ses=4 then vio_econ4=1;
else if violence=0 and e_ses=4 then vio_econ4=0;
if violence=1 and e_ses=5 then vio_econ5=1;
else if violence=0 and e_ses=5 then vio_econ5=0;

if violence=1 and smoking=0 then vio_smk0=1;
else if violence=0 and smoking=0 then vio_smk0=0;
if violence=1 and smoking=1 then vio_smk1=1;
else if violence=0 and smoking=1 then vio_smk1=0;

if violence=1 and alcohol_freq=0 then vio_alcohol0=1;
else if violence=0 and alcohol_freq=0 then vio_alcohol0=0;
if violence=1 and alcohol_freq=1 then vio_alcohol1=1;
else if violence=0 and alcohol_freq=1 then vio_alcohol1=0;
if violence=1 and alcohol_freq=2 then vio_alcohol2=1;
else if violence=0 and alcohol_freq=2 then vio_alcohol2=0;

if violence=1 and bmi_g=0 then vio_bmi0=1;
else if violence=0 and bmi_g=0 then vio_bmi0=0;
if violence=1 and bmi_g=1 then vio_bmi1=1;
else if violence=0 and bmi_g=1 then vio_bmi1=0;
if violence=1 and bmi_g=2 then vio_bmi2=1;
else if violence=0 and bmi_g=2 then vio_bmi2=0;
if violence=1 and bmi_g=3 then vio_bmi3=1;
else if violence=0 and bmi_g=3 then vio_bmi3=0;
if violence=1 and bmi_g=4 then vio_bmi4=1;
else if violence=0 and bmi_g=4 then vio_bmi4=0;

if violence=1 and region=1 then vio_urban=1;
else if violence=0 and region=1 then vio_urban=0;
if violence=1 and region=2 then vio_rural=1;
else if violence=0 and region=2 then vio_rural=0;

if violence=1 and depression=0 then vio_sad0=1;
else if violence=0 and depression=0 then vio_sad0=0;
if violence=1 and depression=1 then vio_sad1=1;
else if violence=0 and depression=1 then vio_sad1=0;

if violence=1 and parents_edu=0 then vio_p_edu0=1;
else if violence=0 and parents_edu=0 then vio_p_edu0=0;
if violence=1 and parents_edu=1 then vio_p_edu1=1;
else if violence=0 and parents_edu=1 then vio_p_edu1=0;
if violence=1 and parents_edu=2 then vio_p_edu2=1;
else if violence=0 and parents_edu=2 then vio_p_edu2=0;
run;

data b.vio_1; set vio_1; run;

/*violence for table*/
proc surveyfreq data=b.vio_1 nomcar;
strata strata;
cluster cluster;
weight weight;
by period;
table 
vio_male
vio_female
vio_urban
vio_rural
vio_p_edu0
vio_p_edu1
vio_p_edu2
vio_smk0
vio_smk1
vio_alcohol0
vio_alcohol1
vio_alcohol2
vio_bmi0
vio_bmi1
vio_bmi2
vio_bmi3
vio_bmi4
vio_grade1
vio_grade2
vio_grade3
vio_grade4
vio_grade5
vio_econ1
vio_econ2
vio_econ3
vio_econ4
vio_econ5
vio_sad0
vio_sad1
vio_dg
/cl row column; 
run;


/*Table 2 for pan19*/
/*for checking*/
proc freq data=b.vio_1;
table 
year*vio_dg
/nofreq nocol nocum nopercent ; 
run;

data b.vio_2;
set b.vio_1;
run;

data before_pan19 during_pan19;
set b.vio_2;
if period in (1 2 3) then output before_pan19;
if period in (3 4 5 6) then output during_pan19;
run;

/*overall B value*/
ods graphics off;
ods select ParameterEstimates; PROC SURVEYreg DATA=before_pan19 NOMCAR;   STRATA STRATA;   CLUSTER CLUSTER;   WEIGHT WEIGHT;   MODEL vio_dg=period / stb clparm   ;  RUN; 
ods select ParameterEstimates; PROC SURVEYreg DATA=during_pan19 NOMCAR;   STRATA STRATA;   CLUSTER CLUSTER;   WEIGHT WEIGHT;   MODEL vio_dg=period / stb clparm   ;  RUN;

/*before pan B value*/
%macro beta_b(var_name);
ods graphics off;
ods select ParameterEstimates; 
PROC SURVEYreg DATA=before_pan19 NOMCAR;  
	STRATA strata;   
	CLUSTER cluster;   
	WEIGHT WEIGHT;  
	MODEL &var_name = period / stb clparm;  RUN;
%mend;

/*before pandemic each var*/
%beta_b(vio_male);
%beta_b(vio_female);
%beta_b(vio_urban); 
%beta_b(vio_rural);
%beta_b(vio_p_edu0);
%beta_b(vio_p_edu1);
%beta_b(vio_p_edu2);
%beta_b(vio_smk0);
%beta_b(vio_smk1);
%beta_b(vio_alcohol0);
%beta_b(vio_alcohol1);
%beta_b(vio_alcohol2);
%beta_b(vio_bmi0);
%beta_b(vio_bmi1);
%beta_b(vio_bmi2);
%beta_b(vio_bmi3);
%beta_b(vio_bmi4);
%beta_b(vio_grade1);
%beta_b(vio_grade2);
%beta_b(vio_grade3);
%beta_b(vio_grade4);
%beta_b(vio_grade5);
%beta_b(vio_econ1);
%beta_b(vio_econ2);
%beta_b(vio_econ3);
%beta_b(vio_econ4);
%beta_b(vio_econ5);
%beta_b(vio_sad0);
%beta_b(vio_sad1);
%beta_b(vio_dg);

/*during pan B value*/
%macro beta_b(var_name);
ods graphics off;
ods select ParameterEstimates; 
PROC SURVEYreg DATA=during_pan19 NOMCAR;  
	STRATA strata;   
	CLUSTER cluster;   
	WEIGHT WEIGHT;  
	MODEL &var_name = period / stb clparm;  RUN;
%mend;

/*during pandemic each var*/
%beta_b(vio_male);
%beta_b(vio_female);
%beta_b(vio_urban);
%beta_b(vio_rural);
%beta_b(vio_p_edu0);
%beta_b(vio_p_edu1);
%beta_b(vio_p_edu2);
%beta_b(vio_smk0);
%beta_b(vio_smk1);
%beta_b(vio_alcohol0);
%beta_b(vio_alcohol1);
%beta_b(vio_alcohol2);
%beta_b(vio_bmi0);
%beta_b(vio_bmi1);
%beta_b(vio_bmi2);
%beta_b(vio_bmi3);
%beta_b(vio_bmi4);
%beta_b(vio_grade1);
%beta_b(vio_grade2);
%beta_b(vio_grade3);
%beta_b(vio_grade4);
%beta_b(vio_grade5);
%beta_b(vio_econ1);
%beta_b(vio_econ2);
%beta_b(vio_econ3);
%beta_b(vio_econ4);
%beta_b(vio_econ5);
%beta_b(vio_sad0);
%beta_b(vio_sad1);
%beta_b(vio_dg);

/*Table3*/
/*risk factor*/
data b.risk_1;
set b.vio_2;
run;

/*for checking*/
proc freq data=b.risk_1;
table region sex bmi_g alcohol_freq smoking PARENTS_EDU e_ses e_s_rcrd depression violence;
run;

/*pandamic var*/
data bf_risk dur_risk;
set b.risk_1;
if period in (1 2 3) then output bf_risk;
if period in (3 4 5 6) then output dur_risk;
run;

/*overall*/
%macro risk_factor(ref_value, class_variable);

PROC SURVEYLogistic data=b.risk_1 nomcar;
strata strata;
cluster cluster;
weight weight;
class &class_variable (ref=&ref_value) / param=ref;
model vio_dg (event='1')=&class_variable;

run;
%mend;

%risk_factor('1', sex)
%risk_factor('2', sex)
%risk_factor('1', region)
%risk_factor('2', region)
%risk_factor('0', PARENTS_EDU)
%risk_factor('1', PARENTS_EDU)
%risk_factor('2', PARENTS_EDU)
%risk_factor('0', alcohol_freq)
%risk_factor('1', alcohol_freq)
%risk_factor('2', alcohol_freq)
%risk_factor('0', smoking)
%risk_factor('1', smoking)
%risk_factor('0', bmi_g)
%risk_factor('1', bmi_g)
%risk_factor('2', bmi_g)
%risk_factor('3', bmi_g)
%risk_factor('4', bmi_g)
%risk_factor('0', depression)
%risk_factor('1', depression)
%risk_factor('1', e_ses)
%risk_factor('2', e_ses)
%risk_factor('3', e_ses)
%risk_factor('4', e_ses)
%risk_factor('5', e_ses)
%risk_factor('1', e_s_rcrd)
%risk_factor('2', e_s_rcrd)
%risk_factor('3', e_s_rcrd)
%risk_factor('4', e_s_rcrd)
%risk_factor('5', e_s_rcrd)

/*before pan*/
%macro risk_factor(ref_value, class_variable);

PROC SURVEYLogistic data=bf_risk nomcar;
strata strata;
cluster cluster;
weight weight;
class &class_variable (ref=&ref_value) / param=ref;
model vio_dg (event='1')=&class_variable;

run;
%mend;

%risk_factor('1', sex)
%risk_factor('2', sex)
%risk_factor('1', region)
%risk_factor('2', region)
%risk_factor('0', PARENTS_EDU)
%risk_factor('1', PARENTS_EDU)
%risk_factor('2', PARENTS_EDU)
%risk_factor('0', alcohol_freq)
%risk_factor('1', alcohol_freq)
%risk_factor('2', alcohol_freq)
%risk_factor('0', smoking)
%risk_factor('1', smoking)
%risk_factor('0', bmi_g)
%risk_factor('1', bmi_g)
%risk_factor('2', bmi_g)
%risk_factor('3', bmi_g)
%risk_factor('4', bmi_g)
%risk_factor('0', depression)
%risk_factor('1', depression)
%risk_factor('1', e_ses)
%risk_factor('2', e_ses)
%risk_factor('3', e_ses)
%risk_factor('4', e_ses)
%risk_factor('5', e_ses)
%risk_factor('1', e_s_rcrd)
%risk_factor('2', e_s_rcrd)
%risk_factor('3', e_s_rcrd)
%risk_factor('4', e_s_rcrd)
%risk_factor('5', e_s_rcrd)

/*during pan*/
%macro risk_factor(ref_value, class_variable);

PROC SURVEYLogistic data=dur_risk nomcar;
strata strata;
cluster cluster;
weight weight;
class &class_variable (ref=&ref_value) / param=ref;
model vio_dg (event='1')=&class_variable;

run;
%mend;

%risk_factor('1', sex)
%risk_factor('2', sex)
%risk_factor('1', region)
%risk_factor('2', region)
%risk_factor('0', PARENTS_EDU)
%risk_factor('1', PARENTS_EDU)
%risk_factor('2', PARENTS_EDU)
%risk_factor('0', alcohol_freq)
%risk_factor('1', alcohol_freq)
%risk_factor('2', alcohol_freq)
%risk_factor('0', smoking)
%risk_factor('1', smoking)
%risk_factor('0', bmi_g)
%risk_factor('1', bmi_g)
%risk_factor('2', bmi_g)
%risk_factor('3', bmi_g)
%risk_factor('4', bmi_g)
%risk_factor('0', depression)
%risk_factor('1', depression)
%risk_factor('1', e_ses)
%risk_factor('2', e_ses)
%risk_factor('3', e_ses)
%risk_factor('4', e_ses)
%risk_factor('5', e_ses)
%risk_factor('1', e_s_rcrd)
%risk_factor('2', e_s_rcrd)
%risk_factor('3', e_s_rcrd)
%risk_factor('4', e_s_rcrd)
%risk_factor('5', e_s_rcrd)
