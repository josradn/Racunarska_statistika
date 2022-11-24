libname projekt "/home/u58436483/RS/projekt";

data pills;
	set projekt.pills_efron;
	xt=x-45;
	output;
run;

proc means data=pills mean stddev skewness kurtosis t;                                                                                              
  var x;        
  output out=tpills mean=mean stddev=stddev skewness=skewness kurtosis=kurtosis t=t;
run; 

proc means data=pills mean stddev skewness kurtosis t;                                                                                              
  var xt;        
  output out=tpills mean=mean stddev=stddev skewness=skewness kurtosis=kurtosis t=t;
run; 

/*Analysis Variable : x
Mean	     Std Dev	Skewness	Kurtosis	
39.8333333	21.0169014	1.3821210	2.2475124

najblizi su -> (1,3) varid=33 i (1.5,3) varid=38
*/


proc ttest data=pills sides=2 h0=45;
	var x;
run;
/*
DF	t Value	 Pr > |t|
23	 -1.20	  0.2407

Na razini znacajnosti 0.01 i 0.05 ne odbacujemo hipotezu H0.
*/

/*Prvo gledajmo alfa=0.01 i varid=33, tj skewness=1 i kurtosis=3.
	Vidimo da kada smo gledali proporcije za mi0=45 da je za n=10  0.478,
	za n=15 0.670, za n=20 0.774 te za n=40 0.960. 
	Dakle, moramo traziti neku velicinu uzorka izmedu 20 i 40, pa cemo kreniti od 21.
	
	n=21 -> 0.784
	n=22 -> 0.772
	n=23 -> 0.824
	
	Dakle, n mora biti barem 23.
	
	Sada gledajmo varid=38, tj skewness=1.5 i kurtosis=3.
	Vidimo da kada smo gledali proporcije za mi0=45 da je za n=10  0.476,
	za n=15 0.600, za n=20 0.752 te za n=40 0.948. 
	Dakle, moramo traziti neku velicinu uzorka izmedu 20 i 40, pa cemo kreniti od 21.
	
	n=21 -> 0.796
	n=22 -> 0.752
	n=23 -> 0.770
	n=24 -> 0.816
	
	Dakle, n mora biti barem 24.
*/

/*Gledajmo alfa=0.05 i varid=33, tj skewness=1 i kurtosis=3.
	Vidimo da kada smo gledali proporcije za mi0=45 da je za n=10  0.730 te	za n=15 0.874. 
	Dakle, moramo traziti neku velicinu uzorka izmedu 10 i 15, pa cemo kreniti od 11.
	
	n=11 -> 0.716
	n=12 -> 0.788
	n=13 -> 0.784
	n=14 -> 0.828
	
	Dakle, n mora biti barem 14.
	
	Sada gledajmo varid=38, tj skewness=1.5 i kurtosis=3.
	Vidimo da kada smo gledali proporcije za mi0=45 da je za n=10  0.730 te	za n=15 .
	Dakle, moramo traziti neku velicinu uzorka izmedu 10 i 15, tako da provjerimo je li postoji
	neki uzorak manji od 15, a da isto ima snagu 0.8. Krenit cemo od 11.
	
	n=11 -> 0.740
	n=12 -> 0.782
	n=13 -> 0.792
	n=14 -> 0.814
	
	Dakle, n mora biti barem 14.
*/
