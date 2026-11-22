#lang racket/base

(require racket/file
         racket/port
         racket/string
         racket/path)

(define this-dir
  (or (current-load-relative-directory)
      (let ([p (find-system-path 'run-file)])
        (if (path? p) (path-only p) (current-directory)))))

(define solution-path
  (simplify-path (build-path this-dir ".." "code" "69_q4.rkt")))

(define solution-text (file->string solution-path))

(define total-count 0)
(define pass-count 0)
(define fail-count 0)

(define (record-pass name)
  (set! total-count (+ total-count 1))
  (set! pass-count (+ pass-count 1))
  (display "PASS  ")
  (display name)
  (newline))

(define (record-fail name expected actual)
  (set! total-count (+ total-count 1))
  (set! fail-count (+ fail-count 1))
  (display "FAIL  ")
  (display name)
  (newline)
  (display "   expected: ")
  (display expected)
  (newline)
  (display "   actual:   ")
  (display actual)
  (newline))

(define (run-test-case name call-expr input-str expected-out)
  (let ([temp-file (make-temporary-file "test_s2_~a.rkt")])
    (dynamic-wind
     void
     (lambda ()
       (with-output-to-file temp-file
         (lambda ()
           (display solution-text)
           (newline)
           (when call-expr
             (display call-expr)
             (newline)))
         #:exists 'replace)
       (let ([actual-out
              (with-output-to-string
                (lambda ()
                  (if input-str
                      (let ([in-port (open-input-string input-str)])
                        (parameterize ([current-input-port in-port])
                          (dynamic-require temp-file #f)))
                      (dynamic-require temp-file #f))))])
         (if (string=? actual-out expected-out)
             (record-pass name)
             (record-fail name expected-out actual-out))))
     (lambda ()
       (when (file-exists? temp-file)
         (delete-file temp-file))))))

;; 1. Load silence
(run-test-case "loading 69_q4.rkt alone prints nothing"
               #f
               #f
               "")

;; 2. Exactly one definition of insert-if-short
(let ([matches (regexp-match* #rx"\\(define \\(insert-if-short" solution-text)])
  (if (= (length matches) 1)
      (record-pass "exactly one definition of insert-if-short in file")
      (record-fail "exactly one definition of insert-if-short in file" "1" (number->string (length matches)))))

;; 3. Example 1 via print-insert-result
(run-test-case "assignment example 1 via print-insert-result"
               "(print-insert-result)"
               "42 ((1 2) (3 4 5) (6) ()) 3\n"
               "((42 1 2) (3 4 5) (42 6) (42))\n")

;; 4. Example 2 via print-insert-result
(run-test-case "assignment example 2 via print-insert-result"
               "(print-insert-result)"
               "0 (((1) 2) (3) ((4 5 6) ())) 3\n"
               "((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))\n")

;; 5. Example 3 via print-insert-result
(run-test-case "assignment example 3 via print-insert-result"
               "(print-insert-result)"
               "7 () 3\n"
               "(7)\n")

;; 6. Example 4 via print-insert-result
(run-test-case "assignment example 4 via print-insert-result"
               "(print-insert-result)"
               "7 () 0\n"
               "()\n")

;; 7. make-inserter with even-length predicate
(run-test-case "make-inserter with even-length predicate"
               "(let ([ins (make-inserter 'x (lambda (k) (= (modulo k 2) 0)))]) (display (ins '((1 2) (3) (4 5 6 7) ()))) (newline))"
               #f
               "(x (x 1 2) (3) (x 4 5 6 7) (x))\n")

;; 8. insert-if-short with n = 0 on empty and nested empties
(run-test-case "insert-if-short with n = 0 on ()"
               "(begin (display (insert-if-short 9 '() 0)) (newline))"
               #f
               "()\n")

(run-test-case "insert-if-short with n = 0 on nested empties"
               "(begin (display (insert-if-short 9 '(() (()) ((()))) 0)) (newline))"
               #f
               "(() (()) ((())))\n")

;; 9. Nesting depth 100
(let* ([open-parens (make-string 100 #\()]
       [close-parens (make-string 100 #\))]
       [deep-input (string-append open-parens close-parens)]
       [expected-output (string-append (make-string 99 #\() "(9)" (make-string 99 #\)) "\n")]
       [test-code (string-append "(begin (display (insert-if-short 9 '" deep-input " 1)) (newline))")])
  (run-test-case "nesting depth 100"
                 test-code
                 #f
                 expected-output))

;; 10. Flat list of 10,000 elements
(let* ([ten-k-list (string-append "'(" (string-join (for/list ([i (in-range 10000)]) "1") " ") ")")]
       [test-code (string-append "(let ([res (insert-if-short 9 " ten-k-list " 10001)]) (display (length res)) (newline))")])
  (run-test-case "flat list of 10,000 elements tail-recursion"
                 test-code
                 #f
                 "10001\n"))

(newline)
(display "========================================\n")
(printf "Test Summary: ~a Passed, ~a Failed (Total: ~a)\n" pass-count fail-count total-count)
(display "========================================\n")
(when (> fail-count 0)
  (exit 1))
