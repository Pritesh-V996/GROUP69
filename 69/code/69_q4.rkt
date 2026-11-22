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

; (my-map f lst) is tail-recursive.
; Applies procedure f to each element of lst in order and returns the resulting list.
(define (my-map f lst)
  (letrec ([map-acc
            (lambda (rem acc)
              (if (null? rem)
                  (my-reverse acc)
                  (map-acc (cdr rem) (cons (f (car rem)) acc))))])
    (map-acc lst '())))

; (insert-if-short x lst n)
; At every level of nesting, inserts x at the front of every list whose original length is strictly less than n.
(define (insert-if-short x lst n)
  (if (null? lst)
      (if (< 0 n)
          (cons x '())
          '())
      (let ([k (my-length lst)]
            [mapped (my-map (lambda (elem)
                              (if (or (null? elem) (pair? elem))
                                  (insert-if-short x elem n)
                                  elem))
                            lst)])
        (if (< k n)
            (cons x mapped)
            mapped))))
