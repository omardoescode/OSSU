;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname main) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)


(define i1 (rectangle 10 20 "solid" "red"))
(define i2 (rectangle 20 10 "solid" "blue"))

(if (< (image-width i1) (image-height i1)) "tall" "wide" )