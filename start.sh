#!/bin/sh
exec erl -pa ebin edit deps/*/ebin -boot start_sasl -config myrebarapp -setcookie myrebarapp -sname myrebarapp1 -s inets -s lager -s reloader -s myrebarapp
