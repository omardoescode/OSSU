#lang racket
(struct const (int) #;transparent)
(struct negate (e) #;transparent)
(struct add (e1 e2) #;transparent)
(struct multiply (e1 e2) #;transparent)

(define (eval-exp e)
  (cond [(const? e) e] ; returning an exp, not a number
        [(negate? e) (const (- (const-int (eval-exp (negate-e e)))))] ; recursion => extracting => calculations => Convert to Exp
        [(add? e) (const (+ (const-int (eval-exp (add-e1 e))) (const-int (eval-exp (add-e2 e)))))]
        [(multiply? e) (const (* (const-int (eval-exp (multiply-e1 e))) (const-int (eval-exp (multiply-e2 e)))))]))