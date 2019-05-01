
(load 'basicOp.lisp)
(load 'integration.lisp)
(load 'diff.lisp)

(setf exp1 1 )

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(print (integ '("Sin" ("Vari" (x 4 1 0 )))))           ;sinx
;(print (integ '("Cos" ("Vari" (x 4 1 0 )))))           ;cosx
;(print (integ '("Tan" ("Vari" (x 4 1 0 )))))           ;tanx
;(print (integ '("Cot" ("Vari" (x 4 1 0 )))))           ;cotx
;(print (integ '("Cosec" ("Vari" (x 4 1 0 )))))         ;cosecx
;(print (integ '("Sec" ("Vari" (x 4 1 0 )))))           ;secx
;(print (integ '("ACos" ("Vari" (x 4 1 0 )))))          ;acos x
;(print (integ '("ASin" ("Vari" (x 4 1 0 )))))          ; asinx
;
;(print (integ '( "Power" ( "Cosec" ( "Vari" ( x 2 1) )) ( "Const"  (2) ) )))           ;cosec^2 x 
;(print (integ '( "Power" ( "Sec" ( "Vari" ( x 2 1) )) ( "Const"  (2) ) )))             ; sec^2 x
;(print (integ '("Div" ("Cos" ("Vari" (x 1 1 0)) )  ( "Sin" ("Vari" ( x 1 1 0 ))))))        ; cosx / sinx
;
;(print (integ '("Power" ("MINUS" ("Const" (1)) ("Vari" (X 1 2 43)) ) ("Const" (-0.5)))))       ;output as asin
;(print (integ '("Power" ("MINUS" ("Const" (-1)) ("Vari" (X -1 2 43)) ) ("Const" (-0.5)))))            ;; for cos-1 as output. pls to not change.

;(print (integ '("Times" ("Sin" ("Vari" (x 1 1 0))) ("Cos" ("Vari" (x 1 1 0))) )))       ;;sinx * cosx
;(print (integ '( "Times" ("Sin" ("Vari" (x 4 1 0))) ( "Times" ("Const" (4) )  ("Cos" ("Vari" (x 4 1 0)  )   )           ) )))       ;;variant of above


;(print (integ '("Power" ("Plus" ("Const" (1)) ("Vari" (x 1 2 1))) ("Const" (-1)) )))            ;; 1/ ( 1 + x^2 )

;(print (integ '("Power" ("Plus" ("Const" (-1)) ("Vari" (x -1 2 1))) ("Const" (-1)) )))         ;; 1/ ( 1 + x^2)
















;;/////////////////////////////////// overrr


 

