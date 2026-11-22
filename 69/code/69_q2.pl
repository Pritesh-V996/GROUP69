% apply_op(Op, A, B, V): V is the integer result of A Op B.
% Division succeeds only when B is non-zero and A is exactly divisible by B.
apply_op(+, A, B, V) :- V is A + B.
apply_op(-, A, B, V) :- V is A - B.
apply_op(*, A, B, V) :- V is A * B.
apply_op(/, A, B, V) :- B =\= 0, A mod B =:= 0, V is A // B.

% split_nonempty(List, Left, Right): List is Left followed by Right, both non-empty.
split_nonempty(List, Left, Right) :-
    append(Left, Right, List),
    Left = [_|_],
    Right = [_|_].

% expr(List, Expr, Val): Expr is a binary expression tree over the numbers of List
% in order, and Val is its integer value; every division inside it is exact.
expr([N], num(N), N).
expr(List, bin(Op, L, R), Val) :-
    split_nonempty(List, Left, Right),
    expr(Left, L, LVal),
    expr(Right, R, RVal),
    member(Op, [+, -, *, /]),
    apply_op(Op, LVal, RVal, Val).

% expr_string(Expr, Str): Str is the canonical string of Expr, with no spaces.
% A left operand gets parentheses only if its operator binds strictly weaker
% than its parent; a right operand gets them if it binds the same or weaker.
expr_string(num(N), Str) :-
    format(string(Str), "~w", [N]).
expr_string(bin(Op, L, R), Str) :-
    expr_string(L, LS),
    expr_string(R, RS),
    (   memberchk(Op, [*, /]), L = bin(LOp, _, _), memberchk(LOp, [+, -])
    ->  format(string(LP), "(~w)", [LS])
    ;   LP = LS
    ),
    (   R = bin(ROp, _, _),
        (   memberchk(Op, [*, /])
        ;   memberchk(ROp, [+, -])
        )
    ->  format(string(RP), "(~w)", [RS])
    ;   RP = RS
    ),
    format(string(Str), "~w~w~w", [LP, Op, RP]).


% matching_pairs(LeftPairs, RightPairs, Pairs): merge join of two keysorted
% Val-Expr lists; Pairs holds every LExpr-RExpr whose values are equal.
matching_pairs([], _, []).
matching_pairs([_|_], [], []).
matching_pairs([LV-LE|LT], [RV-RE|RT], Pairs) :-
    (   LV < RV
    ->  matching_pairs(LT, [RV-RE|RT], Pairs)
    ;   LV > RV
    ->  matching_pairs([LV-LE|LT], RT, Pairs)
    ;   matching_pairs([LV-LE], RT, P1),
        matching_pairs(LT, [RV-RE], P2),
        matching_pairs(LT, RT, P3),
        append([[LE-RE], P1, P2], Front),
        append(Front, P3, Pairs)
    ).


% equation_string(List, Str): Str is "L=R" where L is an expression over a
% prefix of List, R is an expression over the rest, and both have the same value.
equation_string(List, Str) :-
    split_nonempty(List, Left, Right),
    findall(V-E, expr(Left, E, V), LP0),
    findall(V-E, expr(Right, E, V), RP0),
    keysort(LP0, LP),
    keysort(RP0, RP),
    matching_pairs(LP, RP, Pairs),
    member(LE-RE, Pairs),
    expr_string(LE, LS),
    expr_string(RE, RS),
    format(string(Str), "~w=~w", [LS, RS]).

% generate_equation(List, Equation): Equation is one valid equation string for List;
% fails if there is none.
generate_equation(List, Equation) :-
    once(equation_string(List, Equation)).

% all_equations(List, Equations): Equations is the sorted list, without
% duplicates, of every valid equation string for List; [] if there is none.
all_equations(List, Equations) :-
    findall(S, equation_string(List, S), All),
    sort(All, Equations).

