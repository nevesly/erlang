%%%-----------------------------------------------------------------------
%%% @author Seven Lu, <nevesly1109@gmail.com>
%%%  [http://www.sevenlu.com/]
%%% @copyright (C) 2014. Seven Lu
%%% @doc tcp connection handler
%%% @end
%%%-----------------------------------------------------------------------

-module(connection).
-export([conn_connected/1, conn_closed/2, conn_data/3, conn_control/3]).

-record(state, {acc = 0}).

%
conn_connected(_Sock) -> {ok, #state{}}.

%
conn_closed(_Sock, #state{} = S) -> lager:debug("state[~p]", [S]), ok.

% conn_data: do the proto request
conn_data(Sock, Data, #state{acc = Acc} = State) ->
    send_simple_msg(Sock, binary:list_to_bin(io_lib:format(<<"hello, data received[~p], acc=~p">>, [Data, Acc + 1]))),
    State#state{acc = Acc + 1}.

%
conn_control(Sock, {timeout, _Ref, Msg}, #state{}) ->
    lager:debug("time out...."),
    gen_tcp:close(Sock),
    stop;
conn_control(Sock, {stop, Reason}, _State) ->
    lager:debug("stop, reason[~p]", [Reason]),
    gen_tcp:close(Sock),
    stop;
conn_control(Sock, Req, #state{acc = Acc} = State) ->
    send_simple_msg(Sock, binary:list_to_bin(io_lib:format(<<"hello, acc=~p">>, [Acc+1]))),
    State#state{acc = Acc + 1}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Internal API
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
send_simple_msg(Sock, Bin) ->
    lager:debug("send_simple_msg: Bin[~p]", [Bin]),
    gen_tcp:send(Sock, Bin).

send_msg(Sock, Bin) ->
    todo.
