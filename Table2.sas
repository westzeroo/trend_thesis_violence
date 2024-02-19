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

