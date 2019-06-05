:- begin_tests(mns).

:- use_module("../modules/user_input_parsing.pl").
:- use_module("../modules/query_parsing.pl").
:- use_module("../concurrent.pl").
:- use_module("../modules/mns.pl").
:- use_module("../modules/logic_formula_satisfiability.pl").
:- use_module("../modules/occlusion.pl").

test('mns empty') :-
    parse_domain("A causes f", Domain),
    list_to_assoc(["f"-true], Fluent_Assignment),
    findall(
        Some_Valid_MNS,
        mns([], 0, Domain, Fluent_Assignment, Some_Valid_MNS),
        Results
    ),
    Results = [].

test('mns singular simple') :-
    parse_domain("A causes f", Domain),
    list_to_assoc(["f"-true], Fluent_Assignment),
    findall(
        Some_Valid_MNS,
        mns(["A"], 0, Domain, Fluent_Assignment, Some_Valid_MNS),
        Results
    ),
    Results = [["A"]].

test('mns singular conditional') :-
    parse_domain("A causes f if not f", Domain),
    list_to_assoc(["f"-true], Fluent_Assignment),
    findall(
        Some_Valid_MNS,
        mns(["A"], 0, Domain, Fluent_Assignment, Some_Valid_MNS),
        Results
    ),
    Results = [].

test('mns multiple simple') :-
    parse_domain("A causes f \n B causes g", Domain),
    list_to_assoc(["f"-true,"g"-true], Fluent_Assignment),
    findall(
        Some_Valid_MNS,
        mns(["A","B"], 0, Domain, Fluent_Assignment, Some_Valid_MNS),
        Results
    ),
    Results = [["A","B"]].

%currently fails
test('mns multiple conflict causes/causes') :-
    parse_domain("A causes f \n B causes not f", Domain),
    list_to_assoc(["f"-true], Fluent_Assignment),
    findall(
        Some_Valid_MNS,
        mns(["A","B"], 0, Domain, Fluent_Assignment, Some_Valid_MNS),
        Results
    ),
    Results = [["A"],["B"]].

%currently fails
test('mns multiple conflict causes/releases') :-
    parse_domain("A causes f \n B causes not f", Domain),
    list_to_assoc(["f"-true], Fluent_Assignment),
    findall(
        Some_Valid_MNS,
        mns(["A","B"], 0, Domain, Fluent_Assignment, Some_Valid_MNS),
        Results
    ),
    Results = [["A"],["B"]].

%currently fails
test('mns multiple conditional') :-
    parse_domain("A causes f \n B causes not g if not f", Domain),
    list_to_assoc(["f"-true,"g"-true], Fluent_Assignment),
    findall(
        Some_Valid_MNS,
        mns(["A","B"], 0, Domain, Fluent_Assignment, Some_Valid_MNS),
        Results
    ),
    Results = [["A"]].

:- end_tests(mns).
