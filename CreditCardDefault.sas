/* Credit Card Default */
proc import out = Credit
datafile= "C:\Documents and Settings\STD\Desktop\data\creditcard.csv"
DBMS=csv replace;
getnames=yes;
datarow=2;
run;

proc contents data = Credit;
run;

proc means data = Credit n nmiss mean median;
run;
/* No missing values */

proc freq data = Credit;
table Class/missing;
run;
/* No missing in dependent var */

data Credittrain CreditTest;
set Credit;
IF RANUNI(12134654) > = 0.8 THEN OUTPUT CreditTest;
ELSE OUTPUT Credittrain;
run;

proc logistic data = CreditTrain outmodel = CreditModel;
model Class = V1
V2
V3
V4
V5
V6
V7
V8
V9
V10
V11
V12
V13
V14
V15
V16
V17
V18
V19
V20
V21
V22
V23
V24
V25
V26
V27
V28
Amount / selection = stepwise slentry = 0.05 slstay = 0.055;
run;
/* Only 13 out of 30 independent variables remain after stepwise selection */

data C1;
set CreditTest;
keep V14
V4
V16
V10
V8
V5
V21
V22
V13
V23
V20
V27
V1;
run;

proc logistic inmodel=CreditModel;
   score data=C1 out=Score3;
run;

data Score4;
set Score3;
if P_0 > 0.5 then Class1 = 0;
else Class1 = 1;
run;

data Score5;
set Score4;
keep Class1;
run;

data Score6;
set Credittest;
set Score5;
if Class1 = Class then S1 = 1;
else S1 = 0;
run;

proc sql;
create table t1 as select sum(S1)/56760 as S2 from Score6;
quit;
/* Accuracy is 0.9992 or 99.92 % */
