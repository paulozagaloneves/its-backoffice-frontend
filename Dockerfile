FROM node:latest as builder
RUN apt-get update && apt-get install -y \
  jq \
  moreutils

WORKDIR /data
COPY package*.json ./
#COPY .npmrc ./
# RUN npm install less-loader
RUN npm install
COPY . ./

ARG deploy_env=ci
#ENV ENVIRONMENT=$(ENVIRONMENT)
#RUN chmod +x replaceUrl.sh
#RUN ./replaceUrl.sh $deploy_env

RUN npm run build

FROM nginx:1.17.8-alpine

RUN apk --no-cache add curl
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /data/dist/backoffice-frontend/ /usr/share/nginx/html/
EXPOSE 8080