breed [healthys healthy]
breed [sicks sick]
breed [houses house]
breed [schools school]

turtles-own [
  healthy?
  sick?               ;; if true, the turtle is infectious
  immune?             ;; if true, the turtle can't be infected
  sick-time           ;; how long, in weeks, the turtle has been infectious
  immune-time
  speed
  homebase            ;; the home patch of this person
  leak-prob
  student?            ;; if the turtle is a student or not
  severity            ;; where 0 = mild and 1 = severe symptoms
  lockdown?
]


globals [
  cycle-days
  school-area
  day hour
  tick-day
  n-students
  n-students-sicks
  n-deaths
  n-leaks
]

to setup
  clear-all
  set n-students-sicks 0
  set n-leaks 0
  set n-deaths 0
  set tick-day 10
  setup-city
  setup-school
  setup-population
  reset-ticks
end

to setup-city
   create-houses (population / 3) [
     setxy (random-xcor * 0.95) (random-ycor * (0.50))
     set color white set shape "house" set size 12
   ]
end

to setup-school
  set school-area patches with [pxcor > 20  and pycor > 90]
  ask school-area [ set pcolor yellow ]
end

to setup-population
  set-default-shape turtles "person"
  create-turtles population
  [
    set color green
    set size 7
    set breed healthys
    set speed 0.1
    set student? false
    set sick? false
    set sick-time 0
    set immune? false
    set immune-time 0
    set healthy? true
    set lockdown? false
    set severity 0
    set leak-prob 0
    set homebase one-of houses
    move-to homebase
  ]
  setup-students
  setup-population-leak
  ask n-of (population / 20) healthys
    [ set severity 1 ]
  ask n-of initial-infecteds healthys
    [ become-infected ]
end

to setup-population-leak
  ask n-of ((population * %-population-leak) / 100) healthys with[not student?]
  [
    set leak-prob 1
    set n-leaks n-leaks + 1
  ]
end

to setup-students
  set n-students (count houses)
  ask n-of n-students healthys
     [ set student? true ]
end

to go
  adjust
  if immunity-duration?
    [ immunity-control ]
  tick
end

;; call specific strategy
to adjust
  if strategy-type = "none" [
     ad-none
     clock
  ]
  if strategy-type = "lockdown" [
     let control (count sicks)
     ad-lockdown
     clock
  ]
  if strategy-type = "cyclic" [
     set cycle-days 0
     let lockdown-counter (tick-day * lockdown-duration)
     let schoolday-counter (tick-day * schoolday-duration)
     while [ cycle-days < (lockdown-counter + schoolday-counter) + 1 ]
     [
         ifelse cycle-days < schoolday-counter + 1
           [ move-to-school
             epidemic ]
           [ ad-lockdown ]
         if ticks mod tick-day = 0
           [ set cycle-days (cycle-days + tick-day) ]
         tick
         clock
     ]
  ]
end

;; update counters of days and hours
to clock
  set day int (ticks / tick-day)
  set hour int ((ticks / tick-day) * 24)
end

to ad-none
  ask turtles [ set lockdown? false ]
  move-to-school
  move-turtles
  epidemic
  recover-or-die
end

to ad-lockdown
  let people (turtle-set healthys sicks)
  ask people
  [ ifelse leak-prob = 0
    [ set lockdown? true
      move-to homebase
      forward 0 ]
    [ set lockdown? false
      move-turtles ]
  ]
  ask houses [
    set color ifelse-value any? sicks-here with [ sick? ][ red ][ white ]
  ]
  epidemic
  recover-or-die
end

;; student turtles move to school
to move-to-school
  ask turtles with[shape = "person"][
    if student?
    [
      ifelse sick? and severity = 1
        [ move-to homebase
          forward 0 ]
        [ move-to one-of patches with [pcolor = yellow] ]
    ]
  ]
  let people (turtle-set healthys sicks)
  ask people with[not student?]
  [
    if leak-prob = 1
    [ set lockdown? false
      move-turtles ]
  ]
  epidemic
end

;; turtles move about at random.
to move-turtles
  ask turtles with [shape = "person" and not student? and not lockdown?][
    let current-turtle self
    if [pcolor] of patch-ahead 1 != yellow [
      set heading heading + (random-float 3 - random-float 3)
      forward 1]
    if [pcolor] of patch-ahead 3 = yellow [
      set heading heading - 100
      forward 1
    ]
    if distance current-turtle < 1 + (count sicks) [
      set heading heading + (random-float 5 - random-float 5)]
  ]
  epidemic
end

;; turtles infecting others
to epidemic
  ask sicks [
    let current-sick self
    ask healthys with[distance current-sick < 2 and not immune?] [
       ifelse not prevention-care?
       [ if random-float 100 < infectiouness-probability
           [ become-infected ]
       ]
       [
         let prob-with-prevention random-float 60
         if random-float 100 < (infectiouness-probability - prob-with-prevention)
           [ become-infected ]
       ]
    ]
  ]
end

to set-infected
  ask one-of healthys
    [ become-infected ]
end

to become-infected
  set breed sicks
  set sick-time day
  set color red
  set sick? true
  set immune? false
  set healthy? false
  if student?
    [ set n-students-sicks (n-students-sicks + 1) ]
end

to recover-or-die
   ask sicks with[severity = 0 and sick-time <= day - (random(14 - 7 + 1) + 7)]
   [
     ifelse random-float 100 <= recovery-probability
     [ become-well ]
     [ set n-deaths n-deaths + 1
       die ]
   ]
   ask sicks with[severity = 1 and sick-time <= day - (random(56 - 14 + 1) + 14)]
   [
     ifelse random-float 100 <= recovery-probability
     [ become-well ]
     [ set n-deaths n-deaths + 1
       die ]
   ]
end

to become-well
  set color gray
  set immune? true
  set immune-time day
  set sick? false
  set breed healthys
end

to immunity-control
  ask healthys with[immune? and immune-time <= day - 92]
    [ set immune? false
      set color green
      set immune-time 0 ]
end

; Report data of simulation
to-report total-infected
  report count sicks
end

to-report total-deaths
  report n-deaths
end

to-report number-of-students
  report n-students
end

to-report number-of-leak
  report n-leaks
end
@#$#@#$#@
GRAPHICS-WINDOW
389
16
848
476
-1
-1
1.5
1
10
1
1
1
0
1
1
1
-150
150
-150
150
0
0
1
ticks
30.0

SLIDER
22
95
194
128
population
population
12
999
195.0
3
1
NIL
HORIZONTAL

SLIDER
201
141
374
174
infectiouness-probability
infectiouness-probability
0
100
56.0
1
1
%
HORIZONTAL

BUTTON
21
19
84
52
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
93
19
156
52
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
17
439
189
472
lockdown-duration
lockdown-duration
0
31
10.0
1
1
NIL
HORIZONTAL

TEXTBOX
21
411
206
433
Cyclic strategy
16
93.0
1

SLIDER
197
440
369
473
schoolday-duration
schoolday-duration
0
31
4.0
1
1
NIL
HORIZONTAL

TEXTBOX
24
70
220
88
Population characteristics\n\n
16
93.0
1

CHOOSER
20
266
192
311
strategy-type
strategy-type
"cyclic" "lockdown" "none"
0

TEXTBOX
22
241
172
261
Strategy type
16
93.0
1

SLIDER
22
141
193
174
recovery-probability
recovery-probability
0
100
100.0
1
1
%
HORIZONTAL

TEXTBOX
131
416
341
444
(only if cyclic-strategy is select above)
11
0.0
1

PLOT
865
17
1320
286
Populations
days
people
0.0
92.0
0.0
300.0
true
true
"" ""
PENS
"total" 1.0 0 -13345367 true "" "let people (turtle-set healthys sicks)\nplot count people"
"never-infected" 1.0 0 -14439633 true "" "plot count healthys with [ not immune? ]"
"sick" 1.0 0 -2674135 true "" "plot count sicks with [ sick? ]"
"immunes" 1.0 0 -7500403 true "" "plot count healthys with [ immune? ]"

MONITOR
970
295
1065
340
Total infected
total-infected
0
1
11

SWITCH
19
340
191
373
prevention-care?
prevention-care?
1
1
-1000

TEXTBOX
19
322
215
350
(mask, safe distance and so on)
11
0.0
1

MONITOR
390
16
457
61
Clock:
(word day \"d, \" (hour mod 24) \"h\")
17
1
11

SLIDER
202
95
374
128
initial-infecteds
initial-infecteds
0
100
29.0
1
1
NIL
HORIZONTAL

MONITOR
1075
296
1214
341
Total of infected students
n-students-sicks
17
1
11

MONITOR
864
295
960
340
Total of students
number-of-students
17
1
11

BUTTON
202
18
375
51
NIL
set-infected
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
1225
295
1322
340
Total of deaths
total-deaths
17
1
11

MONITOR
864
350
1065
395
Number of people breaking quarantine
number-of-leak
17
1
11

SLIDER
21
185
193
218
%-population-leak
%-population-leak
0
100
30.0
1
1
%
HORIZONTAL

SWITCH
201
340
373
373
immunity-duration?
immunity-duration?
1
1
-1000

TEXTBOX
202
322
389
350
(if on, immunity duration = 92 days)
11
0.0
1

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

São simuladas três tipos de estratégias: 

- **"Cyclic"**: onde durante uma quantidade _x_ de dias a população estudantil poderá ir para a escola e durante uma quantidade _y_, ficará em lockdown em sua casa juntamente com sua família.

- **"Lockdown"**: onde toda a população ficará durante tempo indeterminado em isolamento em cada casa.

- **"None"**: onde nenhuma medida de isolamento é tomada, ou seja, a população movimenta-se livremente pelo ambiente.

## HOW TO USE IT

Para rodar a simulação, aperte SETUP e depois GO. Visto que a simulação busca analisar a estratégia escolhida ao longo do tempo, para finalizá-la é necessário apertar novamente o botão GO para o deselecionar. 


O slider POPULATION controla quantas pessoas são levadas em consideração na simulação. A quantidade selecionada é um múltiplo de 3, visto que essa população será dividida em HOMEBASES (famílias) e a média de pessoas por família no Brasil é igual a 3, de acordo com o IBGE [2].

Para determinar a quantidade de infectados iniciais de uma população, utilize o slider INITIAL-INFECTEDS. O botão SET-INFECTED seleciona um pessoa aleatória da população e a torna infetada.

A variável RECOVERY-PROBABILITY determina a probabilidade máxima de uma pessoa da população, após a contaminação, recuperar-se e tornar-se imune a doença. Enquanto que a variável INFECTIOUNESS-PROBABILITY determina a probabilidade máxima de uma pessoa infectada da população contaminar outra pessoa próxima.

O slider %-POPULATION-LEAK determina a porcentagem da população que não adere ao lockdown, movimentando-se pelo ambiente.

O seletor STRATEGY-TYPE determina a estratégia que será utilizada na simulação, podendo variar entre uma estratégia cíclica, lockdown ou none (nenhuma medida de isolamento é tomada). Visto que essa simulação busca analisar principalmente a estratégia cíclica, ela é tida como valor inicial desse seletor.

Se a variável PREVENTION-CARE? está em "On", a probabilidade de infectar outra pessoa (INFECTIOUNESS-PROBABILITY) é diminuída em até 60%, porcentagem estimada através de estudos [3, 4] que levam em consideração a utilização de máscaras e cuidados de higiene. 

Os sliders LOCKDOWN-DURATION e SCHOOLDAY-DURATION determinam a quantidade de dias do cronograma da estratégia cíclica, onde LOCKDOWN-DURATION determina quantos dias a população ficará isolada em casa, enquanto SCHOOLDAY-DURATION determina quantos dias a população estudantil irá mover-se de casa para a escola.


## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## RELATED MODELS

Alvarez, L. and Rojas-Galeano, S. “Simulation of Non-Pharmaceutical Interventions on COVID-19 with an Agent-based Model of Zonal Restraint”. medRxiv pre-print 2020/06/13; https://www.medrxiv.org/content/10.1101/2020.06.13.20130542v1 DOI: 10.1101/2020.06.13.20130542

## CREDITS AND REFERENCES

[1] Karin, Omer & Bar-On, Yinon & Milo, Tomer & Katzir, Itay & Mayo, Avi & Korem, Yael & Dudovich, Boaz & Zehavi, Amos & Davidovich, Nadav & Milo, Ron & Alon, Uri. (2020). Adaptive cyclic exit strategies from lockdown to suppress COVID-19 and allow economic activity. DOI: 10.1101/2020.04.04.20053579. 

[2] Ohana, Victor. (2019). IBGE: 2,7% das famílias ganham um quinto de toda a renda no Brasil. Acesso em: 22/06/2020, https://www.cartacapital.com.br/sociedade/ibge-27-das-familias-ganham-um-quinto-de-toda-a-renda-no-brasil/amp/

[3] Holanda, Debora. (2020). Simulador para estudo de comportamento do COVID-19 na população brasileira. Acesso em: 22/06/2020, https://medium.com/@holanda.debora/simulador-para-estudo-de-comportamento-do-covid-19-na-população-brasileira-c809ea8586c9.

[4] Macintyre, Chandini & Chughtai, Abrar. (2015). Facemasks for the prevention of infection in healthcare and community settings. DOI: 10.1136/bmj.h694. 
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
