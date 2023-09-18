;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname pomodoro-problem) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

;; POMODORO

;; =================
;; Constants:
(define WIDTH 500)
(define HEIGHT 300)
(define MTS (empty-scene WIDTH HEIGHT))
(define POMODORO-MINUTES 25)
(define BREAK-MINUTES 5)
(define LONG-BREAK-MINUTES 30)
(define POMODORO-COLOR "red")
(define BREAK-COLOR "cyan")
(define LONG-BREAK-COLOR "yellow")
(define STATUS-FONT-SIZE 24)
(define TIMER-FONT-SIZE 70)


;; =================
;; Data definitions:

;; Status is one of:
;;   - pomodoro
;;   - break
;;   - long break
;; interp. the three phases in a pomodoro cycle

#;
(define (fn-for-status s)
  [cond [(string=? s "pomodoro") (...)]
        [(string=? s "break") (...)]
        [(string=? s "long break") (...)]])

;; Template rules used:
;;    one of: 3 cases
;;    atomic distinct: "pomodoro"
;;    atomic distinct: "break"
;;    atomic distinct: "long break"

(define-struct timer (minute second))
;; Timer is (make-timer Natural Natural)
;; interp. a countdown for the world

(define t1 (make-timer POMODORO-MINUTES 0))
(define t2 (make-timer 0 0))

#;
(define (fn-for-timer t)
  (... (timer-minute t) (timer-second t)))

;; Template rules used:
;;   compound: (make-timer Natural Natural)
;;   atomic non distinct: (timer-minute t) is Natural
;;   atomic non distinct: (timer-second t) is Natural

       

(define-struct pomodoro (status timer session stop?))
;; Pomodoro is (make-pomodoro Status Timer Integer[1, 4] Boolean)
;; interp. status is the current status of the running pomodoro
;;         timer represents the current countdown
;;         session is the number of sessions taken, if it reaches 4,
;;                 long break starts and after it, it drops to 1 once more
;;                 a session is a pomodoro+break
;;        stop? if true, the app doesn't count, it changes on clicking on spacebar

(define P1 (make-pomodoro "pomodoro" (make-timer POMODORO-MINUTES 0) 1 false)) ; start of the first pomodoro
(define P2 (make-pomodoro "break" (make-timer BREAK-MINUTES 0) 1 false)) ; the first break
(define P3 (make-pomodoro "pomodoro" (make-timer POMODORO-MINUTES 0) 2 false)) ; the second pomodoro start
(define P4 (make-pomodoro "long break" (make-timer LONG-BREAK-MINUTES 0) 4 false)) ; start of the long break

#;
(define (fn-for-pomodoro p)
  (... (fn-for-status (pomodoro-status p)) (fn-for-timer (pomodoro-timer p)) (pomodoro-session p) (pomodoro-stop? p)))

;; Template rules used:
;;   - compound: (make-pomodoro Status Integer Integer Integer)
;;   - reference: (pomodoro-status p) is Status
;;   - atomic non distinct: (pomodoro-minutes) is Integer
;;   - atomic non distinct: (pomodoro-seconds) is Integer
;;   - atomic non distinct: (pomodoro-session) is Integer


;; =================
;; Functions:

;; Pomodoro -> Pomodoro
;; start the world with (make-pomodoro 
;; 
(define (main p)
  (big-bang p                   ; Pomodoro
    (on-tick   update-pomodoro 1)     ; Pomodoro -> Pomodoro
    (to-draw   render-pomodoro)   ; Pomodoro -> Image
    (on-key    change-stop?)))    ; Pomodoro KeyEvent -> Pomodoro

;; Pomodoro -> Pomodoro
;; ticks the minutes and seconds if stop? is false, if they both reach zero, we change the status and start the next phase
;(define (update-pomodoro p) p)

(check-expect (update-pomodoro (make-pomodoro "pomodoro" (make-timer POMODORO-MINUTES 0) 1 false)) (make-pomodoro "pomodoro" (make-timer 24 59) 1 false))
(check-expect (update-pomodoro (make-pomodoro "pomodoro" (make-timer POMODORO-MINUTES 0) 1 true)) (make-pomodoro "pomodoro" (make-timer POMODORO-MINUTES 0) 1 true))
(check-expect (update-pomodoro (make-pomodoro "pomodoro" (make-timer 0 0) 1 false)) (make-pomodoro "break" (make-timer BREAK-MINUTES 0) 1 false))
(check-expect (update-pomodoro (make-pomodoro "break" (make-timer 0 0) 1 false)) (make-pomodoro "pomodoro" (make-timer POMODORO-MINUTES 0) 2 false))
(check-expect (update-pomodoro (make-pomodoro "pomodoro" (make-timer 0 0) 4 false)) (make-pomodoro "long break" (make-timer LONG-BREAK-MINUTES 0) 1 false))
(check-expect (update-pomodoro (make-pomodoro "long break" (make-timer 0 0) 1 false)) (make-pomodoro "pomodoro" (make-timer POMODORO-MINUTES 0) 1 false))


(define (update-pomodoro p)
  (cond [(pomodoro-stop? p) p] ;; Stop case
        [(timer-zero? (pomodoro-timer p)) (next-phase p)] ;; timer reaching zero
        [else (make-pomodoro (pomodoro-status p) (tick (pomodoro-timer p)) (pomodoro-session p) false)]))

;; Timer -> Boolean
;; returns true if minute and seconds equal 0
;; !!!
;(define (timer-zero? t) false)

(check-expect (timer-zero? (make-timer 0 0)) true)
(check-expect (timer-zero? (make-timer 1 0)) false)
(check-expect (timer-zero? (make-timer 0 1)) false)

(define (timer-zero? t)
  (and (zero? (timer-minute t)) (zero? (timer-second t))))

;; Pomodoro -> Pomodoro
;; Gets to the next phase in the pomodoro (explain more)
;; ASSUME: This funciton will be called only when timer-zero? is true

;(define (next-phase p) p)

(check-expect (next-phase (make-pomodoro "pomodoro" (make-timer 0 0) 1 false)) (make-pomodoro "break" (make-timer BREAK-MINUTES 0) 1 false))
(check-expect (next-phase (make-pomodoro "break" (make-timer 0 0) 1 false)) (make-pomodoro "pomodoro" (make-timer POMODORO-MINUTES 0) 2 false))
(check-expect (next-phase (make-pomodoro "pomodoro" (make-timer 0 0) 4 false)) (make-pomodoro "long break" (make-timer LONG-BREAK-MINUTES 0) 1 false))
(check-expect (next-phase (make-pomodoro "long break" (make-timer 0 0) 1 false)) (make-pomodoro "pomodoro" (make-timer POMODORO-MINUTES 0) 1 false))

(define (next-phase p)
  (make-pomodoro (update-status (pomodoro-status p) (pomodoro-session p)) (update-timer (pomodoro-status p) (pomodoro-session p)) (update-session (pomodoro-status p) (pomodoro-session p)) false))

;; Status Natural[1, 4] -> Status
;; returns pomodoro if status is break, break if status is pomodoro, long break if status is pomodoro and session is 4, pomodoro if status is long break

(check-expect (update-status "pomodoro" 1) "break")
(check-expect (update-status "break" 1) "pomodoro")
(check-expect (update-status "pomodoro" 4) "long break")
(check-expect (update-status "long break" 1) "pomodoro")

;(define (update-status status session) status) ; stub

; <template used from Status, with an additionl Interval parameter
(define (update-status status session)
  [cond [(and (string=? status "pomodoro") (= session 4)) "long break"]
        [(string=? status "pomodoro") "break"]
        [(string=? status "break") "pomodoro"]
        [(string=? status "long break") "pomodoro"]])



;; Status Session -> Timer
;; returns pomodoro timer if status break, break timer if status is pomodoro, long break if status is pomdoro and session is 4

(check-expect (update-timer "pomodoro" 1) (make-timer BREAK-MINUTES 0))
(check-expect (update-timer "pomodoro" 4) (make-timer LONG-BREAK-MINUTES 0))
(check-expect (update-timer "break" 1) (make-timer POMODORO-MINUTES 0))
(check-expect (update-timer "long break" 1) (make-timer POMODORO-MINUTES 0))

;(define (update-timer status session) t1) ; stub


; <template used from Status, with an additionl Interval parameter
(define (update-timer status session)
  [cond [(and (string=? status "pomodoro") (= session 4)) (make-timer LONG-BREAK-MINUTES 0)]
        [(string=? status "pomodoro") (make-timer BREAK-MINUTES 0)]
        [(string=? status "break") (make-timer POMODORO-MINUTES 0)]
        [(string=? status "long break") (make-timer POMODORO-MINUTES 0)]])

;; Status Session -> Natural[1, 4] -> Status
;; increases session by one if updated status is pomodoro, if updated status is long break make 1, if it's update pomodoro return the same

(check-expect (update-session "break" 1) 2)
(check-expect (update-session "pomodoro" 1) 1)
(check-expect (update-session "pomodoro" 4) 1)

;(define (update-session status session) 1) ; stub

; <template used from Status, with an additionl Interval parameter
(define (update-session status session)
  [cond [(and (string=? status "pomodoro") (= session 4)) 1]
        [(string=? status "pomodoro") session]
        [(string=? status "break") (+ session 1)]
        [(string=? status "long break") session]])

;; Timer -> Timer
;; ticks the timer 1 second per tick
;; ASSUME: this function won't be called in case the timer is already zero, so it won't go after 0:0

;(define (tick t) t) ; stub

(check-expect (tick (make-timer 24 59)) (make-timer 24 58))
(check-expect (tick (make-timer 25 0)) (make-timer 24 59))

(define (tick t)
  (cond [(zero? (timer-second t)) (make-timer (- (timer-minute t) 1) 59)]
        [else (make-timer (timer-minute t) (- (timer-second t) 1))]))

;; Pomodoro -> Image
;; shows a represention of the current countdown

(check-expect (render-pomodoro (make-pomodoro "pomodoro" (make-timer 25 0) 1 false))
              (place-image
               (above (text "Pomodoro: 1" STATUS-FONT-SIZE (get-color "pomodoro"))
                     (rectangle 40 1 "outline" "white")
                     (text "25:00" TIMER-FONT-SIZE  (get-color "pomodoro")))
               (/ WIDTH 2)
               (/ HEIGHT 2)
               MTS))

(define (render-pomodoro p)
  (place-image
   (above (text
          (string-append (capitalize (pomodoro-status p)) ": " (number->string (pomodoro-session p)))
          STATUS-FONT-SIZE
          (get-color (pomodoro-status p)))
         (rectangle 40 1 "outline" "white")
         (text (format-timer (pomodoro-timer p)) TIMER-FONT-SIZE  (get-color (pomodoro-status p))))
   (/ WIDTH 2)
   (/ HEIGHT 2)
   MTS))

;; String -> String
;; capitalizes the word

;(define (capitalize s) s)
(check-expect (capitalize "omar") "Omar")


(define (capitalize s)
  (string-append (string-upcase (substring s 0 1)) (substring s 1)))

;; Timer -> String
;; returns a text representaion of the form of M:SS

;(define (format-timer t) "")

(check-expect (format-timer (make-timer 25 0)) "25:00")
(check-expect (format-timer (make-timer 24 55)) "24:55")
(check-expect (format-timer (make-timer 0 0)) "0:00")

(define (format-timer t)
  (string-append (number->string (timer-minute t)) ":" (fixed (timer-second t))))


;; Number -> String
;; returns a text represention of the form SS, where we add 0 to the left if the nubmer is < 10

(define (fixed n)
  (if (< n 10)
      (string-append "0" (number->string n))
      (number->string n)))


;; Status -> Color
;; returns each status color according to constants

;(define (get-color s) "red")

(check-expect (get-color "pomodoro") POMODORO-COLOR)
(check-expect (get-color "break") BREAK-COLOR)
(check-expect (get-color "long break") LONG-BREAK-COLOR)

(define (get-color s)
  [cond [(string=? s "pomodoro") POMODORO-COLOR]
        [(string=? s "break") BREAK-COLOR]
        [(string=? s "long break") LONG-BREAK-COLOR]])

;; Pomodoro KeyEvent -> Pomodoro
;; Changeing stop? in pomodoro to the opposite value

(check-expect (change-stop? (make-pomodoro "pomodoro" (make-timer POMODORO-MINUTES 0) 1 true) " ") (make-pomodoro "pomodoro" (make-timer POMODORO-MINUTES 0) 1 false))
(check-expect (change-stop? (make-pomodoro "pomodoro" (make-timer POMODORO-MINUTES 0) 1 false) " ") (make-pomodoro "pomodoro" (make-timer POMODORO-MINUTES 0) 1 true))
(check-expect (change-stop? (make-pomodoro "pomodoro" (make-timer POMODORO-MINUTES 0) 1 true) "a") (make-pomodoro "pomodoro" (make-timer POMODORO-MINUTES 0) 1 true))


;(define (change-stop? p) true)
(define (change-stop? p ke)
  (cond [(key=? ke " ") (make-pomodoro (pomodoro-status p) (pomodoro-timer p) (pomodoro-session p) (not (pomodoro-stop? p)))]
        [else p]))

(main (make-pomodoro "pomodoro" (make-timer POMODORO-MINUTES 0) 1 false))