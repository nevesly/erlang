%%%-----------------------------------------------------------------------------
%%% @author Seven Lu, <nevesly1109@gmail.com>
%%%  [http://www.sevenlu.com/]
%%% @copyright (C) 2014. Seven Lu
%%% @doc tells which loggers to log stattistic
%%% @end
%%%-----------------------------------------------------------------------------
-module(logger_statistic).
-export([loggers/0]).
-export([log_reg/1]).

loggers() ->
    [log_reg].

log_reg(UserId) ->
    logger:log(log_reg, [UserId]).
