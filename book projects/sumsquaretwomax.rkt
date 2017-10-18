#lang scheme
;; SICP 1.3 first scheme program!

;; max
(define (square x)
  (* x x))
(define (max x y)
  (cond ((< x y) y)
        ((> x y) x)
        (else x)))

;; max3
(define (max3 x y z)
  (max (max x y)
       (max y z)))

;; second highest of 3
(define (max3snd x y z)
  (cond
    ((=(max3 x y z) x) (max y z))
    ((= (max3 x y z) y) (max x z))
    ((= (max3 x y z) z) (max x y))))

;; sum of squares of larger 2 of 3 numbers
(define (sumsquaretwomax x y z)
  (+ (square (max3 x y z))
     (square (max3snd x y z))))
