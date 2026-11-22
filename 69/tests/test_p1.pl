:- use_module(library(plunit)).
:- [ '../code/69_q1.pl' ].

:- begin_tests(p1).

test(main_output_format_and_order) :-
    with_output_to(string(Out), main),
    split_string(Out, "\n", "\r", [L1, L2, L3, L4, ""]),
    L1 == "Alex = [design, java, embedded]",
    L2 == "Ben = [development, javascript, web]",
    L3 == "Carla = [testing, python, AI]",
    L4 == "Dana = [research, c++, data]".

test(count_solutions_empty_active) :-
    count_solutions([], 13824).

test(count_solutions_clues_1_to_8) :-
    count_solutions([1, 2, 3, 4, 5, 6, 7, 8], 3).

test(count_solutions_clues_1_to_9) :-
    count_solutions([1, 2, 3, 4, 5, 6, 7, 8, 9], 1).

test(count_solutions_single_clue) :-
    count_solutions([1], 7776).

test(clue_9_holds_in_exactly_one_solution_of_clues_1_to_8) :-
    findall(S, solution([1, 2, 3, 4, 5, 6, 7, 8], S), Sols),
    findall(S, (member(S, Sols), clue(9, S)), Matching),
    length(Matching, 1).

test(clue_1_violating_solution_fails) :-
    V1 = [p('Alex', design, java, embedded),
          p('Ben', development, javascript, web),
          p('Carla', testing, python, data),
          p('Dana', research, 'c++', 'AI')],
    \+ clue(1, V1).

test(clue_2_violating_solution_fails) :-
    V2 = [p('Alex', development, java, embedded),
          p('Ben', design, javascript, web),
          p('Carla', testing, python, 'AI'),
          p('Dana', research, 'c++', data)],
    \+ clue(2, V2).

test(clue_3_violating_solution_fails) :-
    V3 = [p('Alex', design, java, embedded),
          p('Ben', development, javascript, web),
          p('Carla', testing, 'c++', 'AI'),
          p('Dana', research, python, data)],
    \+ clue(3, V3).

test(clue_4_violating_solution_fails) :-
    V4 = [p('Alex', design, java, web),
          p('Ben', development, javascript, embedded),
          p('Carla', testing, python, 'AI'),
          p('Dana', research, 'c++', data)],
    \+ clue(4, V4).

test(clue_5_violating_solution_fails) :-
    V5 = [p('Alex', development, java, embedded),
          p('Ben', design, javascript, web),
          p('Carla', testing, python, 'AI'),
          p('Dana', research, 'c++', data)],
    \+ clue(5, V5).

test(clue_6_violating_solution_fails) :-
    V6 = [p('Alex', design, java, 'AI'),
          p('Ben', development, javascript, web),
          p('Carla', testing, python, embedded),
          p('Dana', research, 'c++', data)],
    \+ clue(6, V6).

test(clue_7_violating_solution_fails) :-
    V7 = [p('Alex', design, java, embedded),
          p('Ben', research, javascript, web),
          p('Carla', testing, python, 'AI'),
          p('Dana', development, 'c++', data)],
    \+ clue(7, V7).

test(clue_8_violating_solution_fails) :-
    V8 = [p('Alex', design, java, embedded),
          p('Ben', development, 'c++', web),
          p('Carla', testing, python, 'AI'),
          p('Dana', research, javascript, data)],
    \+ clue(8, V8).

:- end_tests(p1).
