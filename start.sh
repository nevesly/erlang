#!/bin/sh
exec erl -pa ebin edit deps/*/ebin \
    -boot start_sasl \
    -config myapp \
    -setcookie myrebarapp \
    -sname myrebarapp1 \
    -s inets \
    -s lager \
    -s reloader \
    -s myapp . .
