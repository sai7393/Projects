
(setf startd "diff")

(defun differ (exp)
    ;(print exp)
    ;(print 3)
    (setf funcName (intern (concatenate 'string startd  (car exp))))
    (apply funcName  (cdr exp))
)

(defun |diffConst| (&rest EXPS)
    (list "Const" '(0))
)

(defun |diffPlus| (&rest EXPS)
    (setf funcName (intern (concatenate 'string startd (caar exps))))
    (if (null (cadr exps))
        (apply (intern (concatenate 'string startd (caar exps))) (cdar exps))
        ( cons "Plus" ( cons (apply (intern (concatenate 'string startd (caar exps))) (cdar exps)) (cons (apply #'|diffPlus| (cdr exps))nil)) ) )
)

(defun |diffVari| (x)
    (if (= (caddr x) 1)
        (list "Const" (list (cadr x)) )
        (list "Vari" (list (car x) (* (cadr x) (caddr x) ) (- (caddr x) 1) (cadddr x) ) )
    )
)

(defun |diffMinus| (&rest EXPS)
    (setf funcName (intern (concatenate 'string startd (caar exps))))
    (if (null (cadr exps))
        (apply (intern (concatenate 'string startd (caar exps))) (cdar exps))
        ( cons "Minus" ( cons (apply (intern (concatenate 'string startd (caar exps))) (cdar exps)) (cons (apply #'|diffMinus| (cdr exps))nil)) ) )
)

(defun |diffExp| (&rest EXPS)
    ;(print exps)
    (if (equal "Vari" (caar exps))
        (if (=  (cadr (cdadar exps)) 1)
            (if (and (equal 'e (cadr exps)) (= (car(cdadar exps)) 1) )
                (list "Exp" (car exps) (cadr exps) )
                (if (eq (car (cdadar exps)) 1 )
                    (list "Times" (list "Const" (list (car (cdadar exps)))) (list "Exp" (car exps) (cadr exps)) )
                    (list "Times" (list "Const" (list "Times" (list "Log" (cadr exps)) (car (cdadar exps)))) (list "Exp" (car exps) (cadr exps)) )
                )
            )
            (list "Times" (differ (car exps)) (list "Exp" (car exps) (cadr exps)) )
        )
        (list "Times" (differ (car exps)) (list "Exp" (car exps) (cadr exps)) )
    )
)

(defun |diffLog| (&rest EXPS)
    
    
    (cond
    
        (
            (equal "Vari" (caar exps))
            (list "Vari" `(x ,(cadr(cdadar exps)) -1 C) )
        )
    
    
 
       
        (   (equal "Plus" (caar exps))              ; differentiate ln(secx + tanx)
        
             ( if (equal "Sec" (caadar exps)) 
           ; (list (car (caddar exps)))
                   (   if( equal "Tan" (car (caddar exps)))
                        
                       (if (equal "Vari" ( caar (cdadar exps))) 
                        ( if( eq ( cadr(cdadar (cdadar exps))) 1 )
                        

                  (if (equal "Vari" ( caadr (caddar exps))) 
                       ( if( eq ( caddr (cadadr (caddar exps))) 1 )
                        
                         ( if( eq ( cadr (cadadr (caddar exps)))  (car (cdadar (cdadar exps)) ))
                 (if (eq (car (cdadar (cdadar exps))) 1 )            
                ( list "Sec" (car (cdadar exps )))
                  (list "Times" (list "Const" (list (* 1 (car (cdadar (cdadar exps)))))) (list "Sec" (car (cdadar exps))) )
                )   
                )
                )
                 )
                 )
                )
                )
                
                (list "Div" (differ (car exps)) (car exps) )
                
             )
       )

       ( 
            (equal "Minus" (caar exps))              ; differentiate ln(cosecx - cotx)
        
            ( if (equal "Cosec" (caadar exps)) 
           ; (list (car (caddar exps)))
               (   if( equal "Cot" (car (caddar exps)))
                    
                   (if (equal "Vari" ( caar (cdadar exps))) 
                    ( if( eq ( cadr(cdadar (cdadar exps))) 1 )
                    

              (if (equal "Vari" ( caadr (caddar exps))) 
                   ( if( eq ( caddr (cadadr (caddar exps))) 1 )
                    
                     ( if( eq ( cadr (cadadr (caddar exps)))  (car (cdadar (cdadar exps)) ))
                  (if (eq (car (cdadar (cdadar exps))) 1 )            
                ( list "Cosec" (car (cdadar exps )))
                (list "Times" (list "Const" (list (* 1 (car (cdadar (cdadar exps)))))) (list "Cosec" (car (cdadar exps))) )
            )                
            )
            )
             )
             )
            )
            )
            
            
            (list "Div" (differ (car exps)) (car exps) )
            
              )
        )
    
        ( (equal "Sec" (caar exps))                               ;differentiate ln(secx)
           
           (if (equal "Vari" (caadar exps)) 
            ;(list (caddar (cdadar exps)))
            (if (eq (caddar (cdadar exps)) 1)
              (if (eq (car (cdar (cdadar exps))) 1 )            
                ( list "Tan" (car (cdadar exps )))
             (list "Times" (list "Const" (list (* 1 (car (cdar (cdadar exps)))))) (list "Tan" (car (cdadar exps))) )
                )
             )
            )

        )
   
       ( (equal "Sin" (caar exps))                               ;differentiate ln(sinx) = cotx
           
           (if (equal "Vari" (caadar exps)) 
            ;(list (caddar (cdadar exps)))
            (if (eq (caddar (cdadar exps)) 1)
              (if (eq (car (cdar (cdadar exps))) 1 )            
                ( list "Cot" (car (cdadar exps )))
             (list "Times" (list "Const" (list (* 1 (car (cdar (cdadar exps)))))) (list "Cot" (car (cdadar exps))) )
                )
             )
            )
        )
    
    
        (
            t
            (list "Div" (differ (car exps)) (car exps) )
        
        )
  
    )
)
(defun |diffCos| (&rest exps)            ;;differentiate Cos

    ;(if (equal "Vari" (caar exps))
        ;(if (=  (cadr (cdadar exps)) 1)
         ;(if (eq (car (cdadar exps)) -1) 
         ;   (list "Cos" (car exps)     )
        ;    (list "Times" (list "Const" (list (* -1 (car (cdadar exps))))) (list "Sin" (car exps)) )
       ;  )   
      ;      )
     ;   ()
    ;)
    (if (and (equal "Const" (car (differ (car exps)) ) ) (eq 1  (caadr (differ (car exps ))))               )
    (list "Times" (list "Const" (list -1 )) (list "Sin" (car exps )) )
    ;(print (car (differ (car exps)))) 
     (list "Times" (list "Const" (list -1)   )     ( list "Times" ( differ (car exps) ) (list "Cos" (car exps )   ) ) ) 
    )
    )




(defun |diffSin| (&rest exps)            ;;differentiate Sin

    ;(if (equal "Vari" (caar exps))
     ;   (if (=  (cadr (cdadar exps)) 1)
      ;      (if (eq (car (cdadar exps)) 1) 
       ;     (list "Cos" (car exps)     )
        ;    (list "Times" (list "Const" (list (* 1 (car (cdadar exps))))) (list "Cos" (car exps)) )
         ;   )
          ;  )
        ;()
    ;)
    (if (and (equal "Const" (car (differ (car exps)) ) ) (eq 1  (caadr (differ (car exps ))))               )
    (list "Cos" (car exps ))
    ;(print (car (differ (car exps)))) 
     (list "Times" ( differ (car exps) )(list "Cos" (car exps )   )  ) 
    )
)

(defun |diffSec| (&rest exps)            ;;differentiate sec

    (if (equal "Vari" (caar exps))
        (if (=  (cadr (cdadar exps)) 1)
         (if (eq (car (cdadar exps)) 1 )
          (list "Times" (list "Sec" (car exps)) ( list "Tan" (car exps) )        )  
          (list "Times" (list "Times" (list "Const" (list (* 1 (car (cdadar exps))))) (list "Sec" (car exps)) ) (list "Tan" (car exps)) )
        )
            )
        ()
    )
)

(defun |diffCosec| (&rest exps)            ;;differentiate Cosec

    (if (equal "Vari" (caar exps))
        (if (=  (cadr (cdadar exps)) 1)
         (if (eq (car (cdadar exps)) -1 )
          (list "Times" (list "Cosec" (car exps)) ( list "Cot" (car exps) )        )
            (list "Times" (list "Times" (list "Const" (list (* -1 (car (cdadar exps))))) (list "Cosec" (car exps))) (list "Cot" (car exps)) )
        )
            )
        ()
    )
)


(defun |diffTan| (&rest exps)           ;differentiate tan
     (if (equal "Vari" (caar exps))
        (if (=  (cadr (cdadar exps)) 1)
         (if (eq (car (cdadar exps )) 1 )
         (list "Power" (list "Sec" (car exps)) (list "Const" 2) )
          (list "Times" (list "Const" (list (* 1 (car (cdadar exps))))) (list "Power" (list "Sec" (car exps))  (list "Const" 2 )))
         
            )
            )
        ()
    )



)

(defun |diffCot| (&rest exps)           ;differentiate cot
     (if (equal "Vari" (caar exps))
        (if (=  (cadr (cdadar exps)) 1)
          (if (eq (car (cdadar exps )) -1 )
         (list "Power" (list "Cosec" (car exps)) (list "Const" 2) )

            (list "Times" (list "Const" (list (* -1 (car (cdadar exps))))) (list "Power" (list "Cosec" (car exps))  (list "Const" 2 )))
          )
            )
        ()
    )



)




(defun |diffTimes| (&rest EXPS)
    ;(print exps)
    ;(print 5)
    (setf funcName1diff (intern (concatenate 'string "diff" (caar exps))))
    (setf funcName2diff (intern (concatenate 'string "diff" (caadr exps))))
    
    (cond 
        (
            (and (not (equal "Const" (caar exps))) (not (equal "Const" (caadr exps))) )
            (list "Plus"
                (list "Times" (apply (intern (concatenate 'string "diff" (caar exps))) (cdar exps)) (cadr exps) )
                (list "Times" (car exps) (apply (intern (concatenate 'string "diff" (caadr exps))) (cdadr exps)) )
            )
        )
        (   
            (or  (equal "Const" (caar exps))  (equal "Const" (caadr exps)) )
                (if (or (isTrig(caar exps)) (isTrig(caadr exps)) )
                    (cond
                
                            (
                                (not (equal "Const" (caadr exps)))
                                (list "Times" (car exps) (differ (cadr exps)) )
                            )
                            (   (not (equal "Const" (caar exps)))
                                (list "Times" (cadr exps) (differ (car exps)) )
                            )
                    )
                    
                    (cond
                
                            (
                                (not (equal "Const" (caar exps)))
                                (if (or (equal (caar exps) "Const") (equal (caar exps) "Vari") (equal (caar exps) "Exp") )
                                    (funcall (intern (concatenate 'string "mul" (car (apply (intern (concatenate 'string "diff" (caar exps))) (cdar exps))))) (cadr exps) (apply (intern (concatenate 'string "diff" (caar exps))) (cdar exps)))
                                    (list "Times"  (cadr exps) (differ (car exps)) )
                                )
                            )
                            (   (not (equal "Const" (caadr exps)))
                                (if (or (equal (caadr exps) "Const") (equal (caadr exps) "Vari") (equal (caadr exps) "Exp") )
                                    (funcall (intern (concatenate 'string "mul" (car (apply (intern (concatenate 'string "diff" (caadr exps))) (cdadr exps))))) (car exps) (apply (intern (concatenate 'string "diff" (caadr exps))) (cdadr exps)))
                                    (list "Times"  (car exps) (differ (cadr exps)) )
                                )
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
