
#lang racket

(provide (all-defined-out)) ;; so we can put tests in a second file

;; put your code below

(define (sequence low high stride)
  (if (> low high)
      empty
      (cons low (sequence (+ low stride) high stride))))

(define (string-append-map xs suffix)
  (map (lambda (s) (string-append s suffix)) xs))

(define (stream-for-n-steps s n)
  (if (= n 0)
      empty
      (cons (car (s)) (stream-for-n-steps (cdr (s)) (- n 1)))))

(define (list-ith xs i)
  (if (= i 0)
      (first xs)
      (list-ith (rest xs) (- i 1))))

(define (list-nth-mod xs n)
  (cond [(< n 0) (error "list-nth-mod: negative number")]
        [(null? xs) (error "empty list")]
        [else
         (letrec
             ([i (remainder n (length xs))])
           (list-ith xs i))]))

(define funny-number-stream
  (letrec ([f (lambda (x) (cons (if (= (remainder x 5) 0) (* -1 x) x) (lambda () (f (+ x 1)))))])
    (lambda () (f 1))))
     
(define (test-stream s n)
  (if (= n 0)
      empty
      (cons (car (s)) (test-stream (cdr (s)) (- n 1)))))


(define dan-then-dog
  (letrec ([f (lambda () (cons "dan.jpg" (lambda () (cons "dog.jpg" f))))])
    (lambda () (f))))

(define (stream-add-zero s)
  (letrec ([f (lambda (s) (cons (cons 0 (car (s))) (lambda () (f (cdr (s))))))])
    (lambda () (f s))))


(define (my-helper n)
  (cons n (lambda () (+ n 1))))

(define (cycle-lists xs ys)
  (letrec ([f
            (lambda (n)
              (cons
               (cons (list-nth-mod xs n) (list-nth-mod ys n))
              (lambda () (f (+ n 1)))))])
    (lambda () (f 0))))


(define (vector-assoc v vec)
  (letrec ([aux (lambda (i)
               (cond [(= i (vector-length vec)) #f]
                     [(and (cons? (vector-ref vec i)) (= (car (vector-ref vec i) v)))
                      (letrec ([val (vector-ref vec i)])
                        (if (= (car val) v)
                            val
                            (aux v vec (+ i 1))))]
                     [else (aux v vec (+ i 1))]))])
    (aux 0)))


(define (cached-assoc xs n)
  (letrec ([memo (make-vector n #f)]
           [counter 0]
           [f (lambda (v)
                (letrec ([ans (vector-assoc v memo)])
                  (if ans
                      (cdr ans)
                      (letrec ([aux
                                (lambda (xs)
                                    (cond [(empty? xs) #f]
                                          [else
                                           (if
                                            (= v (car (first xs)))
                                            (first xs)
                                            (aux (rest xs)))]))]
                               [new_ans (aux xs)])
                        (begin
                          (vector-set! memo counter (cons v new_ans))
                          (set! counter (remainder (+ counter 1) n))
                          new_ans)))))])
                      
    f))

(define-syntax while-less
  (syntax-rules (do)
    ([while-less e1 do e2]
     (let ([e e1])
       (letrec [(loop
                 (lambda ()
                     (if (>= e2 e)
                         #t
                         (begin e2 (loop)))))]
         (loop))))))
       
