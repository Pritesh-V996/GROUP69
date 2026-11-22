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

; (make-inserter x len-ok?)
; Returns a single-argument procedure taking a list and inserting x at the front
; of every list (at all nesting levels) whose original length satisfies len-ok?.
(define (make-inserter x len-ok?)
  (letrec ([inserter
            (lambda (lst)
              (if (null? lst)
                  (if (len-ok? 0)
                      (cons x '())
                      '())
                  (let ([k (my-length lst)]
                        [mapped (my-map (lambda (elem)
                                          (if (or (null? elem) (pair? elem))
                                              (inserter elem)
                                              elem))
                                        lst)])
                    (if (len-ok? k)
                        (cons x mapped)
                        mapped))))])
    inserter))

; (insert-if-short x lst n)
; Inserts x at the front of every list whose original length is strictly less than n.
(define (insert-if-short x lst n)
  ((make-inserter x (lambda (k) (< k n))) lst))

; (print-insert-result)
; Reads x, lst, and n in order from standard input, computes (insert-if-short x lst n),
; prints the resulting list with display, and ends with a newline.
(define (print-insert-result)
  (let* ([x (read)]
         [lst (read)]
         [n (read)]
         [res (insert-if-short x lst n)])
    (begin
      (display res)
      (newline))))
