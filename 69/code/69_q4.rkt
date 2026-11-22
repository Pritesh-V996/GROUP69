#lang racket/base

; (my-reverse lst) is tail-recursive.
; Reverses a list by prepending elements one by one onto an accumulator.
(define (my-reverse lst)
  (letrec ([rev-acc
            (lambda (rem acc)
              (if (null? rem)
                  acc
                  (rev-acc (cdr rem) (cons (car rem) acc))))])
    (rev-acc lst '())))

; (my-length lst) is tail-recursive.
; Computes the number of elements in lst using an accumulator.
(define (my-length lst)
  (letrec ([len-acc
            (lambda (rem acc)
              (if (null? rem)
                  acc
                  (len-acc (cdr rem) (+ acc 1))))])
    (len-acc lst 0)))
