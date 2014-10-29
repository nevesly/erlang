%%%-----------------------------------------------------------------------------
%%% @author Seven Lu, <nevesly1109@gmail.com>
%%%  [http://www.sevenlu.com/]
%%% @copyright 2014 Seven Lu. All rights reserved.
%%% @doc start of the project
%%% @end
%%%-----------------------------------------------------------------------------

-module(myrebarapp).
-compile(export_all).

-define(APP_NAME, 'myapp').

start() ->
    % ranch
    application:start(ranch),
    % logger
    start_lager(),
    % TODO: ranch tcp listener

    ok.

start_lager() ->
    application:start(lager).
    lager:set_loglevel(lager_console_backend, error).
 