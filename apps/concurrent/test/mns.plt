:- begin_tests(mns).

:- use_module("../modules/user_input_parsing.pl").
:- use_module("../modules/query_parsing.pl").
:- use_module("../concurrent.pl").
:- use_module("../modules/mns.pl").

% currently fails
test('mns empty') :-
    parse_domain("A causes f", Domain),
    parse_obs("f|0", Obs),
    mns([], 0, Domain, Obs, Some_Valid_MNS),
    Some_Valid_MNS = [].

test('mns singular simple') :-
    parse_domain("A causes f", Domain),
    parse_obs("f|0", Obs),
    mns(["A"], 0, Domain, Obs, Some_Valid_MNS),
    Some_Valid_MNS = ["A"].

% currently fails
test('mns singular conditional') :-
    parse_domain("A causes f if not f", Domain),
    parse_obs("f|0", Obs),
    mns(["A"], 0, Domain, Obs, Some_Valid_MNS),
    Some_Valid_MNS = [].

test('mns multiple simple') :-
    parse_domain("A causes f \n B causes g", Domain),
    parse_obs("f|0", Obs),
    mns(["A","B"], 0, Domain, Obs, Some_Valid_MNS),
    Some_Valid_MNS = ["A","B"].

test('mns multiple conflict causes/causes') :-
    parse_domain("A causes f \n B causes not f", Domain),
    parse_obs("f|0", Obs),
    mns(["A","B"], 0, Domain, Obs, Some_Valid_MNS),
    length(Some_Valid_MNS, Count),
    Count=1.

test('mns multiple conflict causes/releases') :-
    parse_domain("A causes f \n B causes not f", Domain),
    parse_obs("f|0", Obs),
    mns(["A","B"], 0, Domain, Obs, Some_Valid_MNS),
    length(Some_Valid_MNS, Count),
    Count=1.

% currently fails
test('mns multiple conditional') :-
    parse_domain("A causes f \n B causes not g if f", Domain),
    parse_obs("f|0", Obs),
    mns(["A","B"], 0, Domain, Obs, Some_Valid_MNS),
    Some_Valid_MNS = ["A"].

:- end_tests(mns).
