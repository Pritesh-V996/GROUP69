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