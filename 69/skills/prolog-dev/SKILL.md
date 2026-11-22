
name: prolog-dev description: Guides SWI-Prolog 9.x development for CS F301 Assignment 2 (Group 69: 69_q1.pl and 69_q2.pl). Use when writing, testing, or reviewing Prolog predicates, tests, or reports for P1 and P2.
Prolog Development Skill (Group 69 — CS F301 Assignment 2)
1. Environment & Files
Runtime: SWI-Prolog 9.x (swipl --version to verify).
Solution files:
69/code/69_q1.pl (P1: Department Assignment Puzzle, Reloaded)
69/code/69_q2.pl (P2: Form a Valid Arithmetic Equation)
Test files: 69/tests/test_p1.pl, 69/tests/test_p2.pl.
Allowed libraries only: lists, apply, yall, aggregate.
Strictly forbidden: assert/1, asserta/1, assertz/1, retract/1, retractall/1, global variables (b_setval/2, nb_setval/2), halt/0 inside solution files, and any :- initialization(...) directive.
2. Decomposition Rule
Work strictly one unit per prompt: one predicate (or tightly related group of clauses like a subset of clue/2), one test file, or one review pass.
Never generate the complete solution to a whole problem in a single response.
3. Coding Conventions
Naming: Use snake_case for all predicates and helper names; use CamelCase or descriptive capitalized names for logic variables (Solution, Active, Expr, Val).
Atoms & Types:
P1 names must be quoted atoms 'Alex', 'Ben', 'Carla', 'Dana'.
P1 attribute atoms must match exactly: research, development, design, testing; python, java, 'c++', javascript; 'AI', web, embedded, data.
P1 solution structure: [p('Alex', D1, L1, P1), p('Ben', D2, L2, P2), p('Carla', D3, L3, P3), p('Dana', D4, L4, P4)].
P2 equations must be SWI-Prolog strings (e.g., "4*2=5+3"), never atoms or character-code lists, with no spaces.
Declarative reading comments: Every predicate must have a concise comment above it stating its mode and declarative reading (e.g., % clue(+N, +Solution) is semidet. True when clue N holds in fully instantiated Solution.).
P1.c Clue 9 comment: Place the English sentence directly on the line above clue(9, Solution) starting with % CLUE 9: and do not mention any friend by name.
4. How to Run and Test
Use the exact grader invocation patterns from the repository root:
# P1: run main/0 (must print exactly 4 lines, nothing else)
swipl -q -f 69/code/69_q1.pl -g main -t halt

# P1: test count_solutions/2
swipl -q -f 69/code/69_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8], N), writeln(N)" -t halt
swipl -q -f 69/code/69_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8,9], N), writeln(N)" -t halt

# P2: test generate_equation/2, all_equations/2, count_equations/2
swipl -q -f 69/code/69_q2.pl -g "generate_equation([4,2,5,3], E), writeq(E), nl" -t halt
swipl -q -f 69/code/69_q2.pl -g "all_equations([4,2,5,3], Es), writeq(Es), nl" -t halt
swipl -q -f 69/code/69_q2.pl -g "all_equations([2,3,4], Es), writeq(Es), nl" -t halt

# Run dedicated test files
swipl -q -f 69/tests/test_p1.pl -g run_tests -t halt
swipl -q -f 69/tests/test_p2.pl -g run_tests -t halt
5. Self-Review Checklist (Apply Before Answering)
Does the response cover only the single requested unit of work?
Are there zero uses of assert, retract, b_setval, nb_setval, halt/0, or :- initialization?
Are only allowed libraries (lists, apply, yall, aggregate) imported?
Does every predicate include a clear declarative reading comment?
Are there zero stray write/writeln/format calls outside P1's main/0?
For P2: is every expression evaluated as an AST/term (never building a string and parsing it back), with exact integer division (D =\= 0, 0 =:= A mod D, V is A div D) checked at every division node?
For P2: does generate_equation/2 cleanly fail (no loop, no exception) on [], [5], and unsolvable lists like [2,3,4]?
6. Known AI Failure Modes in Prolog
Adding :- initialization(main). or halt/0: Breaks the grader when it invokes predicates with -g "<goal>" -t halt.
Returning atoms or char lists in P2: Using atom_concat/3 instead of string_concat/3 or format(string(S), ...) produces atoms instead of SWI-Prolog strings.
Wrong division semantics in P2: Using / (floating-point division) or // without checking 0 =:= A mod B allows inexact divisions like 5/2 = 2. Always check B =\= 0, 0 =:= A mod B, V is A // B.
Wrong canonical parenthesization in P2: Forgetting that right operands with equal precedence still need parentheses (1+(2+3) vs 1+2+3, 1-(2-3) vs 1-2-3, 8/(4*2) vs 8/4*2), whereas left operands only need parentheses when strictly lower precedence.
Hard-coding or over-constraining P1: count_solutions(Active, N) must evaluate only the clues listed in Active and ignore all others; baking clue constraints into the generator breaks count_solutions/2 for subsets.
Forgetting quotes on 'Alex', 'c++', 'AI': Unquoted Alex and AI are Prolog variables, not atoms!
