@@ -13,14 +13,25 @@ turtles-own [

globals [
  cycle-days
  areaescola

]

to setup
  clear-all
  setup-population
  setup-escola
  reset-ticks
end


to setup-escola
set areaescola patches with [pxcor > 1  and pycor > 2]

  ask areaescola [ set pcolor yellow ]
end


to setup-population
  set-default-shape turtles "person"
  create-turtles population
@ -191,7 +202,7 @@ population
population
10
300
145.0
70.0
5
1
NIL
@ -255,7 +266,7 @@ lockdown-duration
lockdown-duration
0
92
10.0
58.0
1
1
NIL
@ -280,7 +291,7 @@ workday-duration
workday-duration
0
92
4.0
9.0
1
1
NIL
