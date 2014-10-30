
REBAR=./rebar

all:
	@$(REBAR) get-deps compile

test:
	rm -rf .eunit
	@$(REBAR) compile eunit
