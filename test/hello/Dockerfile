ARG IMAGE_VERSION
FROM yunnysunny/alinode-compiler:${IMAGE_VERSION} as build-stage

COPY package.json .
COPY yarn.lock .

RUN yarn install

FROM yunnysunny/alinode-runtime:${IMAGE_VERSION}
RUN mkdir -p /app
WORKDIR /app
ARG APP_ID
ENV APP_ID $APP_ID
ARG APP_SECRET
ENV APP_SECRET $APP_SECRET
COPY --from=build-stage /tmp/node_modules ./node_modules
COPY . .
CMD ["node", "src/app.js"]