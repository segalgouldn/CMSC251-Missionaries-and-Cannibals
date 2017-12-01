% Noah Segal-Gould, ns2349@bard.edu, 1 December 2017

% Result:
% ?- test.
% Moved from 33 | 00 to 23 | 10
% Moved from 23 | 10 to 33 | 00
% Moved from 33 | 00 to 13 | 20
% Moved from 13 | 20 to 23 | 10
% Moved from 23 | 10 to 13 | 20
% Moved from 23 | 10 to 03 | 30
% Moved from 03 | 30 to 13 | 20
% Moved from 13 | 20 to 03 | 30
% Moved from 13 | 20 to 02 | 31
% Moved from 13 | 20 to 12 | 21
% Moved from 13 | 20 to 11 | 22
% Moved from 11 | 22 to 21 | 12
% Moved from 11 | 22 to 31 | 02
% Moved from 11 | 22 to 22 | 11
% Moved from 22 | 11 to 12 | 21
% Moved from 22 | 11 to 02 | 31
% Moved from 22 | 11 to 11 | 22
% Moved from 22 | 11 to 21 | 12
% Moved from 22 | 11 to 20 | 13
% Moved from 20 | 13 to 30 | 03
% Moved from 30 | 03 to 20 | 13
% Moved from 30 | 03 to 10 | 23
% Moved from 10 | 23 to 20 | 13
% Moved from 20 | 13 to 10 | 23
% Moved from 20 | 13 to 00 | 33
% Solution Path Is:
% state(3,3,w)
% state(1,3,e)
% state(2,3,w)
% state(0,3,e)
% state(1,3,w)
% state(1,1,e)
% state(2,2,w)
% state(2,0,e)
% state(3,0,w)
% state(1,0,e)
% state(2,0,w)
% state(0,0,e)
% true.

% Missionaries/Cannibals problem using Prolog
% to implement a production system.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stack helper facts and rules.

empty_stack([ ]) .
stack(Top,Stack,[Top | Stack]).

% is element in stack?
member_stack(Element, Stack) :-
	member(Element, Stack).
add_list_to_stack(List, Stack, Result) :-
	append(List, Stack, Result).

reverse_print_stack(S) :-
	empty_stack(S).
reverse_print_stack(S) :-
	stack(E, Rest, S),
	reverse_print_stack(Rest),
	write(E), nl.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% When called this will print out the current and new states.
show(M,C,M1,C1) :-
	OppM is (3 - M),
	OppC is (3 - C),
	OppNewM is (3 - M1),
	OppNewC is (3 - C1),
	write('Moved from '),write(M),write(C),write(' | '),write(OppM),write(OppC),
	write(' to '), write(M1),write(C1),write(' | '),write(OppNewM),write(OppNewC),nl.

% When no missionaries can be converted to cannibals.
safe(M1,C1) :-
	(M1 =< C1; C1 = 0),
	M2 is 3-M1, C2 is 3-C1,
	(M2 =< C2; C2 = 0).

move( state( M1, C1, w), state( M2, C1, e) ) :-
	M1 > 0,
	M2 is M1-1,
	show(M1,C1,M2,C1),
	safe(M2, C1).  % Move one missionary from west to east.

move( state( M1, C1, w), state( M2, C1, e) ) :-
	M1 > 1,
	M2 is M1-2,
	show(M1,C1,M2,C1),
	safe(M2, C1).  % Move two missionaries from west to east.

move( state( M1, C1, w), state( M2, C2, e) ) :-
	M1 > 0,
	C1 > 0,
	M2 is M1-1,
	C2 is C1-1,
	show(M1,C1,M2,C2),
	safe(M2, C2).  % Move one missionary and one cannibal from west to east.

move( state( M1, C1, w), state( M1, C2, e) ) :-
	C1 > 0,
	C2 is C1-1,
	show(M1,C1,M1,C2),
	safe(M1, C2).  % Move one cannibal from west to east.

move( state( M1, C1, w), state( M1, C2, e) ) :-
	C1 > 1,
	C2 is C1-2,
	show(M1,C1,M1,C2),
	safe(M1, C2).  % Move two cannibals from west to east.

move( state( M1, C1, e), state( M2, C1, w) ) :-
	M1 < 3,
	M2 is M1+1,
	show(M1,C1,M2,C1),
	safe(M2, C1).  % Move one missionary from east to west.

move( state( M1, C1, e), state( M2, C1, w) ) :-
	M1 < 2,
	M2 is M1+2,
	show(M1,C1,M2,C1),
	safe(M2, C1).  % Move two missionaries from east to west.

move( state( M1, C1, e), state( M2, C2, w) ) :-
	M1 < 3,
	C1 < 3,
	M2 is M1+1,
	C2 is C1+1,
	show(M1,C1,M2,C2),
	safe(M2, C2).  % Move one missionary and one cannibal from east to west.

move( state( M1, C1, e), state( M1, C2, w) ) :-
	C1 < 3,
	C2 is C1+1,
	show(M1,C1,M1,C2),
	safe(M1, C2).  % Move one cannibal from east to west.

move( state( M1, C1, e), state( M1, C2, w) ) :-
	C1 < 2,
	C2 is C1+2,
	show(M1,C1,M1,C2),
	safe(M1, C2).  % Move two cannibals from east to west.

path(Goal, Goal, Been_stack) :-
	write('Solution Path Is: ' ), nl,
	reverse_print_stack(Been_stack).

% A path from state to goal can make a simple move
% and from that point find a path to the goal.
path(State, Goal, Been_stack) :-
	move(State, Next_state),
	not(member_stack(Next_state, Been_stack)),
	stack(Next_state, Been_stack, New_been_stack),
	path(Next_state, Goal, New_been_stack), !.

% Set up Been (visited state) stack and start.
go(Start, Goal) :-
	empty_stack(Empty_been_stack),
	stack(Start, Empty_been_stack, Been_stack),
	path(Start, Goal, Been_stack).

% Try to solve the problem.
test :- go(state(3,3,w),state(0,0,e)).
