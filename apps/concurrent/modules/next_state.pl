:- module(next_state, 
    [
        potentially_executable_atomic/4,
        list_potentially_executable_atomic/4
	]).


get_action_decomposition(Compound_Action, Time, Action_Decomposition) :-
    
    