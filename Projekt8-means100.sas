%let nrep=500;
%let n=100; /*10 15 20 40*/
%let seed=1234;
%let alfa=0.01 0.05;
%let mi0=15 20 25 30 35 40 45; 
%let mean=30;
%let sig=20;

data skewkurt;
	do skewness=-2 to 2 by 0.5;
		do kurtosis=-3 to 15 by 3; /*12+3 nije 14*/
			if skewness**2 -2 <= kurtosis**2 and 1.7022*skewness**2-1.15<kurtosis then do;				
				output;
			end;			
		end;
	end;
run;

%fleishman;

/*Generirani podaci za svih 46 distribucija, za 500 replikacija i velicina uzorka n=10*/
DATA RAW;
 set fleishman;
 varid=_N_;
 a=-c;
 N=&N;
 DO REP = 1 TO &NREP;
 DO I=1 to &N;
   genX=rannor(&seed);
   genX=a + b*genX + c* genX**2 + d*genX**3; 
   genX=&mean+ &sig*genX;
   X = genX;
   /*XT = X - &mi0; oduzmemo ocekivanje*/
   rep_novi = 500*(varid-1)+rep;
 OUTPUT;
 END;
 END;
 label rep='repetition';
RUN;


proc datasets library=work nolist; 
	delete ttests;
run; quit;


%macro misize;

%let kk=1; 
%let mi=%scan(&mi0,&kk); 
%do %while(&mi NE); 

data raw;
	set raw;
	xt=x-&mi;
	output;
run;

proc means data=raw mean stderr t noprint;                                                                                              
  var xt;                                                                                                        
  by varid rep;  
  output out=t mean=mean stderr=stderr t=t; 
  id n;
run; 

data test;
	set t;
	mi_0=&mi;
run;

proc append base=ttests data=test;
run;

%let kk=%eval(&kk+1); 
%let mi=%scan(&mi0,&kk); 
%end; 
%mend nsize;

%misize;


data tall_&n;
 set ttests;

   t_crit_01=TINV(0.01,&n-1);
   fraction_crit_01=(t le t_crit_01)+(t ge -t_crit_01);

   t_crit_05=TINV(0.05,&n-1);
   fraction_crit_05=(t le t_crit_05)+(t ge -t_crit_05);
run;

proc means data=tall_&n nway noprint;
 var fraction_crit_01;
 by mi_0 varid;
 output out=fraction01_&n mean=mean sum=sum;
run;

proc means data=tall_&n nway noprint;
 var fraction_crit_05;
 by mi_0 varid;
 output out=fraction05_&n mean=mean sum=sum;
run;



/*alfa=0.01 mean za sve distribucije za sve mi0 za n=&n*/
proc sort data=fraction01_&n out=fraction01_sorted_&n;
	by varid;
run;

data fraction01_sorted_&n (drop = _TYPE_ _FREQ_ mi_0 sum);
	set fraction01_sorted_&n;
run;

proc transpose data=fraction01_sorted_&n out=fraction01_sorted_&n (rename=(COL1=MI0_15 COL2=MI0_20 COL3=MI0_25 COL4=MI0_30 COL5=MI0_35 COL6=MI0_40 COL7=MI0_45));
	by varid;
run;

data fraction01_sorted_&n /*(drop = varid)*/;
	set fraction01_sorted_&n;
run;
proc print;

/*alfa=0.05 mean za sve distribucije za sve mi0 za n=&n*/
proc sort data=fraction05_&n out=fraction05_sorted_&n;
	by varid;
run;

data fraction05_sorted_&n (drop = _TYPE_ _FREQ_ mi_0 sum);
	set fraction05_sorted_&n;
run;

proc transpose data=fraction05_sorted_&n out=fraction05_sorted_&n (rename=(COL1=MI0_15 COL2=MI0_20 COL3=MI0_25 COL4=MI0_30 COL5=MI0_35 COL6=MI0_40 COL7=MI0_45));
	by varid;
run;

data fraction05_sorted_&n /*(drop = varid)*/;
	set fraction05_sorted_&n;
run;
proc print;



/*skewness=0 kurtosis=0 -> FRACTION ZA NORMALNI PODACI, varid=21*/
data fraction01_normalni_&n (drop = _TYPE_ _FREQ_ varid mi_0);
	set fraction01_&n;
	where varid=21;
	n=&n;
run;

data fraction05_normalni_&n (drop = _TYPE_ _FREQ_ varid mi_0);
	set fraction05_&n;
	where varid=21;
	n=&n;
run;

proc transpose data=fraction01_normalni_&n out=fraction01_normalni_&n (rename=(COL1=MI0_15 COL2=MI0_20 COL3=MI0_25 COL4=MI0_30 COL5=MI0_35 COL6=MI0_40 COL7=MI0_45));
	by n;
run;

proc transpose data=fraction05_normalni_&n out=fraction05_normalni_&n (rename=(COL1=MI0_15 COL2=MI0_20 COL3=MI0_25 COL4=MI0_30 COL5=MI0_35 COL6=MI0_40 COL7=MI0_45));
	by n;
run;


/*skewness=0 kurtosis=0 -> MEAN I STDDEV ZA NORMALNI PODACI, varid=21*/

data normalnipodaci_&n (keep = x);
	set raw;
	where varid=21;
run;

proc means data=normalnipodaci_&n nway noprint;
 var x;
 output out=normalnipodaci_&n mean=mean stddev=stddev;
run;


/*PROC POWER USPOREDBA*/
/*mean= 30.004455145	stddev= 19.958389462*/

ods graphics on;
proc power;
   onesamplemeans
      mean   = 30.004455145
      ntotal = &n
      stddev = 19.958389462
      power  = .
      alpha = 0.01
      nullmean = 15 to 45 by 5
      ;
      plot x=n min=10 max=100     
      vary (color by nullmean);
run;
ods graphics off;

ods graphics on;
proc power;
   onesamplemeans
      mean   = 30.004455145
      ntotal = &n
      stddev = 19.958389462
      power  = .
      alpha = 0.05
      nullmean = 15 to 45 by 5
      ;
      plot x=n min=10 max=100     
      vary (color by nullmean);
run;
ods graphics off;

/*racunamo prosjecnu vrijednost po distribucijama za svaki mi0 za n=&n i alpha=0.01*/

proc means data=fraction01_sorted_&n;
	var mi0_15 mi0_20 mi0_25 mi0_30 mi0_35 mi0_40 mi0_45;
	output out=arit_fraction01_&n;
run;
 
data arit_fraction01_&n;
	set arit_fraction01_&n;
	drop _type_;
run;

proc transpose data=arit_fraction01_&n out=arit_fraction01_&n (keep=col4 rename= (col4=mean_&n));
	by _freq_;
run;

data arit_fraction01_&n;
	set arit_fraction01_&n;
	varid=_N_;
run;


/*racunamo prosjecnu vrijednost po distribucijama za svaki mi0 za n=&n i alpha=0.05*/

proc means data=fraction05_sorted_&n;
	var mi0_15 mi0_20 mi0_25 mi0_30 mi0_35 mi0_40 mi0_45;
	output out=arit_fraction05_&n;
run;
 
data arit_fraction05_&n;
	set arit_fraction05_&n;
	drop _type_;
run;

proc transpose data=arit_fraction05_&n out=arit_fraction05_&n (keep= col4 rename= (col4=mean_&n));
	by _freq_;
run;

data arit_fraction05_&n;
	set arit_fraction05_&n;
	varid=_N_;
run;