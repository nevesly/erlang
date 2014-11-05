%%%-----------------------------------------------------------------------------
%%% @author Seven Lu, <nevesly1109@gmail.com>
%%%  [http://www.sevenlu.com/]
%%% @copyright (C) 2014. Seven Lu
%%% @doc this is a logger util, to support to log the statistics
%%% @end
%%%-----------------------------------------------------------------------------
-module(logger).

-export([
    init/1,
    handle_info/2,
    handle_cast/2,
    handle_call/3,
    terminate/2,
    code_change/3
]).
-export([start_link/2]).

-behaviour(gen_server).

% record
-record(state, {root, fd, name, pool_name}).

start_link(Name, Root) ->
    gen_server:start_link({local, Name}, ?MODULE, [Name, Root], []).

init([_Name, _Root]) ->
    {ok, #state{}}.

%%%============================================
%%% API
%%%============================================
handle_info(_, State) -> {noreply, State}.

handle_cast(_, State) -> {noreply, State}.

handle_call(_, _From, State) -> {noreply, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

%%%============================================
%%% Internal Func
%%%============================================
sync(undefined) -> ok;
sync(Fd) -> file:sync(Fd).

