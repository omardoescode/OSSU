;; Programming Languages, Homework 5

#lang racket
(provide (all-defined-out)) ;; so we can put tests in a second file

;; definition of structures for MUPL programs - Do NOT change
(struct var  (string) #:transparent)  ;; a variable, e.g., (var "foo")
(struct int  (num)    #:transparent)  ;; a constant number, e.g., (int 17)
(struct add  (e1 e2)  #:transparent)  ;; add two expressions
(struct multiply  (e1 e2)  #:transparent)  ;; multiply two expressions
(struct ifgreater (e1 e2 e3 e4)    #:transparent) ;; if e1 > e2 then e3 else e4
(struct fun  (nameopt formal body) #:transparent) ;; a recursive(?) 1-argument function
(struct call (funexp actual)       #:transparent) ;; function call
(struct mlet (var e body) #:transparent) ;; a local binding (let var = e in body) 
(struct apair (e1 e2)     #:transparent) ;; make a new pair
(struct fst  (e)    #:transparent) ;; get first part of a pair
(struct snd  (e)    #:transparent) ;; get second part of a pair
(struct aunit ()    #:transparent) ;; unit value -- good for ending a list
(struct isaunit (e) #:transparent) ;; evaluate to 1 if e is unit else 0

;; a closure is not in "source" programs but /is/ a MUPL value; it is what functions evaluate to
(struct closure (env fun) #:transparent) 

;; Problem 1

;; CHANGE (put your solutions here)

(define (racketlist->mupllist es)
  (if (null? es)
      (aunit)
      (apair (car es) (racketlist->mupllist (cdr es)))))

(define (mupllist->racketlist es)
  (if (aunit? es)
      empty
      (cons (apair-e1 es) (mupllist->racketlist (apair-e2 es)))))
 

;; Problem 2

;; lookup a variable in an environment
;; Do NOT change this function
(define (envlookup env str)
  (cond [(null? env) (error "unbound variable during evaluation" str)]
        [(equal? (car (car env)) str) (cdr (car env))]
        [#t (envlookup (cdr env) str)]))

;; Do NOT change the two cases given to you.  
;; DO add more cases for other kinds of MUPL expressions.
;; We will test eval-under-env by calling it directly even though
;; "in real life" it would be a helper function of eval-exp.
(define (eval-under-env e env)
  (cond [(var? e) 
         (envlookup env (var-string e))]
        [(int? e) e]
        [(closure? e) e]
        [(aunit? e) e]
        [(add? e) 
         (let ([v1 (eval-under-env (add-e1 e) env)]
               [v2 (eval-under-env (add-e2 e) env)])
           (if (and (int? v1)
                    (int? v2))
               (int (+ (int-num v1) 
                       (int-num v2)))
               (error "MUPL addition applied to non-number")))]
        [(multiply? e) 
         (let ([v1 (eval-under-env (add-e1 e) env)]
               [v2 (eval-under-env (add-e2 e) env)])
           (if (and (int? v1)
                    (int? v2))
               (int * (int-num v1) 
                       (int-num v2))
               (error "MUPL multiplication applied to non-number")))]
        [(ifgreater? e)
         (let ([v1 (eval-under-env (ifgreater-e1 e) env)]
               [v2 (eval-under-env (ifgreater-e2 e) env)])
           (if (and (int? v1)
                   (int? v2))
               (if (> (int-num v1) (int-num v2))
                   (eval-under-env (ifgreater-e3 e) env)
                   (eval-under-env (ifgreater-e4 e) env))
               (error "Isgreater applied to non-number")))]
        [(mlet? e)
         (cond [(not (string? (mlet-var e))) (error "Invalid variable name")]
               [else
                (eval-under-env
                 (mlet-body e)
                 (cons
                  (cons
                   (mlet-var e)
                   (eval-under-env (mlet-e e) env)) env))])]
        [(fun? e)
         (let ([name (fun-nameopt e)]
               [arg (fun-formal e)]
               [body (fun-body e)])
           (if (and (or (string? name) (false? name))
                    (string? arg))
               (closure env e)
               (error "Invalid function expression")))]
        
        [(call? e)
         (let ([funclosure (eval-under-env (call-funexp e) env)])
           (cond [(not (closure? funclosure)) (error "You need to pass a function")]
                 [else
                  (let ([name (fun-nameopt (closure-fun funclosure))]
                        [formal (fun-formal (closure-fun funclosure))]
                        [body (fun-body (closure-fun funclosure))]
                        [local_env (closure-env funclosure)]
                        [actual (eval-under-env (call-actual e) env)])
                        (eval-under-env
                         body
                         (if name
                             (cons (cons name funclosure)
                                       (cons (cons formal actual) local_env))
                             (cons (cons formal actual) local_env))))]))]
        [(apair? e)
         (let ([v1 (eval-under-env (apair-e1 e) env)]
               [v2 (eval-under-env (apair-e2 e) env)])
           (apair v1 v2))]
        [(fst? e)
         (let ([val (eval-under-env (fst-e e) env)])
           (if (apair? val)
               (apair-e1 val)
               (error "The value given isn't a MUPL pair")))]
        [(snd? e)
         (let ([val (eval-under-env (snd-e e) env)])
           (if (apair? val)
               (apair-e2 val)
               (error "The value given isn't a MUPL pair")))]
        [(isaunit? e)
         (let ([val (eval-under-env (isaunit-e e) env)])
           (if (aunit? val)
           (int 1)
           (int 0)))]
        [#t (error (format "bad MUPL expression: ~v" e))]))

;; Do NOT change
(define (eval-exp e)
  (eval-under-env e null))
        
;; Problem 3

(define (ifaunit e1 e2 e3)
  (ifgreater (isaunit e1) (int 0) e2 e3))

(define (mlet* lstlst e2)
  (cond [(empty? lstlst) e2]
        [else
          (mlet
           (car (first lstlst))
           (cdr (first lstlst))
           (mlet*
            (rest lstlst)
            e2))]))

(define (ifeq e1 e2 e3 e4)
  (ifgreater e1 e2 e4 (ifgreater e2 e1 e4 e3)))

;; Problem 4

(define mupl-map
  (fun #f "aux"
       (fun "mapfunc" "lst"
            (ifaunit
             (var "lst")
             (aunit)
             (apair
              (call (var "aux") (fst (var "lst")))
              (call (var "mapfunc") (snd (var "lst"))))))))
            

(define mupl-mapAddN 
  (mlet "map" mupl-map
        (fun #f "i"
         (call (var "map")
               (fun #f "x" (add (var "i") (var "x")))))))

;; Challenge Problem

(struct fun-challenge (nameopt formal body freevars) #:transparent) ;; a recursive(?) 1-argument function

;; We will test this function directly, so it must do
;; as described in the assignment
(define (compute-free-vars e) "CHANGE")

;; Do NOT share code with eval-under-env because that will make
;; auto-grading and peer assessment more difficult, so
;; copy most of your interpreter here and make minor changes
(define (eval-under-env-c e env) "CHANGE")

;; Do NOT change this
(define (eval-exp-c e)
  (eval-under-env-c (compute-free-vars e) null))

