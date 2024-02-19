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
