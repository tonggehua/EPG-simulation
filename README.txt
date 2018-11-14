List of core EPG code
-----------------------
Contributors: Sairam Geethanath, Gehua Tong
-----------------------

rf_rotation.m (RF operator)
shift_grad.m (Gradient operator)
relax.m (T1,T2 relaxation operator)
* These three are employed by EPG_custom.m so you don't need to use them directly.


findEchos.m 
(find unique, nonzero F0 states that are not simultaneous with RF pulse; always picks the second one if two happen at the same time (we want the one after relaxation))
findAllEchos.m (find ALL nonzero F0 states)

display_echos.m (display echoes found from findEchos or findAllEchos)
display_epg.m (display EPG with echo locations)

EPG_custom.m (simulates EPG given seq struct; outputs all omegas and echos using findEchos)



Demos:
--------
EPGdemo_tutorial.m
EPGdemo_tutorial.pdf
