%%%-----------------------------------------------------------------------
%%% @author Seven Lu, <nevesly1109@gmail.com>
%%% @copyright (C) 2014. Seven Lu
%%% @doc for des encrypt and decrypt
%%% @end
%%%-----------------------------------------------------------------------
-module(des_adapter).
-compile(export_all).

%
key() -> crypto:strong_rand_bytes(8).

%
init_vector() -> crypto:strong_rand_bytes(8).

% 
encrypt(DESKey, DESVector, Data) ->
    todo.
