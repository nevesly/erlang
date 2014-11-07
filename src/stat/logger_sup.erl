%%%-----------------------------------------------------------------------------
%%% @author Seven Lu, <nevesly1109@gmail.com>
%%%  [http://www.sevenlu.com/]
%%% @copyright (C) 2014. Seven Lu
%%% @doc this is a logger supervisour, to support to log the statistics
%%% @end
%%%-----------------------------------------------------------------------------
-module(logger_sup).

-behaviour(supervisor).

-export([start_link/1, init/1]).

start_link(Root) ->
    supervisour:start_link(?MODULE, [Root]).

init([Root]) ->
    Strategy = {one_for_one, 1, 60},
    Childs = [{StatLogger, {logger, start_link, [StatLogger, Root]}, permantant, 10000, worker, [logger]} 
                    || StatLogger <- logger_statistic:loggers()],
    {ok, {Strategy, Childs}}.
