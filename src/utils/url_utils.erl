-module(url_utils).
-export([url_encode/1, url_decode/1, url_quote/1, url_unquote/1]).
-export([simple_url_quote/2, simple_url_encode/2]).

-define(IE, 'utf-8').
-define(HEX, 16).

url_encode(L) ->
    case erlang:function_exported(mochiweb_util, urlencode, 1) of
        true -> mochiweb_util:urlencode(L);
        false -> io:format("no mochiweb_util:urlencode~n"), simple_url_encode(L, [])
    end.

url_decode(XXX) -> todo.

% 
url_quote(UrlStr) ->
    case erlang:function_exported(mochiweb_util, quote_plus, 1) of
        true -> mochiweb_util:quote_plus(UrlStr);
        false -> io:format("no mochiweb_util:quote_plus~n"), lists:reverse(simple_url_quote(unicode:characters_to_binary(UrlStr), []))
    end.

url_unquote(XXX) -> todo.

% a simple implemention of url quote for notation characters: "&?=:<>", 
%   and also the non-ascii utf-8 characters
simple_url_quote(UrlStr, Acc) when is_binary(UrlStr) -> simple_url_quote(binary_to_list(UrlStr), Acc);
simple_url_quote([] = _UrlStr, Acc) -> Acc;
simple_url_quote([$&|T], Acc) -> simple_url_quote(T, "62%" ++ Acc);
simple_url_quote([$?|T], Acc) -> simple_url_quote(T, "F3%" ++ Acc);
simple_url_quote([$:|T], Acc) -> simple_url_quote(T, "3A%" ++ Acc);
simple_url_quote([$>|T], Acc) -> simple_url_quote(T, "3E%" ++ Acc);
simple_url_quote([$<|T], Acc) -> simple_url_quote(T, "3C%" ++ Acc);
simple_url_quote([$=|T], Acc) -> simple_url_quote(T, "3D%" ++ Acc);
simple_url_quote([H|T], Acc) when H > 125 -> % special characters
    H1 = lists:reverse(integer_to_list(H, ?HEX)),
    simple_url_quote(T, H1 ++ [$%] ++ Acc);
simple_url_quote([H|T], Acc) -> simple_url_quote(T, [H|Acc]).

% [{Key, Value}, {Key1, Value1}, ..]  ==> Key=Value&Key1=Value1
simple_url_encode([], EncString) -> EncString;
simple_url_encode([{K, V}], EncString) -> K ++ [$=|V] ++ EncString;
simple_url_encode([{K, V}|T], EncString) ->
    S = [$& | K] ++ [$=|url_quote(V)] ++ EncString,
    simple_url_encode(T, S).

