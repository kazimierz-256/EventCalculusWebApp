:- use_module("../modules/warsaw_standoff.pl").
:- use_module("../modules/query_parsing.pl").
:- use_module("../concurrent.pl").

%%%%%%%%%%%%%%%%%
% WARSAW STANDOFF
%%%%%%%%%%%%%%%%%

% :-  warsaw_standoff_domain(Domain),
%     warsaw_standoff_scenario(Scenario),
%     get_query_from_text(Query, 'possibly executable'),
%     run_scenario(Scenario, Domain, Query).

%% TODO fix: fails
%:-  warsaw_standoff_domain(Domain),
%    warsaw_standoff_scenario(Scenario),
%    get_query_from_text(Query, 'possibly accessible ALIVE1 and not ALIVE2 and not ALIVE3 at 5'),
%    run_scenario(Scenario, Domain, Query).

%% TODO fix: fails
%:-  warsaw_standoff_domain(Domain),
%    warsaw_standoff_scenario(Scenario),
%    get_query_from_text(Query, 'possibly accessible ALIVE3 and JAMMED1 at 5'),
%    not(run_scenario(Scenario, Domain, Query)).
