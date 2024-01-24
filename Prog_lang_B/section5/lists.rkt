#lang racket

; (listof number) -> number
; sum all the numbers in a list
(define (sum xs)
  (if (empty? xs) 0 (+ 1 (first xs) (sum (rest xs)))))

; append
(define (my-append xs ys)
  (if (empty? xs)
      ys
      (cons (first xs) (my-append (rest xs) ys))))

; map
(define (my-map f xs)
  (if (empty? xs)
       empty
       (cons (f (first xs)) (my-map f (rest xs)))))

; filter
(define (my-filter f xs)
  (if (empty? xs)
      empty
      (if (f (first xs))
          (cons (first xs) (my-filter f (rest xs)))
          (my-filter f (rest xs)))))

; every
(define (every f xs)
  (if (empty? xs)
      true
      (and (f (first xs)) (every f (rest xs)))))

; some
(define (some f xs)
  (if (empty? xs)
      false
      (or (f (first xs)) (some f (rest xs)))))

; reduce
(define (my-reduce f xs acc)
  (if (empty? xs)
      acc
      (my-reduce f (rest xs) (f acc (first xs)))))