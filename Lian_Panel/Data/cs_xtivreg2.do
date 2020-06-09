* xtivreg2 cert script 1.0.2 MES 2006-04-21
* requires -eret2- for last check at end
set more off
cscript xtivreg2 adofile xtivreg2
capture log close
log using cs_xtivreg2, replace
which xtivreg2

* Layard-Nickell-Arellano-Bond dataset
use http://www.stata-press.com/data/r7/abdata.dta, replace
tsset, clear

******************* LSDV **************************

* Prepare mean-deviations
capture drop *_md
capture drop *_m
sort id
foreach var of varlist n w k ys wage emp {
	by id: gen double `var'_m  = sum(`var')/_N
	by id: gen double `var'_md = `var'-`var'_m[_N]
	}

xtreg n w k ys, fe i(id)
mat xtb=e(b)
mat xtV=e(V)
xtivreg2 n w k ys, fe i(id) small
mat xtiv2b=e(b)
mat xtiv2V=e(V)
assert reldif(xtb[1,1],xtiv2b[1,1]) < 1e-7
assert reldif(xtb[1,2],xtiv2b[1,2]) < 1e-7
assert reldif(xtb[1,3],xtiv2b[1,3]) < 1e-7
assert reldif(xtV[1,1],xtiv2V[1,1]) < 1e-7
assert reldif(xtV[1,2],xtiv2V[1,2]) < 1e-7
assert reldif(xtV[1,3],xtiv2V[1,3]) < 1e-7
assert reldif(xtV[2,1],xtiv2V[2,1]) < 1e-7
assert reldif(xtV[2,2],xtiv2V[2,2]) < 1e-7
assert reldif(xtV[2,3],xtiv2V[2,3]) < 1e-7
assert reldif(xtV[3,1],xtiv2V[3,1]) < 1e-7
assert reldif(xtV[3,2],xtiv2V[3,2]) < 1e-7
assert reldif(xtV[3,3],xtiv2V[3,3]) < 1e-7

* LSDV, robust
areg n w k ys, absorb(id) robust
mat xtb=e(b)
mat xtV=e(V)
xtivreg2 n w k ys, fe i(id) small robust
mat xtiv2b=e(b)
mat xtiv2V=e(V)
assert reldif(xtb[1,1],xtiv2b[1,1]) < 1e-7
assert reldif(xtb[1,2],xtiv2b[1,2]) < 1e-7
assert reldif(xtb[1,3],xtiv2b[1,3]) < 1e-7
assert reldif(xtV[1,1],xtiv2V[1,1]) < 1e-7
assert reldif(xtV[1,2],xtiv2V[1,2]) < 1e-7
assert reldif(xtV[1,3],xtiv2V[1,3]) < 1e-7
assert reldif(xtV[2,1],xtiv2V[2,1]) < 1e-7
assert reldif(xtV[2,2],xtiv2V[2,2]) < 1e-7
assert reldif(xtV[2,3],xtiv2V[2,3]) < 1e-7
assert reldif(xtV[3,1],xtiv2V[3,1]) < 1e-7
assert reldif(xtV[3,2],xtiv2V[3,2]) < 1e-7
assert reldif(xtV[3,3],xtiv2V[3,3]) < 1e-7

* LSDV, cluster
* No dof adjustment need (areg is over-conservative)
regress n_md w_md k_md ys_md, nocons cluster(id)
mat xtb=e(b)
mat xtV=e(V)
xtivreg2 n w k ys, fe i(id) small cluster(id)
mat xtiv2b=e(b)
mat xtiv2V=e(V)
assert reldif(xtb[1,1],xtiv2b[1,1]) < 1e-7
assert reldif(xtb[1,2],xtiv2b[1,2]) < 1e-7
assert reldif(xtb[1,3],xtiv2b[1,3]) < 1e-7
assert reldif(xtV[1,1],xtiv2V[1,1]) < 1e-7
assert reldif(xtV[1,2],xtiv2V[1,2]) < 1e-7
assert reldif(xtV[1,3],xtiv2V[1,3]) < 1e-7
assert reldif(xtV[2,1],xtiv2V[2,1]) < 1e-7
assert reldif(xtV[2,2],xtiv2V[2,2]) < 1e-7
assert reldif(xtV[2,3],xtiv2V[2,3]) < 1e-7
assert reldif(xtV[3,1],xtiv2V[3,1]) < 1e-7
assert reldif(xtV[3,2],xtiv2V[3,2]) < 1e-7
assert reldif(xtV[3,3],xtiv2V[3,3]) < 1e-7

************** IV ************************

* Standard homoskedastic, small
* Check just b, V and sargan with dof adjustment
tsset id year
set matsize 200
qui xi: ivreg2 n i.id year (w=k ys wage), small
mat ivb=e(b)
mat ivV=e(V)
scalar ivsargan=e(sargan)
xtivreg2 n year (w=k ys wage), fe small
mat xtiv2b=e(b)
mat xtiv2V=e(V)
assert reldif(ivb[1,1],xtiv2b[1,1]) < 1e-7
assert reldif(ivV[1,1],xtiv2V[1,1]) < 1e-7
assert reldif(ivsargan*(e(df_r)+e(df_b))/e(N),e(sargan)) < 1e-7

* Fixed effects is identical to FD when only two time periods (and nocons in latter)

* Prepare mean-deviations
capture drop *_md
capture drop *_m
capture drop touse
gen touse=1 if year==1980 | year==1981
sort id touse
foreach var of varlist n w k ys wage emp year {
	by id touse: gen double `var'_m  = sum(`var')/_N 
	by id touse: gen double `var'_md = `var'-`var'_m[_N]
	}

* Standard homoskedastic, small
tsset id year
ivreg2 d.n (d.w=d.k d.ys d.wage) if year==1981, nocons small ffirst orthog(d.ys) redundant(d.ys)
savedresults save iv2 e()
xtivreg2 n (w=k ys wage) if year==1980 | year==1981, fe small ffirst orthog(ys) redundant(ys)
savedresults comp iv2 e(), include( /*
	*/	scalar: df_r sargan sargandf cstat cstatdf idstat iddf cdchi2 cdf /*
	*/	redstat reddf archi2 arf ardf ardf_r /*
	*/	matrix: b V /*
	*/	) tol(1e-7) verbose
xtivreg2 n (w=k ys wage) if year==1981, fd nocons small ffirst orthog(ys) redundant(ys)
savedresults comp iv2 e(), include( /*
	*/	scalar: df_r sargan sargandf cstat cstatdf idstat iddf cdchi2 cdf /*
	*/	redstat reddf archi2 arf ardf ardf_r /*
	*/	matrix: b V /*
	*/	) tol(1e-7) verbose
savedresults drop iv2
* Ditto, large
tsset id year
ivreg2 d.n (d.w=d.k d.ys d.wage) if year==1981, nocons ffirst orthog(d.ys) redundant(d.ys)
savedresults save iv2 e()
xtivreg2 n (w=k ys wage) if year==1980 | year==1981, fe ffirst orthog(ys) redundant(ys)
savedresults comp iv2 e(), include( /*
	*/	scalar:      sargan sargandf cstat cstatdf idstat iddf cdchi2 cdf /*
	*/	redstat reddf archi2 arf ardf ardf_r /*
	*/	matrix: b V /*
	*/	) tol(1e-7) verbose
xtivreg2 n (w=k ys wage) if year==1981, fd nocons ffirst orthog(ys) redundant(ys)
savedresults comp iv2 e(), include( /*
	*/	scalar:      sargan sargandf cstat cstatdf idstat iddf cdchi2 cdf /*
	*/	redstat reddf archi2 arf ardf ardf_r /*
	*/	matrix: b V /*
	*/	) tol(1e-7) verbose
savedresults drop iv2

* Robust, small
tsset id year
ivreg2 d.n (d.w=d.k d.ys d.wage) if year==1981, nocons small ffirst orthog(d.ys) redundant(d.ys) robust
savedresults save iv2 e()
xtivreg2 n (w=k ys wage) if year==1980 | year==1981, fe small ffirst orthog(ys) redundant(ys) robust
savedresults comp iv2 e(), include( /*
	*/	scalar: df_r j jdf cstat cstatdf idstat iddf cdchi2 cdf /*
	*/	redstat reddf archi2 arf ardf ardf_r /*
	*/	matrix: b V /*
	*/	) tol(1e-7) verbose
xtivreg2 n (w=k ys wage) if year==1981, fd nocons small ffirst orthog(ys) redundant(ys) robust
savedresults comp iv2 e(), include( /*
	*/	scalar: df_r j jdf cstat cstatdf idstat iddf cdchi2 cdf /*
	*/	redstat reddf archi2 arf ardf ardf_r /*
	*/	matrix: b V /*
	*/	) tol(1e-7) verbose
savedresults drop iv2
* Ditto, large
tsset id year
ivreg2 d.n (d.w=d.k d.ys d.wage) if year==1981, nocons ffirst orthog(d.ys) redundant(d.ys) robust
savedresults save iv2 e()
xtivreg2 n (w=k ys wage) if year==1980 | year==1981, fe ffirst orthog(ys) redundant(ys) robust
savedresults comp iv2 e(), include( /*
	*/	scalar: j jdf cstat cstatdf idstat iddf cdchi2 cdf /*
	*/	redstat reddf archi2 arf ardf ardf_r /*
	*/	matrix: b V /*
	*/	) tol(1e-7) verbose
xtivreg2 n (w=k ys wage) if year==1981, fd nocons ffirst orthog(ys) redundant(ys) robust
savedresults comp iv2 e(), include( /*
	*/	scalar: j jdf cstat cstatdf idstat iddf cdchi2 cdf /*
	*/	redstat reddf archi2 arf ardf ardf_r /*
	*/	matrix: b V /*
	*/	) tol(1e-7) verbose
savedresults drop iv2

* cluster, small
* Do not use AR F stats because they don't match between FD and MD methods
* Stata's finite sample qc correction is (N-1)/(N-k)*M/(M-1)
* With FDs, N=140, AR F=66.60
* With MDs, N=280, AR F=67.09
tsset id year
ivreg2 d.n (d.w=d.k d.ys d.wage) if year==1981, nocons small ffirst orthog(d.ys) redundant(d.ys) cluster(id)
savedresults save iv2 e()
xtivreg2 n (w=k ys wage) if year==1980 | year==1981, fe small ffirst orthog(ys) redundant(ys) cluster(id)
savedresults comp iv2 e(), include( /*
	*/	scalar: df_r j jdf cstat cstatdf idstat iddf cdchi2 cdf /*
	*/	redstat reddf archi2 /*
	*/	matrix: b V /*
	*/	) tol(1e-7) verbose
xtivreg2 n (w=k ys wage) if year==1981, fd nocons small ffirst orthog(ys) redundant(ys) cluster(id)
savedresults comp iv2 e(), include( /*
	*/	scalar: df_r j jdf cstat cstatdf idstat iddf cdchi2 cdf /*
	*/	redstat reddf archi2 arf ardf ardf_r /*
	*/	matrix: b V /*
	*/	) tol(1e-7) verbose
savedresults drop iv2
* cluster, large
tsset id year
ivreg2 d.n (d.w=d.k d.ys d.wage) if year==1981, nocons ffirst orthog(d.ys) redundant(d.ys) cluster(id)
savedresults save iv2 e()
xtivreg2 n (w=k ys wage) if year==1980 | year==1981, fe ffirst orthog(ys) redundant(ys) cluster(id)
savedresults comp iv2 e(), include( /*
	*/	scalar: j jdf cstat cstatdf idstat iddf cdchi2 cdf /*
	*/	redstat reddf archi2 /*
	*/	matrix: b V /*
	*/	) tol(1e-7) verbose
xtivreg2 n (w=k ys wage) if year==1981, fd nocons ffirst orthog(ys) redundant(ys) cluster(id)
savedresults comp iv2 e(), include( /*
	*/	scalar: j jdf cstat cstatdf idstat iddf cdchi2 cdf /*
	*/	redstat reddf archi2 arf ardf ardf_r /*
	*/	matrix: b V /*
	*/	) tol(1e-7) verbose
savedresults drop iv2

* arf ardf ardf_r 
* AR stats with cluster by hand
xtivreg2 n (w=k ys wage) if year==1980 | year==1981, fe small ffirst cluster(id)
scalar archi2=e(archi2)
scalar arf=e(arf)
scalar ardf=e(ardf)
scalar ardf_r=e(ardf_r)
regress n_md k_md ys_md wage_md if year==1980 | year==1981, cluster(id) nocons
test k_md ys_md wage_md
assert reldif(arf,r(F)) < 1e-7
assert reldif(ardf,r(df)) < 1e-7
assert reldif(ardf_r,r(df_r)) < 1e-7
ivreg2 n_md k_md ys_md wage_md if year==1980 | year==1981, cluster(id) nocons small
test k_md ys_md wage_md
assert reldif(arf,r(F)) < 1e-7
ivreg2 d.n d.k d.ys d.wage if year==1981, cluster(id) nocons
test d.k d.ys d.wage
assert reldif(archi2,r(chi2)) < 1e-7

* Frequency weights
xtivreg2 n (w=k ys wage) [fw=ind], fe small ffirst orthog(ys) redundant(ys)
savedresults save fw e()
expand ind
xtivreg2 n (w=k ys wage), fe small ffirst orthog(ys) redundant(ys)
savedresults comp fw e(), include(macros: depvar scalar: N g_min g_avg g_max matrix: b V) tol(1e-7) verbose
qui duplicates drop


* Singleton groups
xtivreg2 n (w=k ys wage) if ~(id<=3 & year>1977), fe
assert e(singleton)==3
assert e(N)==1010
assert e(N_g)==137

* HAC
xtivreg2 n (w=k ys wage), fe small ffirst bw(3) ivar(id) tvar(year)

* vs. official xtivreg

* FD
tsset id year
xtivreg  n (w=k ys wage), fd small
savedresults save iv e()
xtivreg2 n (w=k ys wage), fd small
savedresults comp iv e(), include( /*
	*/	scalar: N N_g df_r F df_b sigma_e g_min g_max g_avg /*
	*/	matrix: b V /*
	*/	) tol(1e-7) verbose
savedresults drop iv

* FE
tsset id year
xtivreg  n cap (w=k ys wage), fe small
mat b2=e(b)
mat b2=b2[1,1..2]
mat V2=e(V)
mat V2=V2[1..2,1..2]
eret2 mat b2=b2
eret2 mat V2=V2
savedresults save iv e()
xtivreg2 n cap (w=k ys wage), fe small
mat b2=e(b)
mat V2=e(V)
eret2 mat b2=b2
eret2 mat V2=V2
eret2 scalar r2_w=e(r2)
savedresults comp iv e(), include( /*
	*/	scalar: N N_g df_r F df_b sigma_e g_min g_max g_avg r2_w /*
	*/	matrix: b2 V2 /*
	*/	) tol(1e-7) verbose
savedresults drop iv

* Check first stage and reduced form saved results
tsset id year
* First-stage
xtivreg2 n year (w=k ys wage), fe small savefirst savefprefix(_csxtivreg2_)
estimates replay _csxtivreg2_w
estimates restore _csxtivreg2_w
savedresults save fs e()
xtivreg2 w year k ys wage, fe small
savedresults compare fs e(), exclude( macro: _estimates_name _estimates_title )
* Reduced-form
xtivreg2 n year (w=k ys wage), fe small saverf saverfprefix(_csxtivreg2_)
estimates replay _csxtivreg2_n
estimates restore _csxtivreg2_n
savedresults save fs e()
xtivreg2 n year k ys wage, fe small
savedresults compare fs e(), exclude( macro: _estimates_name _estimates_title )

* Check that orthog/cstat and endog/estat generate same test statistic
qui xtivreg2 n year w (=k ys wage), orthog(w) fe i(id)
scalar cstat=e(cstat)
qui xtivreg2 n year (w=k ys wage), endog(w) fe i(id)
scalar estat=e(estat)
assert reldif(cstat,estat) < 1e-7

capture log close
