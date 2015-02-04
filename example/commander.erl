%% @author seven.lu
%% @doc this is a example to show how to make a shell-like program,
%%      which user can input command and get the command result.
%% @end

-module(commander).
-compile(export_all).

% XXX: the shell pid is a magic number
-define(SHELL_PID, 26).

start() ->
    group_leader(c:pid(0, ?SHELL_PID, 0), self()),
    help([]),
    wait_cmd().

wait_cmd() ->
    Cmd = string:strip(io:get_line("command> "), both, $\n),
    do_cmd(Cmd).

%% @doc to run the commend 
%% @end
do_cmd("quit") -> erlang:halt();
do_cmd("") -> wait_cmd();
do_cmd(Cmd) ->
    [Cmd1 | Params] = string:tokens(Cmd, " "),
    case parse_cmd(Cmd1, Params) of
        undefined -> io:format("Unknown command!~n");
        {Cmd1, NewParams} ->
            Fun = list_to_existing_atom(Cmd1),
            ?MODULE:Fun(NewParams)
    end,
    wait_cmd().

%% @doc command parameters must convert to the erlang data type,
%% @end
parse_cmd(Cmd, Params) -> parse_cmd(Cmd, commands(), Params).
parse_cmd(_Cmd, [], _Params) -> undefined;
parse_cmd(Cmd, [{Cmd, ParamsType}|_], Params) -> {Cmd, parse_param(ParamsType, Params, [])};
parse_cmd(Cmd, [_|T], Params) -> parse_cmd(Cmd, T, Params).

parse_param([], _, Acc) -> lists:reverse(Acc);
parse_param([H|T], [P|Params], Acc) -> 
    Acc1 = [to_type_value(P, H) | Acc],
    parse_param(T, Params, Acc1).

%%------------------------------------------------------
%% the implement of the commands
%%------------------------------------------------------
ls([]) ->
    io:format("~p~n", [os:cmd("ls")]).

echo([S]) ->
    io:format("~s~n", [S]).

%% print the help string
help([]) -> io:format(help_string()).
help_string() ->
    Head = io_lib:format("
command~20.0sparameters
=======~20.0s==========~n", [" ", " "]),
    F = fun({Cmd, ParamType}, Acc) ->
            Cmd1 = io_lib:format("~-27s", [Cmd]),
            A = lists:append(Acc, Cmd1),
            A1 = lists:foldl(
                fun(X, Y) ->
                    lists:append(Y, atom_to_list(X))
                end, A, ParamType),
            A1 ++ "~n"
        end,
    lists:foldl(F, Head, commands()).

%%------------------------------------------------------
%% @doc return the command list
-spec commands() -> list().
commands() ->
    [
        {"help", []},
        {"ls", []},
        {"echo", [string]}
    ].

%%------------------------------------------------------
%% @doc define the MFA to change the cmd string to the user defined type
%% @end
-spec cmd_type_to_erl_type_mfa() -> list().
cmd_type_to_erl_type_mfa() ->
    [
        {int, {erlang, list_to_integer}},
        {float, {erlang, list_to_float}},
        {atom, {erlang, list_to_atom}}
    ].

%%------------------------------------------------------
-spec to_type_value(string(), atom()) -> integer() | float() | atom() | list().
%% @doc convert the type defined in user command
%%      to the erlang type
%% @end
%% @ret 
to_type_value(V, T) -> to_type_value(V, T, cmd_type_to_erl_type_mfa()).
to_type_value(V, T, MFAList) ->
    case proplists:get_value(T, MFAList) of
        {M, F} -> M:F(V);
        _ -> V
    end.

