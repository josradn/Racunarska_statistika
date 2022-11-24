/*Kako bi ovaj kod radio potrebno je prvo pokrenuti sljedeće kodove:
fleishman
projekt-means10
projekt-means15
projekt-means20
projekt-means40
projekt-means100
*/

/*PODACI*/

/*Radimo nove podatke tako da mergeamo sve prosjecne proporcije svih distribucija po svakom n-u za svaki mi_0*/
/*Prosjecna proporcija po svakom n-u za svaki mi_0 alfa=0.01 -> 5 podataka u svakom stupcu, 7 stupaca(za svaki mi_0)*/
data all_arit_fraction01;
	merge arit_fraction01_10 arit_fraction01_15 arit_fraction01_20 arit_fraction01_40 arit_fraction01_100;
	by varid;
	drop varid;
	freq=46;
run;

proc transpose data=all_arit_fraction01 out=all_arit_fraction01;
	by freq;
run;

data all_arit_fraction01;
	set all_arit_fraction01;
	veluzorka=_N_;
run;


/*Prosjecna proporcija po svakom n-u za svaki mi_0 alfa=0.05 -> 5 podataka u svakom stupcu, 7 stupaca(za svaki mi_0)*/
data all_arit_fraction05;
	merge arit_fraction05_10 arit_fraction05_15 arit_fraction05_20 arit_fraction05_40 arit_fraction05_100;
	by varid;
	drop varid;
	freq=46;
run;

proc transpose data=all_arit_fraction05 out=all_arit_fraction05;
	by freq;
run;

data all_arit_fraction05;
	set all_arit_fraction05;
	veluzorka=_N_;
run;


/*Sada cemo izdvojit podatke za pojedine distribuciju kako bi mogli nacrtat proporcije za svaki n 
	za svaku distribuciju koju smo izabrali. To cemo vaditi iz fraction01_sorted_&n i fraction05_sorted_&n.
	Uzeti cemo 5 distribucija:
	1) skewness=0 i kurtosis=0 -> varid=21 (i to usporedujemo s power procedurom)
	2) skewness=0.5 i kurtosis=0 -> varid=27
	3) skewness=-0.5 i kurtosis=0 -> varid=15 (IPAK NE)
	( 2) i 3) uzimamo da usporedimo s norm distr,lijevo-desno blago asimetricno)
	4) skewness=-2 i kurt=15 -> varid=4 
	5) skewness=2 i kurt=12 -> varid=45 
	( 4) i 5) uzimamo da usporedimo dosta ''dalje'' distr od normalne)
	To cemo napraviti za alfa=0.01 i alfa=0.05.
*/

/* skewness=0 i kurtosis=0 -> varid=21 */
/* Iako ove sve podatke imamo vec u fraction01_normalni_&n, kako je tamo sum u retku, zbog olaksanja
	cu opet izvuci podatke na isti princip kao za ostale.
*/
data fraction01_norm;
	set fraction01_sorted_10 fraction01_sorted_15 fraction01_sorted_20 fraction01_sorted_40 fraction01_sorted_100;
	where varid=21;
	drop varid _name_;
	veluzorka=_N_;
run;

data fraction05_norm;
	set fraction05_sorted_10 fraction05_sorted_15 fraction05_sorted_20 fraction05_sorted_40 fraction05_sorted_100;
	where varid=21;
	drop varid _name_;
	veluzorka=_N_;
run;

/* skewness=0.5 i kurtosis=0 -> varid=27 */
data fraction01_varid27;
	set fraction01_sorted_10 fraction01_sorted_15 fraction01_sorted_20 fraction01_sorted_40 fraction01_sorted_100;
	where varid=27;
	drop varid _name_;
	veluzorka=_N_;
run;

data fraction05_varid27;
	set fraction05_sorted_10 fraction05_sorted_15 fraction05_sorted_20 fraction05_sorted_40 fraction05_sorted_100;
	where varid=27;
	drop varid _name_;
	veluzorka=_N_;
run;

/* skewness=-0.5 i kurtosis=0 -> varid=15 *//*
data fraction01_varid15;
	set fraction01_sorted_10 fraction01_sorted_15 fraction01_sorted_20 fraction01_sorted_40 fraction01_sorted_100;
	where varid=15;
	drop varid _name_;
	veluzorka=_N_;
run;

data fraction05_varid15;
	set fraction05_sorted_10 fraction05_sorted_15 fraction05_sorted_20 fraction05_sorted_40 fraction05_sorted_100;
	where varid=15;
	drop varid _name_;
	veluzorka=_N_;
run;
*/
/* skewness=-2 i kurt=15 -> varid=4 */
data fraction01_varid4;
	set fraction01_sorted_10 fraction01_sorted_15 fraction01_sorted_20 fraction01_sorted_40 fraction01_sorted_100;
	where varid=4;
	drop varid _name_;
	veluzorka=_N_;
run;

data fraction05_varid4;
	set fraction05_sorted_10 fraction05_sorted_15 fraction05_sorted_20 fraction05_sorted_40 fraction05_sorted_100;
	where varid=4;
	drop varid _name_;
	veluzorka=_N_;
run;

/* skewness=2 i kurt=12 -> varid=45 */

data fraction01_varid45;
	set fraction01_sorted_10 fraction01_sorted_15 fraction01_sorted_20 fraction01_sorted_40 fraction01_sorted_100;
	where varid=45;
	drop varid _name_;
	veluzorka=_N_;
run;

data fraction05_varid45;
	set fraction05_sorted_10 fraction05_sorted_15 fraction05_sorted_20 fraction05_sorted_40 fraction05_sorted_100;
	where varid=45;
	drop varid _name_;
	veluzorka=_N_;
run;


/*GRAFOVI*/

/*Sada cemo napraviti grafove za prosjecne snage za svaki mi_0 uprosjecene po n-u*/

/*Prosječna snaga po veličini uzorka za svaku hipotezu mi_0, alpha=0.01*/

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sort data=WORK.ALL_ARIT_FRACTION01 out=_SeriesPlotTaskData;
	by veluzorka;
run;

proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Prosječna snaga po veličini uzorka za svaku hipotezu mi_0 (alpha=0.01)";
	series x=veluzorka y=COL1 / lineattrs=(thickness=2 color=green) name="col1" legendlabel="MI0_15";
	series x=veluzorka y=COL2 / lineattrs=(thickness=2 color=yellow) name="col2" legendlabel="MI0_20";	
	series x=veluzorka y=COL3 / lineattrs=(thickness=2 color=blue) name="col3" legendlabel="MI0_25";	
	series x=veluzorka y=COL4 / lineattrs=(thickness=2 color=brown) name="col4" legendlabel="MI0_30";	
	series x=veluzorka y=COL5 / lineattrs=(thickness=2 color=red) name="col5" legendlabel="MI0_35";	
	series x=veluzorka y=COL6 / lineattrs=(thickness=2 color=orange) name="col6" legendlabel="MI0_40";	
	series x=veluzorka y=COL7 / lineattrs=(thickness=2 color=cyan) name="col7" legendlabel="MI0_45";	
	xaxis label="veličina uzorka";
	yaxis label="power";
run;

ods graphics / reset;
title;

proc datasets library=WORK noprint;
	delete _SeriesPlotTaskData;
	run;
	


/*Prosječna snaga po veličini uzorka za svaku hipotezu mi_0, alpha=0.05*/

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sort data=WORK.ALL_ARIT_FRACTION05 out=_SeriesPlotTaskData;
	by veluzorka;
run;

proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Prosječna snaga po veličini uzorka za svaku hipotezu mi_0 (alpha=0.05)";
	series x=veluzorka y=COL1 / lineattrs=(thickness=2 color=green) name="col1" legendlabel="MI0_15";
	series x=veluzorka y=COL2 / lineattrs=(thickness=2 color=yellow) name="col2" legendlabel="MI0_20";	
	series x=veluzorka y=COL3 / lineattrs=(thickness=2 color=blue) name="col3" legendlabel="MI0_25";	
	series x=veluzorka y=COL4 / lineattrs=(thickness=2 color=brown) name="col4" legendlabel="MI0_30";	
	series x=veluzorka y=COL5 / lineattrs=(thickness=2 color=red) name="col5" legendlabel="MI0_35";	
	series x=veluzorka y=COL6 / lineattrs=(thickness=2 color=orange) name="col6" legendlabel="MI0_40";	
	series x=veluzorka y=COL7 / lineattrs=(thickness=2 color=cyan) name="col7" legendlabel="MI0_45";	
	xaxis label="veličina uzorka";
	yaxis label="power";
run;

ods graphics / reset;
title;

proc datasets library=WORK noprint;
	delete _SeriesPlotTaskData;
	run;
	
/*_______________________________________________________________________________________________*/	

/*Sada ćemo napraviti graf snage po velicini uzorka za svaki mi_0 i gore izabrane distribucije*/

/*Normalna distribucija -> Snaga po veličini uzorka za svaku hipotezu mi_0 (skew=0 kurt=0 alpha=0.01)*/

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sort data=WORK.FRACTION01_NORM out=_SeriesPlotTaskData;
	by veluzorka;
run;

proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Snaga po veličini uzorka za svaku hipotezu mi_0 (skew=0 kurt=0 alpha=0.01)";
	series x=veluzorka y=mi0_15 / lineattrs=(thickness=2 color=green);
	series x=veluzorka y=mi0_20 / lineattrs=(thickness=2 color=yellow);	
	series x=veluzorka y=mi0_25 / lineattrs=(thickness=2 color=blue);	
	series x=veluzorka y=mi0_30 / lineattrs=(thickness=2 color=brown);	
	series x=veluzorka y=mi0_35 / lineattrs=(thickness=2 color=red);	
	series x=veluzorka y=mi0_40 / lineattrs=(thickness=2 color=orange);	
	series x=veluzorka y=mi0_45 / lineattrs=(thickness=2 color=cyan);	
	xaxis label="veličina uzorka";
	yaxis label="power";
run;

ods graphics / reset;
title;

proc datasets library=WORK noprint;
	delete _SeriesPlotTaskData;
	run;

/*Normalna distribucija -> Snaga po veličini uzorka za svaku hipotezu mi_0 (skew=0 kurt=0 alpha=0.05)*/

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sort data=WORK.FRACTION05_NORM out=_SeriesPlotTaskData;
	by veluzorka;
run;

proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Snaga po veličini uzorka za svaku hipotezu mi_0 (skew=0 kurt=0 alpha=0.05)";
	series x=veluzorka y=mi0_15 / lineattrs=(thickness=2 color=green);
	series x=veluzorka y=mi0_20 / lineattrs=(thickness=2 color=yellow);	
	series x=veluzorka y=mi0_25 / lineattrs=(thickness=2 color=blue);	
	series x=veluzorka y=mi0_30 / lineattrs=(thickness=2 color=brown);	
	series x=veluzorka y=mi0_35 / lineattrs=(thickness=2 color=red);	
	series x=veluzorka y=mi0_40 / lineattrs=(thickness=2 color=orange);	
	series x=veluzorka y=mi0_45 / lineattrs=(thickness=2 color=cyan);	
	xaxis label="veličina uzorka";
	yaxis label="power";
run;

ods graphics / reset;
title;

proc datasets library=WORK noprint;
	delete _SeriesPlotTaskData;
	run;


/*skew=0.5 i kurt=0(varid=27)-> Snaga po veličini uzorka za svaku hipotezu mi_0 (skew=0.5 kurt=0 alpha=0.01)*/

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sort data=WORK.FRACTION01_VARID27 out=_SeriesPlotTaskData;
	by veluzorka;
run;

proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Snaga po veličini uzorka za svaku hipotezu mi_0 (skew=0.5 kurt=0 alpha=0.01)";
	series x=veluzorka y=mi0_15 / lineattrs=(thickness=2 color=green);
	series x=veluzorka y=mi0_20 / lineattrs=(thickness=2 color=yellow);	
	series x=veluzorka y=mi0_25 / lineattrs=(thickness=2 color=blue);	
	series x=veluzorka y=mi0_30 / lineattrs=(thickness=2 color=brown);	
	series x=veluzorka y=mi0_35 / lineattrs=(thickness=2 color=red);	
	series x=veluzorka y=mi0_40 / lineattrs=(thickness=2 color=orange);	
	series x=veluzorka y=mi0_45 / lineattrs=(thickness=2 color=cyan);	
	xaxis label="veličina uzorka";
	yaxis label="power";
run;

ods graphics / reset;
title;

proc datasets library=WORK noprint;
	delete _SeriesPlotTaskData;
	run;

/*skew=0.5 i kurt=0(varid=27)-> Snaga po veličini uzorka za svaku hipotezu mi_0 (skew=0.5 kurt=0 alpha=0.05)*/

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sort data=WORK.FRACTION05_VARID27 out=_SeriesPlotTaskData;
	by veluzorka;
run;

proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Snaga po veličini uzorka za svaku hipotezu mi_0 (skew=0.5 kurt=0 alpha=0.05)";
	series x=veluzorka y=mi0_15 / lineattrs=(thickness=2 color=green);
	series x=veluzorka y=mi0_20 / lineattrs=(thickness=2 color=yellow);	
	series x=veluzorka y=mi0_25 / lineattrs=(thickness=2 color=blue);	
	series x=veluzorka y=mi0_30 / lineattrs=(thickness=2 color=brown);	
	series x=veluzorka y=mi0_35 / lineattrs=(thickness=2 color=red);	
	series x=veluzorka y=mi0_40 / lineattrs=(thickness=2 color=orange);	
	series x=veluzorka y=mi0_45 / lineattrs=(thickness=2 color=cyan);	
	xaxis label="veličina uzorka";
	yaxis label="power";
run;

ods graphics / reset;
title;

proc datasets library=WORK noprint;
	delete _SeriesPlotTaskData;
	run;

/*skew=-0.5 i kurt=0(varid=15)-> Snaga po veličini uzorka za svaku hipotezu mi_0 (skew=-0.5 kurt=0 alpha=0.01)*/
/*
ods graphics / reset width=6.4in height=4.8in imagemap;

proc sort data=WORK.FRACTION01_VARID15 out=_SeriesPlotTaskData;
	by veluzorka;
run;

proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Snaga po veličini uzorka za svaku hipotezu mi_0 (skew=-0.5 kurt=0 alpha=0.01)";
	series x=veluzorka y=mi0_15 / lineattrs=(thickness=2 color=green);
	series x=veluzorka y=mi0_20 / lineattrs=(thickness=2 color=yellow);	
	series x=veluzorka y=mi0_25 / lineattrs=(thickness=2 color=blue);	
	series x=veluzorka y=mi0_30 / lineattrs=(thickness=2 color=brown);	
	series x=veluzorka y=mi0_35 / lineattrs=(thickness=2 color=red);	
	series x=veluzorka y=mi0_40 / lineattrs=(thickness=2 color=orange);	
	series x=veluzorka y=mi0_45 / lineattrs=(thickness=2 color=cyan);	
	xaxis label="veličina uzorka";
	yaxis label="power";
run;

ods graphics / reset;
title;

proc datasets library=WORK noprint;
	delete _SeriesPlotTaskData;
	run;
*/
/*skew=-0.5 i kurt=0(varid=15)-> Snaga po veličini uzorka za svaku hipotezu mi_0 (skew=-0.5 kurt=0 alpha=0.05)*/
/*
ods graphics / reset width=6.4in height=4.8in imagemap;

proc sort data=WORK.FRACTION05_VARID15 out=_SeriesPlotTaskData;
	by veluzorka;
run;

proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Snaga po veličini uzorka za svaku hipotezu mi_0 (skew=-0.5 kurt=0 alpha=0.05)";
	series x=veluzorka y=mi0_15 / lineattrs=(thickness=2 color=green);
	series x=veluzorka y=mi0_20 / lineattrs=(thickness=2 color=yellow);	
	series x=veluzorka y=mi0_25 / lineattrs=(thickness=2 color=blue);	
	series x=veluzorka y=mi0_30 / lineattrs=(thickness=2 color=brown);	
	series x=veluzorka y=mi0_35 / lineattrs=(thickness=2 color=red);	
	series x=veluzorka y=mi0_40 / lineattrs=(thickness=2 color=orange);	
	series x=veluzorka y=mi0_45 / lineattrs=(thickness=2 color=cyan);	
	xaxis label="veličina uzorka";
	yaxis label="power";
run;

ods graphics / reset;
title;

proc datasets library=WORK noprint;
	delete _SeriesPlotTaskData;
	run;

*/

/*skew=-2 i kurt=15(varid=4)-> Snaga po veličini uzorka za svaku hipotezu mi_0 (skew=-2 kurt=15 alpha=0.01)*/

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sort data=WORK.FRACTION01_VARID4 out=_SeriesPlotTaskData;
	by veluzorka;
run;

proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Snaga po veličini uzorka za svaku hipotezu mi_0 (skew=-2 kurt=15 alpha=0.01)";
	series x=veluzorka y=mi0_15 / lineattrs=(thickness=2 color=green);
	series x=veluzorka y=mi0_20 / lineattrs=(thickness=2 color=yellow);	
	series x=veluzorka y=mi0_25 / lineattrs=(thickness=2 color=blue);	
	series x=veluzorka y=mi0_30 / lineattrs=(thickness=2 color=brown);	
	series x=veluzorka y=mi0_35 / lineattrs=(thickness=2 color=red);	
	series x=veluzorka y=mi0_40 / lineattrs=(thickness=2 color=orange);	
	series x=veluzorka y=mi0_45 / lineattrs=(thickness=2 color=cyan);	
	xaxis label="veličina uzorka";
	yaxis label="power";
run;

ods graphics / reset;
title;

proc datasets library=WORK noprint;
	delete _SeriesPlotTaskData;
	run;

/*skew=-2 i kurt=15(varid=4)-> Snaga po veličini uzorka za svaku hipotezu mi_0 (skew=-2 kurt=15 alpha=0.05)*/

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sort data=WORK.FRACTION05_VARID4 out=_SeriesPlotTaskData;
	by veluzorka;
run;

proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Snaga po veličini uzorka za svaku hipotezu mi_0 (skew=-2 kurt=15 alpha=0.05)";
	series x=veluzorka y=mi0_15 / lineattrs=(thickness=2 color=green);
	series x=veluzorka y=mi0_20 / lineattrs=(thickness=2 color=yellow);	
	series x=veluzorka y=mi0_25 / lineattrs=(thickness=2 color=blue);	
	series x=veluzorka y=mi0_30 / lineattrs=(thickness=2 color=brown);	
	series x=veluzorka y=mi0_35 / lineattrs=(thickness=2 color=red);	
	series x=veluzorka y=mi0_40 / lineattrs=(thickness=2 color=orange);	
	series x=veluzorka y=mi0_45 / lineattrs=(thickness=2 color=cyan);	
	xaxis label="veličina uzorka";
	yaxis label="power";
run;

ods graphics / reset;
title;

proc datasets library=WORK noprint;
	delete _SeriesPlotTaskData;
	run;

/*skew=2 i kurt=12(varid=45)-> Snaga po veličini uzorka za svaku hipotezu mi_0 (skew=2 kurt=12 alpha=0.01)*/

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sort data=WORK.FRACTION01_VARID45 out=_SeriesPlotTaskData;
	by veluzorka;
run;

proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Snaga po veličini uzorka za svaku hipotezu mi_0 (skew=2 kurt=12 alpha=0.01)";
	series x=veluzorka y=mi0_15 / lineattrs=(thickness=2 color=green);
	series x=veluzorka y=mi0_20 / lineattrs=(thickness=2 color=yellow);	
	series x=veluzorka y=mi0_25 / lineattrs=(thickness=2 color=blue);	
	series x=veluzorka y=mi0_30 / lineattrs=(thickness=2 color=brown);	
	series x=veluzorka y=mi0_35 / lineattrs=(thickness=2 color=red);	
	series x=veluzorka y=mi0_40 / lineattrs=(thickness=2 color=orange);	
	series x=veluzorka y=mi0_45 / lineattrs=(thickness=2 color=cyan);	
	xaxis label="veličina uzorka";
	yaxis label="power";
run;

ods graphics / reset;
title;

proc datasets library=WORK noprint;
	delete _SeriesPlotTaskData;
	run;

/*skew=2 i kurt=12(varid=45)-> Snaga po veličini uzorka za svaku hipotezu mi_0 (skew=2 kurt=12 alpha=0.05)*/

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sort data=WORK.FRACTION05_VARID45 out=_SeriesPlotTaskData;
	by veluzorka;
run;

proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Snaga po veličini uzorka za svaku hipotezu mi_0 (skew=2 kurt=12 alpha=0.05)";
	series x=veluzorka y=mi0_15 / lineattrs=(thickness=2 color=green);
	series x=veluzorka y=mi0_20 / lineattrs=(thickness=2 color=yellow);	
	series x=veluzorka y=mi0_25 / lineattrs=(thickness=2 color=blue);	
	series x=veluzorka y=mi0_30 / lineattrs=(thickness=2 color=brown);	
	series x=veluzorka y=mi0_35 / lineattrs=(thickness=2 color=red);	
	series x=veluzorka y=mi0_40 / lineattrs=(thickness=2 color=orange);	
	series x=veluzorka y=mi0_45 / lineattrs=(thickness=2 color=cyan);	
	xaxis label="veličina uzorka";
	yaxis label="power";
run;

ods graphics / reset;
title;

proc datasets library=WORK noprint;
	delete _SeriesPlotTaskData;
	run;

/*________________________________________________________________________*/
/*PROC POWER PROCEDURA*/

ods graphics on;
proc power;
   onesamplemeans
      mean   = 30
      ntotal = 100
      stddev = 20
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
      mean   = 30
      ntotal = 100
      stddev = 20
      power  = .
      alpha = 0.05
      nullmean = 15 to 45 by 5
      ;
      plot x=n min=10 max=100
      vary (color by nullmean);
run;
ods graphics off;

