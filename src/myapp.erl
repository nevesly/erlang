%%%-----------------------------------------------------------------------------
%%% @author Seven Lu, <nevesly1109@gmail.com>
%%%  [http://www.sevenlu.com/]
%%% @copyright (C) 2014. Seven Lu
%%% @version 0.0.1
%%% @doc start of the project
%%% @end
%%%-----------------------------------------------------------------------------

-module(myapp).
-compile(export_all).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-define(APP_NAME, myapp).

start() ->
    % ranch
    application:start(ranch),

    % logger
    start_lager(),

    % start app
    application:start(?APP_NAME),

    ok.

start_lager() ->
    application:start(lager),
    lager:set_loglevel(lager_console_backend, error),
    ok.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% TEST
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
-ifdef(TEST).

simple_test() ->
    application:start(ranch),
    application:start(lager),
    applicatoin:start(myapp),
    ?assertNot(undefined == whereis(ranch_sup)),
    ?assertNot(undefined == whereis(lager_sup)),
    ?assertNot(undefined == whereis(myapp_sup)).

-endif.
