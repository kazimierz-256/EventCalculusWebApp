:- module(app_concurrent, []).
:- use_module("../../pengines_unsandboxed.pl").

:- pengine_application(concurrent).
:- use_module(concurrent:concurrent).

