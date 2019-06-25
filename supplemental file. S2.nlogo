breed[homo_mutant_males homo_mutant_male]
breed[homo_mutant_females homo_mutant_female]
breed[hetero_mutant_males hetero_mutant_male]
breed[hetero_mutant_females hetero_mutant_female]
breed[wild_males wild_male]
breed[wild_females wild_female]

globals[wild homo_mutant  hetero_mutant total
  near_male_pink near_male_lime near_male_for_female_red
  distance_male_mutant-female_pink distance_male_mutant-female_lime distance_male_for_female_red
  bin_ct2 X1]

patches-own [mucus];;valiable

;;;;;;;;;;;;;;
;;; setpup ;;;
;;;;;;;;;;;;;;

to setup
  __clear-all-and-reset-ticks
  setup-patch

  setup-wild-male
  setup-wild-female
  setup-hetero_mutant_males
  setup-hetero_mutant_females

  reset-ticks

end


to setup-patch
  ask patches [set pcolor 97]
end

to setup-wild-male
 create-wild_males 4995  [setxy random-xcor random-ycor]
 ask wild_males [
 set pen-size 2
 set color blue
 set size 0.5
 ]
 end

to setup-wild-female
create-wild_females  4995  [setxy random-xcor random-ycor]
ask wild_females [
set pen-size 2
set color red
set size 0.5
]
end


to setup-hetero_mutant_females
create-hetero_mutant_females 5 [setxy random-xcor random-ycor]
ask hetero_mutant_females [
set pen-size 2
set color lime
set size 0.5
]
end

to setup-hetero_mutant_males
create-hetero_mutant_males 5 [setxy random-xcor random-ycor]
ask hetero_mutant_males [
set pen-size 2
set color cyan
set size 0.5
]
end



;;;;;;;;;;;;;;;;;;;;;
;;; Go procedures ;;;
;;;;;;;;;;;;;;;;;;;;;

to go

  if ticks >= 30  [ stop ]
  if ticks > 1 [
  if count hetero_mutant_females = 0 and count hetero_mutant_males = 0 and count homo_mutant_males = 0 and count homo_mutant_females = 0[ stop ]
 ]

  set-mucus

 repeat 30 [
  move-wild-abalone
  move-mutant-abalone
  disapper-of-mucus
 ]

  fertilization
  count-offsprings
  produce-next-generation

  tick
end


;;;;;;;;;;;;;;;;;;
;;; procedures ;;;
;;;;;;;;;;;;;;;;;;

to set-mucus
  ask turtles [
   set mucus mucus *  0
   set mucus mucus + 1
    if (mucus > 0)
   [set pcolor gray]
   ]
end

;;;abalones move according to the behavioral rules consist with behaviour of H.discus hannai

to move-wild-abalone
ask-concurrent turtles with [ color = red or color = blue][
  set X1 random-exponential 48.76 ;;;set the locomotion distance
   repeat X1[
   ifelse random 1 < 0 [rt random 360][lt random 360]
     forward 1  set mucus mucus *  0 set mucus mucus + 1 if (mucus > 0)
   [set pcolor gray]
 ]
]
end

to move-mutant-abalone
ask-concurrent  turtles with [ color = pink or color = sky or color = cyan or color = lime ][
   set X1  random-exponential 48.76  ;;;set the locomotion distance
   repeat X1   [ if not can-move? 1 [ifelse random 1 < 0 [rt 90][lt 90]]

   let bin_ct 0  ;;;set the mucus following rate
   repeat 78 [if random-float 1 < 0.8 [set bin_ct bin_ct + 1]]
   set bin_ct2 bin_ct / 78


   ifelse random-float 1 > bin_ct2
   [
     ifelse any? patches in-cone 1 180 with [pcolor = 97]
     [face one-of patches in-cone 1  180 with [pcolor = 97]
       forward 1 set mucus mucus * 0 set mucus mucus + 1 if (mucus > 0)[set pcolor gray]][
     ifelse random 1 < 0 [rt random 360][lt random 360]
       forward 1  set mucus mucus *  0 set mucus mucus + 1 if (mucus > 0)
   [set pcolor gray]]
   ]

   [
     ifelse any? patches in-cone 1 180 with [pcolor = gray][
    face one-of patches in-cone 1 180 with [ pcolor = gray ]
    forward 1 set mucus mucus *  0 set mucus mucus + 1 if (mucus > 0)
   [set pcolor gray]
   ]

   [ifelse random 1 < 0 [rt random 360][lt random 360]
     forward 1  set mucus mucus *  0 set mucus mucus + 1 if (mucus > 0)
   [set pcolor gray]]
   ]
 ]
]

end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to disapper-of-mucus
  ask patches with [pcolor = gray][
  set mucus mucus - 1
  if (mucus < 0)
  [set pcolor 97]
   ]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
to fertilization
ask turtles with [color = pink] [

    set near_male_pink min-one-of turtles with [color = blue or color = sky or color = cyan or color = brown] [distance myself]

    let mutant-near_male_positiony_pink  [ycor] of near_male_pink
    let mutant-near_male_positionx_pink  [xcor] of near_male_pink
    let mutant-female_positiony_pink  [ycor] of self
    let mutant-female_positionx_pink  [xcor] of self

    set distance_male_mutant-female_pink (sqrt ( (mutant-female_positionx_pink - mutant-near_male_positionx_pink) ^ 2 +  (mutant-female_positiony_pink - mutant-near_male_positiony_pink) ^ 2))
    let fertilization_pink  (88.31 * exp(-0.32 * (distance_male_mutant-female_pink / 10 )))

    if [color] of near_male_pink = sky [hatch fertilization_pink / 10 [setxy random-xcor random-ycor set color yellow]]


    if [color] of near_male_pink = cyan [hatch (fertilization_pink / 10 * 2) [setxy random-xcor random-ycor set color yellow]
                                              hatch (fertilization_pink / 10 * 2) [setxy random-xcor random-ycor set color green]]

    if [color] of near_male_pink = blue [hatch fertilization_pink / 10 [setxy random-xcor random-ycor set color green]]

    die
      ]

 ask turtles with [color = lime] [

    set near_male_lime min-one-of turtles with [color = blue or color = sky or color = cyan] [distance myself]

    let mutant-near_male_positiony_lime  [ycor] of near_male_lime
    let mutant-near_male_positionx_lime  [xcor] of near_male_lime
    let mutant-female_positiony_lime  [ycor] of self
    let mutant-female_positionx_lime  [xcor] of self

    set distance_male_mutant-female_lime (sqrt ( (mutant-female_positionx_lime - mutant-near_male_positionx_lime) ^ 2 +  (mutant-female_positiony_lime - mutant-near_male_positiony_lime) ^ 2))
    let fertilization_lime  (88.31 * exp(-0.32 * (distance_male_mutant-female_lime / 10 )))

    if [color] of near_male_lime = sky [ hatch (fertilization_lime / 10)* 0.75 [setxy random-xcor random-ycor set color yellow]
                                              hatch (fertilization_lime / 10) * 0.25 [setxy random-xcor random-ycor set color green] ]

    if [color] of near_male_lime = blue [ hatch (fertilization_lime / 10)* 0.75 [setxy random-xcor random-ycor set color magenta]
                                              hatch (fertilization_lime / 10)* 0.25 [setxy random-xcor random-ycor set color yellow] ]

    if [color] of near_male_lime = cyan  [ hatch (fertilization_lime / 10)* 0.75 [setxy random-xcor random-ycor set color yellow]
                                              hatch (fertilization_lime / 10)* 0.25 [setxy random-xcor random-ycor set color green] ]

  die
 ]


ask turtles with [color = red] [

    set near_male_for_female_red min-one-of turtles with [color = blue or color = sky or color = cyan] [distance myself]

    let near_male_positiony_red  [ycor] of near_male_for_female_red
    let near_male_positionx_red  [xcor] of near_male_for_female_red
    let female_positiony_red  [ycor] of self
    let female_positionx_red  [xcor] of self

    set distance_male_for_female_red (sqrt ( (female_positionx_red - near_male_positionx_red) ^ 2 +  (female_positiony_red - near_male_positiony_red) ^ 2))
    let fertilization_red   (88.31 * exp(-0.32 * (distance_male_for_female_red / 10)))


    if [color] of near_male_for_female_red = blue [hatch (fertilization_red / 10) [setxy random-xcor random-ycor set color magenta]]


    if [color] of near_male_for_female_red = cyan [ hatch (fertilization_red / 10)* 0.5 [setxy random-xcor random-ycor set color magenta]
                                              hatch (fertilization_red / 10)* 0.5 [setxy random-xcor random-ycor set color yellow] ]

    if [color] of near_male_for_female_red = sky [hatch (fertilization_red / 10) [setxy random-xcor random-ycor set color green]]

   die

]

end


to count-offsprings
set homo_mutant (count turtles with [color = yellow]);;
set hetero_mutant ((count turtles with [color = green]));;

set wild (count turtles with [color = magenta]);;
set total (homo_mutant + hetero_mutant + wild )
ask turtles [die]

end



to produce-next-generation

   create-homo_mutant_males (10000  * (homo_mutant  / total)) / 2
       [set size 0.5 setxy random-xcor random-ycor set color sky ]

   create-homo_mutant_females (10000  * (homo_mutant  / total)) / 2
       [set size 0.5 setxy random-xcor random-ycor  set color pink ]

   create-hetero_mutant_males (10000  * ( hetero_mutant / total)) / 2
       [set size 0.5 setxy random-xcor random-ycor set color cyan]

   create-hetero_mutant_females (10000  * (hetero_mutant / total)) / 2
       [set size  0.5 setxy random-xcor random-ycor set color lime]

   create-wild_males (10000  * ( wild  / total)) / 2
       [set size 0.5 setxy random-xcor random-ycor set color blue ]

   create-wild_females (10000  * ( wild  / total)) / 2
       [set size 0.5 setxy random-xcor random-ycor set color red ]



end
@#$#@#$#@
GRAPHICS-WINDOW
239
25
1257
1064
-1
-1
1.008
1
3
1
1
1
0
0
0
1
0
999
0
999
0
0
1
ticks
30.0

BUTTON
7
52
71
85
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
6
89
69
122
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
1

MONITOR
1273
369
1482
418
Number_of_homo_mutant_females(DD)
count turtles with [color = pink]
17
1
12

MONITOR
1275
95
1474
144
Number of wild females(dd)
count turtles with [color = red ]
17
1
12

MONITOR
1274
148
1476
197
Number_of_wild_males(dd)
count turtles with [color = blue]
17
1
12

MONITOR
1273
231
1478
280
Number_of_hetero_mutant_males(Dd)
count turtles with [color = cyan]
17
1
12

MONITOR
1273
288
1480
337
Nimber_of_hetero_mutant_females(Dd)
count turtles with [color = lime]
17
1
12

MONITOR
1273
426
1483
475
Number_of_homo_mutant_males(DD)
count turtles with [color = sky]
17
1
12

@#$#@#$#@
## ## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## ## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## ## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## ## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## ## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## ## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## ## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## ## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## ## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
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
NetLogo 5.3.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="test" repetitions="1000" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>count turtles with [color = red or color = blue]</metric>
    <metric>count turtles with [color = pink or color = sky]</metric>
    <metric>count turtles with [color = lime or color = cyan]</metric>
  </experiment>
</experiments>
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
