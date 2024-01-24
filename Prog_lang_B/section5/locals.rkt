#lang racket

(define (max-of-list xs)
  (cond [(empty? xs) (error "You cannot get the maximum from a an empty list")]
        [(empty? (rest xs)) (first xs)]
        [else
         (let ([max (max-of-list (rest xs))])
           (if (> max (first xs)) max (first xs)))]))