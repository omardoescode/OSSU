#lang racket

(define-syntax my-if
  (syntax-rules (then else)
    [(my-if e1 then e2 else e3)
     (if e1 e2 e3)]))

(define-syntax comment-out
  (syntax-rules ()
    [(comment-out ignore instead) instead]))

(define-syntax my-delay
  (syntax-rules ()
    [(my-delay e)
     (mcons #f (lambda () e))]))

(define (my-force p)
  (if (mcar p)
      (mcdr p)
      (begin
        (set-mcar! p #t)
        (set-mcdr! p ((mcdr p)))
        (mcdr p))))


;; More Macro Examples
(define-syntax for
  (syntax-rules(to do)
    [(for lo to hi do body)
     (let ([l lo]
           [h hi])
       (letrec ([loop (lambda (it)
                        (if (> it h)
                            #t
                            (begin body (loop (+ it 1)))))])
         (loop 1)))]))

(define-syntax let2
  (syntax-rules ()
    [(let2 () body)
     body]
    [(let2 (var val) body)
     (let ([var val]) body)]
    [(let2 (var1 val1 var2 val2) body)
     (let ([var1 val1])
       (let ([var2 val2])
         body))]))

(define-syntax my-let*
  (syntax-rules ()
    [(my-let* () body)
     body]
    [(my-let* ([var0 val0]
               [var-rest val-rest] ...)
              body)
     (let ([var 0 val0])
       (my-let* ([var-rest val-rest] ...)
                body))]))
              


    