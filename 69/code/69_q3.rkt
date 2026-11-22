#lang racket/base

;; inorder-acc : tree list -> list
;; Returns the in-order list of tree values followed by acc, visiting
;; the right subtree first and consing values onto acc.
(define (inorder-acc tree acc)
  (if (null? tree)
      acc
      (inorder-acc (cadr tree)
                   (cons (car tree)
                         (inorder-acc (caddr tree) acc)))))

;; print-inorder : tree -> void
;; Prints the in-order list of tree values on one line followed by a newline.
(define (print-inorder tree)
  (display (inorder-acc tree '()))
  (newline))
