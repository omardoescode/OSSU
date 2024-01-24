#lang racket

(define (fib x)
  (if (or (= x 1) (= x 2))
      1
      (+ (fib (- x 1)) (fib (- x 2)))))

(define (fib2 x)
  (letrec ([f (lambda (acc1 acc2 y)
                (if (= y x)
                       (+ acc1 acc2)
                       (f (+ acc1 acc2) acc1 (+ y 1))))])
    (if (or (= x 1) (= x 2))
        1
        (f 1 1 3))))

(define fib3
  (letrec ([memo null]
           [f (lambda (x)
                (let ([ans (assoc x memo)])
                  (if ans
                      (cdr ans)
                      (let ([new-ans (if (or (= x 1) (= x 2))
                                         1
                                         (+ (f (- x 1))
                                            (f (- x 2))))])
                        (begin
                          (set! memo (cons (cons x new-ans) memo))
                          new-ans)))))])
    f))

(fib3 1)
(fib3 2)
(fib3 3)
(fib3 4)
(fib3 5)
(fib3 6)