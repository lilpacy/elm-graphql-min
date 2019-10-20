setup:
	cd elm-graphql && \
	npm i && \
	cd ../simple_json_graphql && \
	npm i && \
	npx elm install jamesmacaulay/elm-graphql

dev-server: simple_json_graphql
	cd simple_json_graphql && \
	npm run startDev

dev-client: elm-graphql
	cd elm-graphql && \
	make