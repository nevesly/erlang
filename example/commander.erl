%% @author seven.lu
%% @doc this is a example to show how to make a shell-like program,
%%      which user can input command and get the command result.
%% @end

-module(commander).
-compile(export_all).

start() ->
    group_leader(c:pid(0, 33 ,0), self()),
    help([]),
    wait_cmd().

wait_cmd() ->
    Cmd = string:strip(io:get_line("command> "), both, $\n),
    do_cmd(Cmd).

do_cmd("echo") -> io:format("this is an echo...~n");
do_cmd("quit") -> erlang:halt();
do_cmd("") -> wait_cmd();
do_cmd(Cmd) ->
    [Cmd1 | Param] = string:tokens(Cmd, " "),
    io:format("Cmd: ~p~n", [Cmd1]),
    io:format("Param: ~p~n", [Param]),
    wait_cmd().

help([]) -> io:format(help_string()).
%%
%% @ret -> string()
help_string() ->
"
command                     parameters
=======                     ==========
echo
ls
quit
~n".

-spec cmd_type_to_erl_type_mfa() -> list().
%% @doc define the MFA to change the cmd string to the user defined type
%% @end
cmd_type_to_erl_type_mfa() ->
    [
        {int, {erlang, list_to_integer}},
        {float, {erlang, list_to_float}},
        {atom, {erlang, list_to_atom}}
    ].

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

