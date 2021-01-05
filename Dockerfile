FROM node:14-alpine as build

WORKDIR /usr/src/app

COPY package.json package-lock.json babel.config.js webpack.config.js knexfile.js ./

RUN npm install

COPY schema-registry.js ./
COPY client ./client
COPY app ./app
COPY migrations ./migrations
COPY test ./tests

RUN npm run build

FROM node:14-alpine as release

USER nobody

WORKDIR /usr/src/app

EXPOSE 3000

COPY --from=build /usr/src/app ./

CMD ["node", "schema-registry.js"]
