#lang racket

(define (sum xs)
  (cond [(empty? xs) 0]
        [(number? (first xs)) (+ (first xs) (sum (rest xs)))]
        [else (+ (sum (first xs)) (sum (rest xs)))]))

; This version skips all non-number and lists in xs
(define (sum2 xs)
  (cond [(empty? xs) 0]
        [(number? (first xs)) (+ (first xs) (sum2 (rest xs)))]
        [(list? (first xs)) (+ (sum2 (first xs)) (sum2 (rest xs)))]
        [else (sum2 (rest xs))]))

; This version checks if xs is a list in the first place
(define (sum3 xs)
  (cond [(not (list? xs)) 0]
        [(empty? xs) 0]
        [(number? (first xs)) (+ (first xs) (sum3 (rest xs)))]
        [(list? (first xs)) (+ (sum3 (first xs)) (sum3 (rest xs)))]
        [else (sum3 (rest xs))]))

