#!/bin/sh
exec erl -pa ebin edit deps/*/ebin \
    -boot start_sasl \
    -config myapp \
    -setcookie myrebarapp \
    -name seven_rebar_app@127.0.0.1 \
    -s inets \
    -s lager \
    -s reloader \
    -s myapp start
