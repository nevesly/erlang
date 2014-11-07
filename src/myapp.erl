%%%-----------------------------------------------------------------------
%%% @author Seven Lu, <nevesly1109@gmail.com>
%%%  [http://www.sevenlu.com/]
%%% @copyright (C) 2014. Seven Lu
%%% @version 0.0.1
%%% @doc start of the project
%%% @end
%%%-----------------------------------------------------------------------

-module(myapp).
-compile(export_all).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

%
start() ->
    % ranch
    application:start(ranch),

    % logger
    start_lager(),

    % start app
    application:start(?APP_NAME),

    % start TCP listener
    {ok, _} = start_ranch_listener(),

    io:format("************** myapp is running ******************~n"),

    ok.

start_lager() ->
    application:start(lager),
    lager:set_loglevel(lager_console_backend, error),
    ok.

start_ranch_listener() ->
    {ok, ListenPort} = application:get_env(?APP_NAME, socket_port),
    ranch:start_listener(
            tcp_myapp, 16,
            ranch_tcp, [{port, ListenPort}, {max_connections, 20000}],
            conn_agent, [{conn_mod, connection}]).

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
