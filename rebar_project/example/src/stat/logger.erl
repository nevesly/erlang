%%%-----------------------------------------------------------------------------
%%% @author Seven Lu, <nevesly1109@gmail.com>
%%%  [http://www.sevenlu.com/]
%%% @copyright (C) 2014. Seven Lu
%%% @doc this is a logger util, to support to log the statistics
%%% @end
%%%-----------------------------------------------------------------------------
-module(logger).
-behaviour(gen_server).
-export([
    start_link/2,
    init/1,
    handle_info/2,
    handle_cast/2,
    handle_call/3,
    terminate/2,
    code_change/3
]).
-export([log_info/2, log_info/3]).

% record defined
-record(state, {root, fd, name, pool_name}).

%
start_link(Name, Root) ->
    gen_server:start_link({local, Name}, ?MODULE, [Name, Root], []).

init([Name, Root]) ->
    erlang:start_timer(60000, self(), sync),
    {ok, #state{root = Root, pool_name = atom_to_list(Name)}}.

%
log_info(Pool, Msg) -> gen_server:cast(Pool, {log, Msg}).
log_info(Pool, Format, Msg) ->
    gen_server:cast(Pool, lists:flatten(io_lib:format(Format, Msg))).

%%%============================================
%%% API
%%%============================================
handle_info({timeout, _, sync}, State) ->
    sync(State#state.fd),
    erlang:start_timer(60000, self(), sync),
    {noreply, State};
handle_info(_, State) -> {noreply, State}.

handle_cast({log, Msg}, State) -> {noreply, State};
handle_cast({log_sep, Infos}, State) -> {noreply, State};
handle_cast(_, State) -> {noreply, State}.

handle_call(_, _From, State) -> {noreply, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

%%%============================================
%%% Internal Func
%%%============================================
sync(undefined) -> ok;
sync(Fd) -> file:sync(Fd).

