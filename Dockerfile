FROM node:alpine
WORKDIR /build
RUN apk update
RUN apk add git vim jq bash zip file
RUN npm install -g typescript

RUN adduser --disabled-password user
COPY ./*.json ./
RUN chown -R user /build

# Run next commands as user. Use docker exec -u root -it {container_id} to get a root shell.
USER user

RUN npm install
COPY . .
#RUN npm run build # fails on cat/jq from package.json, due to sh
# jq 'del(.use_dynamic_url, .web_accessible_resources[].use_dynamic_url)' dist/manifest.json > dist/manifest.json.2 && mv dist/manifest.json.2 dist/manifest.json

RUN mkdir -p out

CMD ["bash", "-c", "set -x -eu; pwd; npm run build; pushd dist; zip ../discrub-dev.zip -r . --exclude out/*; popd; cp discrub-dev.zip out/"]
