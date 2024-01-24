#lang racket

(define (palindromic xs)
  (letrec ([rev-list (lambda (xs)
                (cond [(empty? xs) empty]
                      [else (append (rev-list (rest xs)) (cons (first xs) empty))]))]
           [sum (lambda (xs ys)
                  (cond [(empty? xs) empty]
                        [else (cons (+ (first xs) (first ys)) (sum (rest xs) (rest ys)))]))]
           [rev (rev-list xs)])
    (sum xs rev)))

