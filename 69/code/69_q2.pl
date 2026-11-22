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

