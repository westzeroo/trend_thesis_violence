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
