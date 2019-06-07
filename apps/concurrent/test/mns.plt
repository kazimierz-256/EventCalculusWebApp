:- begin_tests(mns).

:- use_module("../modules/user_input_parsing.pl").
:- use_module("../modules/query_parsing.pl").
:- use_module("../concurrent.pl").
:- use_module("../modules/mns.pl").
:- use_module("../modules/logic_formula_satisfiability.pl").
:- use_module("../modules/occlusion.pl").

test('mns empty') :-
    parse_domain("a causes f", Domain),
    list_to_assoc(["f"-true], Fluent_Assignment),
    findall(
        Some_Valid_MNS,
        mns([], 0, Domain, Fluent_Assignment, Some_Valid_MNS),
        Results
    ),
    Results = [].

test('mns singular simple') :-
    parse_domain("a causes f", Domain),
    list_to_assoc(["f"-true], Fluent_Assignment),
    findall(
        Some_Valid_MNS,
        mns(["a"], 0, Domain, Fluent_Assignment, Some_Valid_MNS),
        Results
    ),
    Results = [["a"]].

test('mns singular conditional') :-
    parse_domain("a causes f if not f", Domain),
    list_to_assoc(["f"-true], Fluent_Assignment),
    findall(
        Some_Valid_MNS,
        mns(["a"], 0, Domain, Fluent_Assignment, Some_Valid_MNS),
        Results
    ),
    Results = [].

test('mns multiple simple') :-
    parse_domain("a causes f \n b causes g", Domain),
    list_to_assoc(["f"-true,"g"-true], Fluent_Assignment),
    findall(
        Some_Valid_MNS,
        mns(["a","b"], 0, Domain, Fluent_Assignment, Some_Valid_MNS),
        Results
    ),
    Results = [["a","b"]].

%currently fails
test('mns multiple conflict causes/causes') :-
    parse_domain("a causes f \n b causes not f", Domain),
    list_to_assoc(["f"-true], Fluent_Assignment),
    findall(
        Some_Valid_MNS,
        mns(["a","b"], 0, Domain, Fluent_Assignment, Some_Valid_MNS),
        Results
    ),
    Results = [["a"],["b"]].

%currently fails
test('mns multiple conflict causes/releases') :-
    parse_domain("a causes f \n b causes not f", Domain),
    list_to_assoc(["f"-true], Fluent_Assignment),
    findall(
        Some_Valid_MNS,
        mns(["a","b"], 0, Domain, Fluent_Assignment, Some_Valid_MNS),
        Results
    ),
    Results = [["a"],["b"]].

%currently fails
test('mns multiple conditional') :-
    parse_domain("a causes f \n b causes not g if not f", Domain),
    list_to_assoc(["f"-true,"g"-true], Fluent_Assignment),
    findall(
        Some_Valid_MNS,
        mns(["a","b"], 0, Domain, Fluent_Assignment, Some_Valid_MNS),
        Results
    ),
    Results = [["a"]].

:- end_tests(mns).
