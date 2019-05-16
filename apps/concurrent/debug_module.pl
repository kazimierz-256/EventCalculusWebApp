:- module(debug_module, 
    [   print_all_values/1,
        print_vals/3
	]).

print_all_values(DOMAIN) :-
    assoc_to_keys(DOMAIN, KEYS),
    print_vals(DOMAIN, KEYS).

print_vals(_, [], _).
print_vals(DOMAIN, [H|T]) :-
    get_from_domain(H, DOMAIN, VALUE),
    print_vals(DOMAIN, T).