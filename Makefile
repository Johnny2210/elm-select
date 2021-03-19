compile:
	elm make src/Select.elm > /dev/null

test:
	npm run elm-test

docs:
	elm-make --docs=documentation.json

run-demo:
	cd demo && npm i && npm start

compile-demo:
	cd demo && elm make src/Main.elm > /dev/null

# Make the github page (demo)
build-demo:
	rm -rf docs/*
	cd demo && npm run build

.PHONY: demo
