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

;; preorder-acc : tree list -> list
;; Returns the pre-order list of tree values (node, left, right) followed by acc,
;; built by consing onto acc without append or reverse.
(define (preorder-acc tree acc)
  (if (null? tree)
      acc
      (cons (car tree)
            (preorder-acc (cadr tree)
                          (preorder-acc (caddr tree) acc)))))

;; postorder-acc : tree list -> list
;; Returns the post-order list of tree values (left, right, node) followed by acc,
;; built by consing onto acc without append or reverse.
(define (postorder-acc tree acc)
  (if (null? tree)
      acc
      (postorder-acc (cadr tree)
                     (postorder-acc (caddr tree)
                                    (cons (car tree) acc)))))

;; print-all-traversals : tree -> void
;; Prints three lines containing the in-order, pre-order, and post-order
;; traversals of tree, each ending with a newline.
(define (print-all-traversals tree)
  (display (inorder-acc tree '()))
  (newline)
  (display (preorder-acc tree '()))
  (newline)
  (display (postorder-acc tree '()))
  (newline))

;; tree-height : tree -> integer
;; Returns 0 for an empty tree '(), and 1 plus the maximum height of its
;; subtrees for a non-empty node.
(define (tree-height tree)
  (if (null? tree)
      0
      (+ 1 (max (tree-height (cadr tree))
                (tree-height (caddr tree))))))

;; count-leaves : tree -> integer
;; Returns the number of leaf nodes in tree; the empty tree has 0 leaves,
;; a leaf has both subtrees empty, and an internal node sums its subtrees' leaves.
(define (count-leaves tree)
  (cond
    [(null? tree) 0]
    [(and (null? (cadr tree)) (null? (caddr tree))) 1]
    [else (+ (count-leaves (cadr tree))
             (count-leaves (caddr tree)))]))

;; print-height-and-leaves : tree -> void
;; Prints the two-element list (height leaf-count) on one line followed by a newline.
(define (print-height-and-leaves tree)
  (display (list (tree-height tree) (count-leaves tree)))
  (newline))
