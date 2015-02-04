%%%-----------------------------------------------------------------------
%%% @author Seven Lu, <nevesly1109@gmail.com>
%%%  [http://www.sevenlu.com/]
%%% @copyright (C) 2014. Seven Lu
%%% @doc tcp connection agent
%%% @end
%%%-----------------------------------------------------------------------
-module(conn_agent).

-export([start_link/4, init/4]).

start_link(Ref, Socket, Transport, Opts) ->
    Pid = spawn_link(?MODULE, init, [Ref, Socket, Transport, Opts]),
    {ok, Pid}.

init(Ref, Socket, Transport, _Opts) ->
    ok = ranch:accept_ack(Ref),
    inet:setopts(
        Socket, [
            binary,
            {nodelay, true},
            {packet, raw},
            {active, true}]),
    ProtoOpts = ranch_server:get_protocol_options(Ref),
    ConnMod = proplists:get_value(conn_mod, ProtoOpts),
    {ok, State} = ConnMod:conn_connected(Socket),
    loop(Socket, ConnMod, State, Transport).

% Loop
loop(Socket, ConnMod, State, Transport) ->
    lager:debug("Socket[~p], State[~p]", [Socket, State]),
    receive
        {tcp, Socket, Bin} ->
            lager:debug("received Bin[~p]", [Bin]),
            % do the proto request
            NewState = 
                case catch ConnMod:conn_data(Socket, Bin, State) of
                    State1 when element(1, State1) =:= state -> State1;
                    InvalidState ->
                        lager:debug("{tcp, Socket, Bin}, InvalidState[~p]", [InvalidState]),
                        State
                end,
            loop(Socket, ConnMod, NewState, Transport);
        {tcp_closed, Socket} ->
            lager:debug("*************** tcp_closed ***************"),
            ConnMod:conn_closed(Socket, State);
        Request ->
            lager:debug("Request[~p]", [Request]),
            case catch ConnMod:conn_control(Socket, Request, State) of
                stop -> stop;
                {'EXIT', {timeout, _}} ->
                    lager:debug("************ 'EXIT' with timeout ************"),
                    ConnMod:conn_closed(Socket, State);
                _ ->
                    loop(Socket, ConnMod, State, Transport)
            end
    end.

