#lang racket

(define (Const i) (list 'Const i))
(define (Negate e) (list 'Negate e))
(define (Add e1 e2) (list 'Add e1 e2))
(define (Multiply e1 e2) (list 'Multiply e1 e2))

(define (Const? x) (eq? (car x) 'Const))
(define (Negate? x) (eq? (car x) 'Negate))
(define (Add? x) (eq? (car x) 'Add))
(define (Multiply? x) (eq? (car x) 'Multiply))

; Extracting the pieces
(define (Const-int e) (car (cdr e))) ; Extract the integer, equivalent to get-int in sml
(define (Negate-e e) (car (cdr e)))
(define (Add-e1 e) (car (cdr e)))
(define (Add-e2 e) (car (cdr (cdr e))))
(define (Multiply-e1 e) (car (cdr e)))
(define (Multiply-e2 e) (car (cdr (cdr e))))

(define (eval-exp e)
  (cond [(Const? e) e] ; returning an exp, not a number
        [(Negate? e) (Const (- (Const-int (eval-exp (Negate-e e)))))] ; recursion => extracting => calculations => Convert to Exp
        [(Add? e) (Const (+ (Const-int (eval-exp (Add-e1 e))) (Const-int (eval-exp (Add-e2 e)))))]
        [(Multiply? e) (Const (* (Const-int (eval-exp (Multiply-e1 e))) (Const-int (eval-exp (Multiply-e2 e)))))]))