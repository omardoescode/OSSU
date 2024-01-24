#lang racket

(provide (all-defined-out))

(define s "hello") ; this is another comment

(define x 3); val x = 3

(define y (+ x 2)); + is a function we call

(define cube1
  (lambda (x)
    (* x x x))) ; x * (x * x)

(define (cube2 x) (* x x x))

(define (pow1 x y) ; only if y >= 0
  (if (= y 0)
      1
      (* x (pow1 x(- y 1)))))

; An example of curring
(define pow2
  (lambda (x)
    (lambda (y)
      (pow1 x y))))
(define (pow3 x)
  (lambda (y) (pow1 x y)))

(define three-to-the (pow2 3))