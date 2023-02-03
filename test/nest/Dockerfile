ARG IMAGE_VERSION
ARG VERSION_NAME_PREFIX
FROM yunnysunny/alinode-compiler:${IMAGE_SUFFIX}${IMAGE_VERSION} as install-stage

COPY package.json .
COPY yarn.lock .

RUN yarn install --production

FROM install-stage as build-stage
RUN yarn install
COPY . .
RUN yarn build

FROM yunnysunny/alinode-runtime:${IMAGE_SUFFIX}${IMAGE_VERSION}
RUN mkdir -p /app
WORKDIR /app
ARG APP_ID
ENV APP_ID $APP_ID
ARG APP_SECRET
ENV APP_SECRET $APP_SECRET
COPY --from=install-stage /tmp/node_modules ./node_modules
COPY --from=build-stage /tmp/dist ./dist
COPY ./package.json ./
CMD ["node", "dist/main.js"]