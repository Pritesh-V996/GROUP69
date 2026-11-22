#lang racket

(require racket/runtime-path
         racket/file
         racket/port
         racket/string)

;; Resolve path to 69_q3.rkt relative to this test file
(define-runtime-path solution-path "../code/69_q3.rkt")

(unless (file-exists? solution-path)
  (error "Solution file not found at:" solution-path))

(define solution-text (file->string solution-path))

;; Runs a test snippet appended to the solution code in an isolated temporary module
(define (run-test-case snippet)
  (define tmp-file (make-temporary-file "test-s1-~a.rkt"))
  (call-with-output-file tmp-file
    (lambda (out)
      (display solution-text out)
      (newline out)
      (display snippet out)
      (newline out))
    #:exists 'replace)
  (define output
    (with-output-to-string
      (lambda ()
        (parameterize ([current-namespace (make-base-empty-namespace)])
          (dynamic-require tmp-file #f)))))
  (delete-file tmp-file)
  output)

(define pass-count 0)
(define fail-count 0)

(define (check-case name snippet expected-output)
  (define actual-output (run-test-case snippet))
  (if (string=? actual-output expected-output)
      (begin
        (set! pass-count (+ pass-count 1))
        (printf "PASS: ~a\n" name))
      (begin
        (set! fail-count (+ fail-count 1))
        (printf "FAIL: ~a\n  Expected: ~s\n  Actual:   ~s\n" name expected-output actual-output))))

;; Tree definitions for test cases
(define def-t1
  "(define t1 '(4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ()))))")

(define def-t2
  "(define t2 '(1 () (2 () (3 () ()))))")

(define def-t3
  "(define t3 '(a (b () ()) (c () ())))")

(define def-left-skewed-1000
  "(define (make-left-skewed n)
     (let loop ([i 1] [tree '()])
       (if (> i n)
           tree
           (loop (+ i 1) (list i tree '())))))
   (define t-skew (make-left-skewed 1000))")

;; 1. Loading 69_q3.rkt alone prints nothing
(check-case "load 69_q3.rkt alone prints nothing"
            ""
            "")

;; 2. Tree t1 tests
(check-case "t1 print-inorder"
            (string-append def-t1 "\n(print-inorder t1)")
            "(1 2 3 4 5 6 7)\n")

(check-case "t1 print-all-traversals"
            (string-append def-t1 "\n(print-all-traversals t1)")
            "(1 2 3 4 5 6 7)\n(4 2 1 3 6 5 7)\n(1 3 2 5 7 6 4)\n")

(check-case "t1 print-height-and-leaves"
            (string-append def-t1 "\n(print-height-and-leaves t1)")
            "(3 4)\n")

;; 3. Tree t2 tests
(check-case "t2 print-inorder"
            (string-append def-t2 "\n(print-inorder t2)")
            "(1 2 3)\n")

(check-case "t2 print-all-traversals"
            (string-append def-t2 "\n(print-all-traversals t2)")
            "(1 2 3)\n(1 2 3)\n(3 2 1)\n")

(check-case "t2 print-height-and-leaves"
            (string-append def-t2 "\n(print-height-and-leaves t2)")
            "(3 1)\n")

;; 4. Tree t3 tests
(check-case "t3 print-inorder"
            (string-append def-t3 "\n(print-inorder t3)")
            "(b a c)\n")

(check-case "t3 print-all-traversals"
            (string-append def-t3 "\n(print-all-traversals t3)")
            "(b a c)\n(a b c)\n(b c a)\n")

(check-case "t3 print-height-and-leaves"
            (string-append def-t3 "\n(print-height-and-leaves t3)")
            "(2 2)\n")

;; 5. Empty tree '() tests
(check-case "empty tree print-inorder"
            "(print-inorder '())"
            "()\n")

(check-case "empty tree print-all-traversals"
            "(print-all-traversals '())"
            "()\n()\n()\n")

(check-case "empty tree print-height-and-leaves"
            "(print-height-and-leaves '())"
            "(0 0)\n")

;; 6. Single-node tree (5 () ()) tests
(check-case "single node print-inorder"
            "(print-inorder '(5 () ()))"
            "(5)\n")

(check-case "single node print-all-traversals"
            "(print-all-traversals '(5 () ()))"
            "(5)\n(5)\n(5)\n")

(check-case "single node print-height-and-leaves"
            "(print-height-and-leaves '(5 () ()))"
            "(1 1)\n")

;; 7. Left-skewed tree with 1000 nodes tests
(check-case "left-skewed 1000 nodes print-height-and-leaves"
            (string-append def-left-skewed-1000 "\n(print-height-and-leaves t-skew)")
            "(1000 1)\n")

(define expected-skewed-inorder
  (format "(~a)\n" (string-join (map number->string (range 1 1001)) " ")))

(define expected-skewed-preorder
  (format "(~a)\n" (string-join (map number->string (reverse (range 1 1001))) " ")))

(check-case "left-skewed 1000 nodes print-inorder"
            (string-append def-left-skewed-1000 "\n(print-inorder t-skew)")
            expected-skewed-inorder)

(check-case "left-skewed 1000 nodes print-all-traversals"
            (string-append def-left-skewed-1000 "\n(print-all-traversals t-skew)")
            (string-append expected-skewed-inorder
                           expected-skewed-preorder
                           expected-skewed-inorder))

;; Print summary
(printf "\nTotal: ~a | Passed: ~a | Failures: ~a\n"
        (+ pass-count fail-count)
        pass-count
        fail-count)

(when (> fail-count 0)
  (exit 1))
