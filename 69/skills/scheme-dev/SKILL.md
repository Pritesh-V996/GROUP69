---
name: scheme-dev
description: Guides Scheme/Racket 8.x (#lang racket/base) development for CS F301 Assignment 2 (Group 69: 69_q3.rkt and 69_q4.rkt). Use when writing, testing, or reviewing Scheme functions, tests, or documentation for S1 and S2.
---

# Scheme / Racket Development Skill (Group 69 — CS F301 Assignment 2)

## 1. Language and Version
- **Runtime:** Racket 8.x (`racket --version` to verify).
- **Language Pragma:** Every solution file must begin with `#lang racket/base` on line 1.
- **Target Files:**
  - `69/code/69_q3.rkt` (S1: Binary Tree Traversals and Metrics)
  - `69/code/69_q4.rkt` (S2: Nested List Modification with Higher-Order Inserter)
  - `69/tests/test_s1.rkt`, `69/tests/test_s2.rkt`

## 2. Conventions
- **Naming:** Use standard `kebab-case` for all function names, predicate helpers, and parameter names.
- **Documentation:** Place a concise comment directly above every function giving its declarative or recursive reading and purpose.
- **Decomposition:** Work strictly one unit per prompt. Never generate an entire solution file in one go.
- **Hand-written Helpers:** All helper procedures (e.g., `my-reverse`, `my-length`, `my-map`, accumulators) must be explicitly implemented by hand. Never assume or import library utilities.
- **No Top-Level Calls:** Solution files must contain only definitions (`define`). Do not include any top-level test calls or executable expressions at the root of the file.

## 3. How to Run and Test
- **Grader Loading Mechanism:**
  - The grader tests solution files by appending evaluation calls directly to the end of the file (or a temporary copy) and executing:
    ```bash
    racket 69/code/69_q4.rkt
    ```
  - Therefore, solution files **must not** contain `provide` or `require`.
  - Loading any solution file in isolation must produce **zero stdout and zero stderr**:
    ```bash
    racket 69/code/69_q3.rkt
    racket 69/code/69_q4.rkt
    ```
- **Test Harness Architecture:**
  - Test suites (`test_s1.rkt`, `test_s2.rkt`) do not `require` the solution file directly.
  - Instead, tests create a temporary file combining the solution source code with appended test expressions, run them via `dynamic-require` or subprocess, capture standard output, and compare against exact expected values.
  - For I/O functions like `print-insert-result`, standard input is supplied via string input ports.

## 4. Self-Review Checklist (Mandatory Gate)
Before producing or approving any Scheme code, verify every item below:

1. **Allowed Built-ins Only (Verbatim List):**
   - Syntax & Control: `define`, `lambda`, `let`, `let*`, `letrec`, `named let`, `if`, `cond` (with `else`), `and`, `or`, `not`, `begin`, `quote` (`'`).
   - Pairs & Lists: `cons`, `car`, `cdr`, `list`, compositions of `car`/`cdr` up to four levels deep (`caar`, `cadr`, `cdar`, `cddr`, `caaar`, `cadddr`, etc.), `null?`, `pair?`, `eq?`, `assq`, `assoc`.
   - Arithmetic & Comparison: `+`, `-`, `*`, `<`, `>`, `<=`, `>=`, `=`, `max`.
   - Output: `display`, `newline`.
   - Input (Special): `read` is strictly permitted **only** in S2's `print-insert-result` (prompt C7). It is forbidden everywhere else.
2. **Forbidden Built-ins & Forms:**
   - **No mutation:** `set!`, `set-car!`, `set-cdr!`.
   - **No complex data structures:** vectors (`vector`, `make-vector`, etc.), hash tables (`hash`, `make-hash`, etc.), strings (`string`, `string-append`, etc.), loops (`for`, `do`, etc.).
   - **No modules / exports:** `provide`, `require`.
   - **No standard library list/utility functions:** `length`, `append`, `reverse`, `map`, `filter`, `foldl`, `foldr`, `member`, `memq`, `memv`, `list-ref`, `list-tail`, `when`, `unless`, `case`, `let-values`, `define-values`, `values`, `apply`, `equal?`, `eqv?`, `list?`, `zero?`, `add1`, `sub1`, `abs`, `min`, `quotient`, `remainder`, `modulo`, `number?`, `symbol?`, `integer?`, `void`, `displayln`, `printf`, `write`, `print`.
3. **List vs. Atom Test:**
   - Always distinguish lists from atoms using:
     ```scheme
     (or (null? x) (pair? x))
     ```
   - Remember: `'()` is an empty list with length 0, **not** an atom!
4. **Void Return for Printer Functions:**
   - Every printer function (e.g., `print-inorder`, `print-all-traversals`, `print-height-and-leaves`, `print-insert-result`) must terminate with `(newline)` as its final expression so it returns `(void)`.
   - Returning any non-void value causes Racket's REPL/top-level runner to echo the return value, corrupting the grader output.
5. **Tail-Recursion:**
   - All traversals and list transformations over unbounded lists (e.g., 10,000 elements) must use tail-recursive helper procedures with accumulators to prevent call stack overflow.

## 5. Known AI Failure Modes in Scheme
- **Defaulting to Standard Racket Helpers:** Using `reverse`, `length`, `append`, `map`, or `filter` instead of hand-written `my-reverse`, `my-length`, `my-map`, or accumulators.
- **Accidental Convenience Functions:** Sneaking in `displayln` instead of `display` + `newline`, `zero?` instead of `(= n 0)`, `add1` instead of `(+ n 1)`, or `equal?` instead of `eq?` / `=`.
- **Misclassifying `()`:** Treating the empty list `'()` as an atom rather than a list with length 0.
- **Adding `provide` or `require`:** Inserting `(provide (all-defined-out))` breaks compliance with grader rules.
- **Duplicate Definitions:** Defining `insert-if-short` in C4 and keeping an old version when refactoring in C6. The file must have exactly one definition.
- **Load-time Output:** Placing test calls like `(print-insert-result)` at the top level of the file, causing stdout on load.
