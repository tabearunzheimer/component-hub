FROM node:18.18.1 AS builder

WORKDIR /usr/src/app 

COPY ./package*.json ./ 
COPY ./core-service/config/tsconfig.json ./tsconfig.json
COPY ./src ./src

RUN npm pkg delete scripts.prepare && npm pkg delete scripts.postinstall
# update path references
RUN sed -i 's/"\.\.\/\.\.\//".\//g' ./tsconfig.json 
RUN npm get && npm i

RUN npm run build:tsc:docker

## Stage 2

FROM node:18.18.1

WORKDIR /app

ENV NODE_ENV production

COPY --from=builder /usr/src/app/package*.json ./
COPY --from=builder /usr/src/app/dist ./dist

RUN npm pkg delete scripts.prepare && npm i --omit=dev

EXPOSE 8080/tcp

CMD ["node", "/app/dist/index.js"]