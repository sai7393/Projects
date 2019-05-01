
(setf start "int")

(defun integ (exp)
    ;(print exp)
    ;(print 77)
    (setf funcName (intern (concatenate 'string start (car exp))))
    (apply funcName (cdr exp))
)

(defun |intConst| (EXPS)
    (list "Vari" `(x ,(car EXPS) 1 C) )
)

(defun |intDiv| (&rest exps)
(if (equal (car exps) (differ (cadr exps)))
 ( list "Log" (list (cadr exps)))
    
 )
)

(defun |intPlus| (&rest EXPS)
    (setf funcName (intern (concatenate 'string start (caar exps))))
    (if (null (cadr exps))
        (apply (intern (concatenate 'string start (caar exps))) (cdar exps))
        ( cons "Plus" ( cons (apply (intern (concatenate 'string start (caar exps))) (cdar exps)) (cons (apply #'|intPlus| (cdr exps))nil)) ) 
    )
)

(defun |intVari| (x)
    (if (= (caddr x) -1)
        (list "Log" (list "Vari" (list (car x)  (cadr x) 1 (cadddr x))) )
        (list "Vari" (list (car x) (/ (cadr x) (+ (caddr x) 1) ) (+ (caddr x) 1) (cadddr x) ) )
    )
)

(defun |intMinus| (&rest EXPS)
    ;(print (apply (intern (concatenate 'string start (caar exps))) (cdar exps)))
    ;(print "minus")
    (setf funcName (intern (concatenate 'string start (caar exps))))
    (if (null (cadr exps))
        (apply (intern (concatenate 'string start (caar exps))) (cdar exps))
        ( cons "Minus" ( cons (apply (intern (concatenate 'string start (caar exps))) (cdar exps)) (cons (apply #'|intMinus| (cdr exps))nil)) ) )
)

 


(defun |intExp| (&rest exps)
    ;(print "intexp")
    ;(print exps)
    (if (equal "Vari" (caar exps))
        (if (=  (cadr (cdadar exps)) 1)
            (if (and (equal 'e (cadr exps)) (= (car(cdadar exps)) 1) )
                (list "Exp" (car exps) (cadr exps))
                (if  (equal 'e (cadr exps))
                    (list "Times" (list "Const" (list  (/ 1 (car (cdadar exps)))) ) (list "Exp" (car exps) (cadr exps)) )
                    (list "Times" (list "Const" (list "Times" (list "Log" (cadr exps)) (/ 1 (car (cdadar exps)))) ) (list "Exp" (car exps) (cadr exps) ) )
                )
             )
        )
        ()
    )
)

(defun |intLog| (&rest EXPS)
    ;(if (equal "Vari" (caar exps))
        (integ (list "Times" (list "Const" '(1)) (list "Log" (car exps)) ))
     ;   ()
    ;)
)


  (defun |intPower| (&rest exps)          ; sec^2 and cosec^2
   
    ;(print (caadar exps))
    ;(print (car (cadadr exps)))
    
(cond 
  (  
    (equal "Sec" (caar exps))
    
    (if(equal "Vari" (caadar exps))
   
     (if (= (caddar (cdadar exps)) 1 ) 
     (if (equal "Const" (caadr exps))
      (if ( eq (car (cadadr exps)) 2  )   
        (list "Times" (list "Const" (list (/ 1 (cadar (cdadar exps))))) (list "Tan" (cadar exps)) )

       )
     )
    )
     )
  )
   
    
     ; 1/ root(1 - x^2)
   
 (    
        (equal "MINUS" (caar exps))

             ( if (equal "Const" (caadr exps))
             
              (if (= (car (cadadr exps)) -0.5)   
              ( if ( equal (caadar exps) "Const")
              ( if (equal (car (caddar exps)) "Vari" )
               ( if (eq (cadadr (caddar exps )) 1 )
                     ( if (eq ( car (cddadr (caddar exps))) 2 )
                   (list "ASin" (list "Vari" (list (caadr (caddar exps)) (/ 1 (sqrt (caar (cdadar exps) ) ) ) 1 ( cadr (cddadr (caddar exps)))     ) ) )
                
                    ) 
                
                    ( if (eq (cadadr (caddar exps )) -1 )
                        ( if (eq ( car (cddadr (caddar exps))) 2 )
                        (list "ACos" (list "Vari" (list (caadr (caddar exps)) (/ 1 (sqrt ( abs (caar (cdadar exps) ) )) ) 1 ( cadr (cddadr (caddar exps)))     ) ) )
                

                        )
                    )     
               )
; 1/ root(-1 + x^2) = (-1 - (-x2))   
                ) 
                )               
              )
              )           
)               
 
 
 


     ; 1/ (1 + x^2)
   
(
        (equal "Plus" (caar exps))
             
             ( if (equal "Const" (caadr exps))
               
              (if (eq (car (cadadr exps)) -1)   
              ( if ( equal (caadar exps) "Const")
                
              ( if (equal (car (caddar exps)) "Vari" )
                
               ( if (eq (cadadr (caddar exps )) 1 )
                 
                    ( if (eq ( car (cddadr (caddar exps))) 2 )
                     ; (list "hi") 
                      (list "ATan" (list "Vari" (list (caadr (caddar exps)) (/ 1 (sqrt (caar (cdadar exps) ) ) )
                                                 1 ( cadr (cddadr (caddar exps)))     ) )  )
                      )
                ; -1/ (1 + x^2)
                    ( if (eq (cadadr (caddar exps )) -1 )
                        ( if (eq ( car (cddadr (caddar exps))) 2 )
                            (list "ACot" (list "Vari" (list (caadr (caddar exps)) (/ 1 (abs (sqrt (caar (cdadar exps) )) ) ) 1 ( cadr (cddadr (caddar exps)))     ) ) )
                
                        ) 
                    )
               )
               )
               )   
              )
              
              )
)            
         
(   
        (equal "Cosec" (caar exps))
        
        (if(equal "Vari" (caadar exps))
   
     (if (= (caddar (cdadar exps)) 1 ) 
     (if (equal "Const" (caadr exps))
      (if ( eq (car (cadadr exps)) 2  )   
        (list "Times" (list "Const" (list (/ -1 (cadar (cdadar exps))))) (list "Cot" (cadar exps)) )

       )
     )
    )
     )
)
   

)
   )



(defun |intCos| (&rest exps)            ;;integrate Cos

    (if (equal "Vari" (caar exps))
        (if (=  (cadr (cdadar exps)) 1)
            (list "Times" (list "Const" (list (/ 1 (car (cdadar exps))))) (list "Sin" (car exps)) )
        )
        ()
    )
)

(defun |intSin| (&rest exps)            ;;integrate Sin

    (if (equal "Vari" (caar exps))
        (if (=  (cadr (cdadar exps)) 1)
                  (list "Times" (list "Const" (list (/ -1 (car (cdadar exps))))) (list "Cos" (car exps)) )  )
        ()
    )
)

(defun |intTan| (&rest exps)            ;;integrate Tan

    (if (equal "Vari" (caar exps))
        (if (=  (cadr (cdadar exps)) 1)
                  (list "Times" (list "Const" (list (/ 1 (car (cdadar exps))))) (list "Log" ( list  "Sec" (car exps) )  ) )  )
        ()
    )
)

(defun |intCot| (&rest exps)            ;;integrate Cot

    (if (equal "Vari" (caar exps))
        (if (=  (cadr (cdadar exps)) 1)
                  (list "Times" (list "Const" (list (/ 1 (car (cdadar exps))))) (list "Log" ( list  "Sin" (car exps) )  ) )  )
        ()
    )
)

(defun |intSec| (&rest exps)            ;;integrate Sec

    (if (equal "Vari" (caar exps))
        (if (=  (cadr (cdadar exps)) 1)
                  (list "Times" (list "Const" (list (/ 1 (car (cdadar exps))))) (list "Log" (list "Plus" ( list  "Sec" (car exps) )  ( list "Tan" (car exps )       )        ) ) )  )
        ()
    )
)

(defun |intCosec| (&rest exps)            ;;integrate Cosec

    (if (equal "Vari" (caar exps))
        (if (=  (cadr (cdadar exps)) 1)
                  (list "Times" (list "Const" (list (/ 1 (car (cdadar exps))))) (list "Log" (list "Minus" ( list  "Cosec" (car exps) )  ( list "Cot" (car exps )       )        ) ) )  )
        ()
    )
)


(defun |intASin| (&rest exps)       ;;integrate sin-1
(if (equal "Vari" (caar exps))
 (if (eq 1 (caddr (cadar exps)) )
    (list "Plus" (list "Times" (list "Vari" (list  (caadar exps) 1 1 (cadddr (cadar exps))    ))  (list "ASin" exps ) ) 
     
     (list "Div" (list "Power" (list "Minus" (list "Const" (list 1) )  (list "Vari" (list (caadar exps) (car (cdadar exps)) 2 (caddr (cdadar exps ))               )   ) )   (list "Const" (list 0.5)   ) )               (cadr (cadar exps)) ) 
     
     )
 )
  )
)

(defun |intACos| (&rest exps)       ;;integrate Cos-1
(if (equal "Vari" (caar exps))
 (if (eq 1 (caddr (cadar exps)) )
    (list "Minus" (list "Times" (list "Vari" (list  (caadar exps) 1 1 (cadddr (cadar exps))    ))  (list "ACos" exps ) ) 
     
     (list "Div" (list "Power" (list "Minus" (list "Const" (list 1) )  (list "Vari" (list (caadar exps) (car (cdadar exps)) 2 (caddr (cdadar exps ))               )   ) )   (list "Const" (list 0.5)   ) )               (cadr (cadar exps)) ) 
     
     )
 )
  )
)






(defun isTrig (func)
    (if (or (equal func "Sin") (equal func "Cos") (equal func "Tan") (equal func "Cosec") (equal func "Sec") (equal func "Cot") 
            (hasItem func "Sin") (hasItem func "Cos") (hasItem func "Tan") (hasItem func "Cosec") (hasItem func "Sec") (hasItem func "Cot")
        )
        t
        nil
    )
)

(defun isTrigInv (func)
    (if (or (equal func "ASin") (equal func "ACos") (equal func "ATan") (equal func "ACosec") (equal func "ASec") (equal func "ACot") 
            (hasItem func "ASin") (hasItem func "ACos") (hasItem func "ATan") (hasItem func "ACosec") (hasItem func "ASec") (hasItem func "ACot") 
        )
        t
        nil
    )
)

(defun |intTimes| (&rest EXPS)
    ;(print exps)
    (setf funcName1int (intern (concatenate 'string "int" (caar exps))))
    (setf funcName1diff (intern (concatenate 'string "diff" (caar exps))))
    (setf funcName2int (intern (concatenate 'string "int" (caadr exps))))
    (setf funcName2diff (intern (concatenate 'string "diff" (caadr exps))))
    
    ;(print 1)
    ;(print exps)
    ;(print  (intern (concatenate 'string "mul" (car (apply funcName2int (cdadr exps))))) )
    ;(print 7)
    ;(print exps )
    ;(print 7)
    ;(print  (list funcName2int (cdadr exps) ) )
    ;(print 7)
    ;(print (list (intern (concatenate 'string "diff" (caadr exps))) (cdadr exps)) )
    
    ;(print  (caadr exps))
    
    
    (handler-case
        (if (equal (cadr exps) (differ (car exps)) )
            (list "Times" (list "Const" '(1/2)) (list "Power" (list (car exps)) (list "Const" (list 2) ) ) )
            (if (equal (car exps) (differ (cadr exps)) )
                (list "Times" (list "Const" '(1/2)) (list "Power" (list (cadr exps)) (list "Const" (list 2) ) ))
                (intTimes1 exps)
            ) 
        )
        (error (e)
            (handler-case
                (if (equal (car exps) (differ (cadr exps)) )
                    (list "Times" (list "Const" '(1/2)) (list "Power" (list (cadr exps)) (list "Const" (list 2) ) ))
                    (intTimes1 exps)
                )
                (error (e1) (intTimes1 exps))
            )
        )
    )
   
    
        ;(if (or (isTrig(caadr exps)) (equal "Exp" (caadr exps )) (equal "Log" (caadr exps )) )
            
            
         ;       (if (equal (car exps) (differ (cadr exps)) )
              
          ;          (list "Times" (list "Const" '(1/2)) (list "Power" (list (cadr exps)) (list "Const" (list 2) ) ))    
                
                
           ;         (if (or (isTrig(caar exps)) (equal "Exp" (caar exps )) (equal "Log" (caar exps )) )
                        
            ;            (if (equal (cadr exps) (differ (car exps)) )
             ;               (list "Times" (list "Const" '(1/2)) (list "Power" (list (car exps)) (list "Const" (list 2) ) ) )
              ;              (intTimes1 exps)
               ;         )
                ;        (intTimes1 exps)
                 ;   )
                    
                ;)
                
                ;(if (or (isTrig(caar exps)) (equal "Exp" (caar exps )) (equal "Log" (caar exps )) )
                        
                 ;   (if (equal (cadr exps) (differ (car exps)) )
                  ;      (list "Times" (list "Const" '(1/2)) (list "Power" (list (car exps)) (list "Const" (list 2) ) ) )
                   ;     (intTimes1 exps)
                    ;)
                    ;(intTimes1 exps)
                ;)
       ; )
                
)

(defun intTimes1 (exps)

    (if (or (equal (caar exps) "Log") (hasItem (car exps) "Log") )
                (apply #'|intTimes| (reverse exps) )
                
                (if (isTrigInv(caar exps))
                    (apply #'|intTimes| (reverse exps) )
                    
                    (if (or (equal (caadr exps) "Exp") (hasItem (cadr exps) "Exp") )
                        (apply #'|intTimes| (reverse exps) )
                    
                        (if (isTrig (caadr exps))
                            (apply #'|intTimes| (reverse exps) )
                            
                            
                                    (cond 
                                    
                                    
                                        ; f(x) * f'(x)
                                       ; (
                                        ;    ( or (equal (car exps) (differ (cadr exps)) )  (equal (differ (car exps))  (cadr exps)   ) )
                                         ;   (list "hii" (car exps))
                                          
                                        ;)
                                        (
                                            (and (equal "Vari" (caar exps)) (equal "Vari" (caadr exps)) )
                                            (integ (mulVaris (car exps) (cadr exps) ))
                                        )
                                        (
                                            (or (and (not (equal "Const" (caar exps))) (not (equal "Const" (caadr exps)))  )   (equal "Log" (caadr exps))  )
                                            (list "Minus" ( list "Times" (cadr exps) (apply (intern (concatenate 'string "int" (caar exps))) (cdar exps)) )
                                                        ( integ (list "Times"  (apply (intern (concatenate 'string "int" (caar exps))) (cdar exps))   (apply (intern (concatenate 'string "diff" (caadr exps))) (cdadr exps))   ) )
                                            )
                                        )
                                        (
                                            (or   (equal "Const" (caar exps))  (equal "Const" (caadr exps))  )
                                            (if (isTrig (caar exps))
                                                    (list "Times"  (cadr exps) (integ (car exps)) )
                                                
                                                    (cond
                                                        (
                                                            (not (equal "Const" (caar exps)))
                                                            (if (or (equal (caar exps) "Const") (equal (caar exps) "Vari")  (equal (caar exps) "Exp") )
                                                                (funcall (intern (concatenate 'string "mul" (car (apply (intern (concatenate 'string "int" (caar exps))) (cdar exps))))) (cadr exps) (apply (intern (concatenate 'string "int" (caar exps))) (cdar exps)))
                                                                (list "Times"  (cadr exps) (integ (car exps)) )
                                                            )
                                                        )
                                                        (   (not (equal "Const" (caadr exps)))
                                                            (if (or (equal (caadr exps) "Const") (equal (caadr exps) "Vari")  (equal (caadr exps) "Exp") )
                                                                (funcall (intern (concatenate 'string "mul" (car (apply (intern (concatenate 'string "int" (caadr exps))) (cdadr exps))))) (car exps) (apply (intern (concatenate 'string "int" (caadr exps))) (cdadr exps)))
                                                               (list "Times"  (car exps) (integ (cadr exps)) )
                                                            )
                                                        )
                                                        (
                                                            t
                                                            ( integ (list "Const" (list (* (caadar exps) (car (cadadr exps))))) )
                                                        )
                                                    )
                                        
                                            )
                                        )
                                        (
                                            t
                                            ( integ (list "Const" (list (* (caadar exps) (car (cadadr exps))))) )
                                        )
                                    )
                
                        )
                    )
                )
            )

)
