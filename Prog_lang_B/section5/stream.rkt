#lang racket

(define (number-until stream tester)
  (letrec ([f (lambda (stream ans)
                (let ([ pr (stream)])
                  (if (tester (car pr))
                      ans
                      (f (cdr pr) (+ ans 1)))))])
    (f stream 1)))