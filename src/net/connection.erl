%%%-----------------------------------------------------------------------
%%% @author Seven Lu, <nevesly1109@gmail.com>
%%%  [http://www.sevenlu.com/]
%%% @copyright (C) 2014. Seven Lu
%%% @doc tcp connection handler
%%% @end
%%%-----------------------------------------------------------------------

-module(connection).
-export([conn_connected/1, conn_closed/2, conn_data/2, conn_control/3]).

-record(state, {acc = 0}).

conn_connected(_Sock) -> {ok, #state{}}.

conn_closed(_Sock, #state{}) -> ok.

conn_data(Sock, #state{acc = Acc} = State) ->
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
    State#state{acc = Acc + 1}.
