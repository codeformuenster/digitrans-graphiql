FROM node:12-alpine

WORKDIR /opt/digitransit-graphql
COPY . ./
RUN yarn && yarn build

# ---

FROM node:12-alpine
RUN yarn global add serve

WORKDIR /app
COPY --from=0 /opt/digitransit-graphql/build ./
COPY --from=0 /opt/digitransit-graphql/serve.json ./

# FIXME mv possible instead?
RUN mkdir ./graphiql \
    && ln -s ./static ./graphiql/static

EXPOSE 8080
ENTRYPOINT ["serve", "--listen", "tcp://0:8080", "--single"]
