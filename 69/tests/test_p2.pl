:- use_module(library(plunit)).
:- use_module(library(time)).

% Load the solution relative to this test file's own directory.
:- prolog_load_context(directory, Dir),
   atom_concat(Dir, '/../code/69_q2.pl', File),
   load_files(File, []).

:- begin_tests(p2).

% The three examples from the assignment.
test(all_example_4253) :-
    all_equations([4,2,5,3], Es),
    Es == ["4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3",
           "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"].
test(all_example_234) :-
    all_equations([2,3,4], Es),
    Es == [].
test(all_example_248) :-
    all_equations([2,4,8], Es),
    Es == ["2*4=8"].

% generate_equation returns one of the seven, as a string.
test(gen_member_string) :-
    generate_equation([4,2,5,3], E),
    string(E),
    memberchk(E, ["4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3",
                  "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"]).

% generate_equation fails cleanly.
test(gen_fails_empty, [fail]) :- generate_equation([], _).
test(gen_fails_single, [fail]) :- generate_equation([5], _).
test(gen_fails_234, [fail]) :- generate_equation([2,3,4], _).

% Zeros: exactly 6 equations, none with division.
test(zeros_six) :-
    all_equations([0,0,0], Es),
    length(Es, 6).
test(zeros_no_division) :-
    all_equations([0,0,0], Es),
    \+ ( member(S, Es), sub_string(S, _, _, _, "/") ).

% Negative sub-expressions and parenthesisation.
test(negative_subexpression) :-
    all_equations([3,5,1,3], Es),
    memberchk("3-5=1-3", Es).
test(right_minus_parens) :-
    all_equations([2,1,2,3], Es),
    memberchk("2=1-(2-3)", Es).
test(division_trees_differ) :-
    all_equations([1,8,4,2], Es),
    memberchk("1=8/(4*2)", Es),
    memberchk("1=8/4/2", Es).

% count_equations.
test(count_4253) :-
    count_equations([4,2,5,3], 7).

% Speed: length 8 must finish within 30 seconds.
test(length_8_under_30s) :-
    call_with_time_limit(30, all_equations([1,2,3,4,5,6,7,8], Es)),
    is_list(Es).

:- end_tests(p2).

