* B7_panel: introduction to fixed effects model

clear
set obs 60
set seed 1357911

gen x = invnorm(uniform())
gen e = 2*invnorm(uniform())
*winsor xx, gen(x) p(0.25)

gen y = 1 + 3*x + e 
replace y = 8 + 3*(x+4) + e in 21/40
replace y = 16 + 3*(x+8) + e in 41/60

egen id= seq(), from(1) to(3) block(20)
drop if (x>1&id==3) | (x<-1&id==2) | (x<-0.4&id==1)
bysort id : gen t = _n + 1990
order id t y x
tsset id t



























