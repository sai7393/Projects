
	
(defun |mulVari| (const1 exps)
;(print "mulvari")
    (list "Vari" (list (caadr exps) (* (cadadr exps) (caadr const1)) (car(cddadr exps)) (cadr(cddadr exps)) ) )
)

(defun |mulExp| (const1 exps)
    ;(print "mulexp")
    (list "Times" (list "Const" (list (* (car(cadadr exps)) (caadr const1) ))) (caddr exps))
)

(defun mulVaris (v1 v2)
    ;(print "mulvari")
    (if (and (numberp (cadr(cddadr v1))) (numberp (cadr(cddadr v1))) )
        (if (and (= (cadr(cddadr v1)) 0) (= (cadr(cddadr v1)) 0))
            (if (= (+ (car(cddadr v1)) (car(cddadr v2))) 0) 
                (list "Const" (list (* (cadadr v1) (cadadr v2))))
                (list "Vari" (list (caadr v1) (* (cadadr v1) (cadadr v2)) (+ (car(cddadr v1)) (car(cddadr v2))) 0 ) )
            )
            (list "Times" v1 v2)
        )
        (if (= (+ (car(cddadr v1)) (car(cddadr v2))) 0) 
                (list "Const" (list (* (cadadr v1) (cadadr v2))))
                (list "Vari" (list (caadr v1) (* (cadadr v1) (cadadr v2)) (+ (car(cddadr v1)) (car(cddadr v2))) 0 ) )
        )
    )
)

(defun |mulConst| (const1 const2)
    ;(print (caadr const1))
    ;(print (caadr const2))
    (if (and (numberp (caadr const1)) (numberp (caadr const2)) )
        (list "Const" `(,(* (caadr const1) (caadr const2))) )
        (list "Times" const1 const2)
    )
)

(defun |mulTimes| (const1 timExp)
    ;(print "multimes")
    ;(print timExp)
    ;(print const1)
    (list "Times" (funcall (intern (concatenate 'string "mul" (caadr timExp))) const1 (cadr timExp)) (caddr timExp) )
)


(defun hasItem (lst item)
    (if (null lst)
        nil
        (if (equal lst item)
            t
            (if (listp lst)
                (or (hasItem (car lst) item) (hasItem (cdr lst) item))
                nil
            )
        )
    )
)

