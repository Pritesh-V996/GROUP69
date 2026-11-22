# CS F301: Principles of Programming Languages — Assignment 2
## Group 69

### Team Members
- **Member A (`2024A7PS0010H` / Atharv)**: Problem P1, Problem S1, Prolog skill
- **Member B (`2024A7PS0067H` / Avtrit)**: Problem S2, Scheme skill, P2 Review
- **Member C (`2024A7PS0165H` / Pritesh)**: Problem P2, Repository scaffold

---

### Repository Layout

```text
GROUP69/
├── 69/
│   ├── code/
│   │   ├── 69_q1.pl       # Problem P1: Department Assignment Puzzle
│   │   ├── 69_q2.pl       # Problem P2: Arithmetic Equation Generator
│   │   ├── 69_q3.rkt      # Problem S1: Binary Tree Traversals & Metrics
│   │   └── 69_q4.rkt      # Problem S2: Nested List Modification
│   ├── tests/
│   │   ├── test_p1.pl     # PLUnit tests for P1
│   │   ├── test_p2.pl     # PLUnit tests for P2
│   │   ├── test_s1.rkt    # Test suite for S1 (grader-style execution)
│   │   └── test_s2.rkt    # Test suite for S2 (grader-style execution)
│   ├── skills/
│   │   ├── prolog-dev/SKILL.md  # SWI-Prolog 9.x AI skill specification
│   │   └── scheme-dev/SKILL.md  # Racket 8.x AI skill specification
│   ├── prompts/
│   │   ├── P1.md          # Word-for-word prompt log for P1
│   │   ├── P2.md          # Word-for-word prompt log for P2 + review
│   │   ├── S1.md          # Word-for-word prompt log for S1
│   │   └── S2.md          # Word-for-word prompt log for S2
│   └── P1_REPORT.md       # Solution count analysis & Clue 9 documentation
└── README.md
```

---

### What is in this Project

#### P1: Department Assignment Puzzle (`69/code/69_q1.pl`)
- Assigns 4 friends (Alex, Ben, Carla, Dana) to unique departments, languages, and projects using permutation logic.
- Implements `clue/2` for clues 1 through 8.
- Implements `candidate/1` generating 13,824 permutations.
- Implements `count_solutions/2` (demonstrating $N = 3$ for clues 1–8).
- Implements `clue(9, Solution)` without mentioning any friend by name, narrowing the solutions down to $N = 1$.
- Implements `main/0` printing the unique assignments formatted with unquoted atoms.
- Report in `69/P1_REPORT.md` explaining the search space and Clue 9.

#### P2: Valid Arithmetic Equations (`69/code/69_q2.pl`)
- Takes a list of non-negative integers and inserts operators (`+`, `-`, `*`, `/`) and `=` so both sides evaluate to the same value.
- Exact integer division enforced at every node (`//` with `mod =:= 0`).
- Generates ASTs with `num/1` and `bin/3` terms, evaluated directly (no string parsing).
- Canonical parenthesization implemented in `expr_string/2` (left-associative, strict precedence).
- Keysorted merge-join implemented in `matching_pairs/3` for fast $O(L+R)$ pairing.
- Implements `generate_equation/2`, `all_equations/2`, and `count_equations/2`.

#### S1: Binary Tree Traversals & Metrics (`69/code/69_q3.rkt`)
- `#lang racket/base` with zero forbidden built-ins.
- Implements `print-inorder` using accumulator `inorder-acc`.
- Implements `print-all-traversals` (inorder, preorder, postorder) using tail accumulators.
- Implements `print-height-and-leaves` computing height (using `max`) and leaf counts.
- Ends with `(newline)` so functions return `(void)`.

#### S2: Nested List Modification (`69/code/69_q4.rkt`)
- `#lang racket/base` using only allowed built-ins.
- Hand-written tail-recursive `my-reverse`, `my-length`, and `my-map` using accumulators.
- Higher-order function `make-inserter` returning a procedure that inserts `x` into any sublist whose original length satisfies `len-ok?`.
- Single definition of `insert-if-short` defined through `make-inserter`.
- Parameterless `print-insert-result` reading `x`, `lst`, `n` from stdin via `read` and printing with `display`.

---

### How to Run and Test

#### 1. Running Problem Solutions

- **Run P1 solution (`main/0`):**
  ```bash
  swipl -q -f 69/code/69_q1.pl -g main -t halt
  ```

- **Query P1 solution counts:**
  ```bash
  swipl -q -f 69/code/69_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8], N), writeln(N)" -t halt
  swipl -q -f 69/code/69_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8,9], N), writeln(N)" -t halt
  ```

- **Run P2 equation generation:**
  ```bash
  swipl -q -f 69/code/69_q2.pl -g "generate_equation([4,2,5,3], E), writeq(E), nl" -t halt
  swipl -q -f 69/code/69_q2.pl -g "all_equations([4,2,5,3], Es), writeq(Es), nl" -t halt
  swipl -q -f 69/code/69_q2.pl -g "count_equations([4,2,5,3], N), writeln(N)" -t halt
  ```

- **Run S1 (Scheme Traversals):**
  The grader appends tree definitions and calls. Example:
  ```bash
  racket -e '(enter! (file "69/code/69_q3.rkt")) (define t1 (quote (4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ()))))) (print-inorder t1) (print-all-traversals t1) (print-height-and-leaves t1)'
  ```

- **Run S2 (Scheme Conditional Insert via stdin):**
  Feed `x`, `lst`, `n` through stdin:
  ```bash
  printf "42 ((1 2) (3 4 5) (6) ()) 3\n" | racket -e '(enter! (file "69/code/69_q4.rkt")) (print-insert-result)'
  ```

---

#### 2. Running the Test Suites

All 4 problems have complete standalone test suites:

- **Run P1 Tests (PLUnit):**
  ```bash
  swipl -q -f 69/tests/test_p1.pl -g run_tests -t halt
  ```

- **Run P2 Tests (PLUnit):**
  ```bash
  swipl -q -f 69/tests/test_p2.pl -g run_tests -t halt
  ```

- **Run S1 Tests (Racket):**
  ```bash
  racket 69/tests/test_s1.rkt
  ```

- **Run S2 Tests (Racket):**
  ```bash
  racket 69/tests/test_s2.rkt
  ```
