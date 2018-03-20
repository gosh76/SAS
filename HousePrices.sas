proc import out = HPtrn
datafile= "C:\Documents and Settings\STD\Desktop\data\HousePrices\train.csv"
DBMS=csv replace;
getnames=yes;
datarow=2;
run;

proc import out = HPtst
datafile= "C:\Documents and Settings\STD\Desktop\data\HousePrices\test.csv"
DBMS=csv replace;
getnames=yes;
datarow=2;
run;

data HPtst;
set HPtst;
SalePrice=.;
run;

data m1;
set HPtrn HPtst;
run;

proc contents data=m1;
run;

/*converting LotFrontage from char to numeric*/
data m1;
set m1;
LotFrontage1 = input(LotFrontage,3.);
drop LotFrontage;
run;

proc freq data=m1;
table _char_/missing;
run;

data m1;
set m1;
drop Alley FireplaceQu PoolQC Fence MiscFeature Neighborhood Exterior1st Exterior2nd Id;
if BsmtQual = 'NA' then BsmtQual = 'TA';
if BsmtCond = 'NA' then BsmtCond = 'TA';
if MasVnrType = 'NA' then MasVnrType = 'None';
if BsmtExposure = 'NA' then BsmtExposure = 'No';
if BsmtFinType1 = 'NA' then BsmtFinType1 = 'Unf';
if BsmtFinType2 = 'NA' then BsmtFinType2 = 'Unf';
if Electrical = 'NA' then Electrical = 'SBrkr';
if KitchenQual = 'NA' then KitchenQual = 'TA';
if Functional = 'NA' then Functional = 'Typ';
if GarageType = 'NA' then GarageType = 'Attchd';
if GarageFinish = 'NA' then GarageFinish = 'Unf';
if GarageQual = 'NA' then GarageQual = 'TA';
if GarageCond = 'NA' then GarageCond = 'TA';
if SaleType = 'NA' then SaleType = 'WD';
if MSZoning = 'NA' then MSZoning = 'RL';
if Utilities = 'NA' then Utilities = 'AllPub';
run;
/* all NAs replaced*/
proc freq data=m1;
table _char_/missing;
run;

proc means data = m1 n nmiss mean median;
run;

data m1;
set m1;
if MasVnrArea = . then MasVnrArea = 0;
if BsmtFinSF1 = . then BsmtFinSF1 = 368.5;
if BsmtFinSF2 = . then BsmtFinSF2 = 0;
if BsmtUnfSF = . then BsmtUnfSF = 467;
if TotalBsmtSF = . then TotalBsmtSF = 989.5;
if BsmtFullBath = . then BsmtFullBath = 0;
if BsmtHalfBath = . then BsmtHalfBath = 0;
if GarageYrBlt = . then GarageYrBlt = 1980;
if GarageCars = . then GarageCars = 2;
if GarageArea = . then GarageArea = 480;
if LotFrontage1 = . then LotFrontage1 = 65;
run;

proc means data = m1 n nmiss;
run;

proc univariate data = m1 plot;
run;

data m1;
set m1;
if LotArea > 17728.5 then LotArea = 17728.5;
if MasVnrArea > 410 then MasVnrArea = 410;
if BsmtFinSF1 > 1832.5 then BsmtFinSF1 = 1832.5;
if TotalBsmtSF > 2065.5 then TotalBsmtSF = 2065.5;
if _stFlrSF	> 2156 then _stFlrSF = 2156;
if GrLivArea > 2671 then GrLivArea = 2671;
if GarageArea > 960 then GarageArea = 960;
if WoodDeckSF > 420 then WoodDeckSF = 420;
if OpenPorchSF > 175 then OpenPorchSF = 175;
drop BsmtFinSF2	LowQualFinSF BsmtFullBath BsmtHalfBath HalfBath KitchenAbvGr EnclosedPorch _SsnPorch ScreenPorch PoolArea MiscVal;
if SalePrice > 340075 then SalePrice = 340075;
run;

data m2;
set m1;
if SalePrice = . then SalePrice = 0;
run;


proc glmmod data=m2 outdesign=m3;
class BldgType
BsmtCond
BsmtExposure
BsmtFinType1
BsmtFinType2
BsmtQual
CentralAir
Condition1
Condition2
Electrical
ExterCond
ExterQual
Foundation
Functional
GarageCond
GarageFinish
GarageQual
GarageType
Heating
HeatingQC
HouseStyle
KitchenQual
LandContour
LandSlope
LotConfig
LotShape
MSZoning
MasVnrType
PavedDrive
RoofMatl
RoofStyle
SaleCondition
SaleType
Street
Utilities;
model SalePrice=BldgType
BsmtCond
BsmtExposure
BsmtFinSF1
BsmtFinType1
BsmtFinType2
BsmtQual
BsmtUnfSF
CentralAir
Condition1
Condition2
Electrical
ExterCond
ExterQual
Fireplaces
Foundation
FullBath
Functional
GarageArea
GarageCars
GarageCond
GarageFinish
GarageQual
GarageType
GarageYrBlt
GrLivArea
Heating
HeatingQC
HouseStyle
KitchenQual
LandContour
LandSlope
LotArea
LotConfig
LotFrontage1
LotShape
MSSubClass
MSZoning
MasVnrArea
MasVnrType
MoSold
OpenPorchSF
OverallCond
OverallQual
PavedDrive
RoofMatl
RoofStyle
SaleCondition
SaleType
Street
TotRmsAbvGrd
TotalBsmtSF
Utilities
WoodDeckSF
YearBuilt
YearRemodAdd
YrSold
_ndFlrSF
_stFlrSF;
run;

data m3;
set m3;
if SalePrice = 0 then SalePrice = .;
run;

proc reg data=m3;
model SalePrice=Col1-Col210;
run;
/* R2 - 0.9274 Adj.R2 - 0.9181*/

/* keeping significant variables from m2*/
data m4;
set m3;
keep SalePrice Col4
Col12
Col18
Col25
Col28
Col32
Col36
Col41
Col51
Col67
Col69
Col70
Col71
Col72
Col73
Col74
Col78
Col79
Col81
Col82
Col83
Col84
Col86
Col88
Col96
Col101
Col111
Col116
Col118
Col126
Col131
Col136
Col142
Col155
Col156
Col158
Col160
Col162
Col167
Col168
Col170
Col172
Col194
Col202
Col205
Col206
Col207;
run;

proc reg data=m4;
model SalePrice=Col4
Col12
Col18
Col25
Col28
Col32
Col36
Col41
Col51
Col67
Col69
Col70
Col71
Col72
Col73
Col74
Col78
Col79
Col81
Col82
Col83
Col84
Col86
Col88
Col96
Col101
Col111
Col116
Col118
Col126
Col131
Col136
Col142
Col155
Col156
Col158
Col160
Col162
Col167
Col168
Col170
Col172
Col194
Col202
Col205
Col206
Col207;
run;
/* R2 - 0.7044 Adj. R2 - 0.6976*/

data m5;
set m4;
drop Col25 Col74 Col170;
run;
/* 45 variables remain*/

proc reg data=m5;
model SalePrice=Col4
Col12
Col18
Col28
Col32
Col36
Col41
Col51
Col67
Col69
Col73
Col78
Col79
Col81
Col82
Col83
Col84
Col86
Col88
Col96
Col101
Col111
Col116
Col118
Col126
Col131
Col136
Col142
Col155
Col156
Col158
Col160
Col162
Col167
Col168
Col172
Col194
Col202
Col205
Col206
Col207;
run;
output out=p1 p=predict r=residual;
run;

/*R-Square 0.9133 
Adj R-Sq 0.9108 */
    
data sol1;
set p1;
keep predict;
if _n_ gt 1460;
run;
/* table of 1459 predictions*/











