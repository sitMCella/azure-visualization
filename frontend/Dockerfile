FROM node:18-alpine AS base
RUN mkdir -p /development
WORKDIR /development
COPY development/package.json /development
RUN npm install

FROM base AS build
WORKDIR /development
COPY development/ /development
RUN npm run build

FROM nginx:alpine
COPY --from=build /development/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]