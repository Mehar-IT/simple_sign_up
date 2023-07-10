# #node block
# FROM node:alpine3.16 as nodework
# WORKDIR /myapp
# COPY package.json yarn.lock ./
# RUN yarn
# COPY . .
# RUN yarn run build

# #ngnix block
# FROM nginx:1.23-alpine
# WORKDIR /usr/share/ngnix/html
# RUN rm -rf ./*
# COPY --from=nodework /myapp/dist .
# ENTRYPOINT [ "nginx","-g","daemon off;" ]

# Stage 1: Build the Vite application
FROM node:alpine as build-stage
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn
COPY . .
RUN yarn build

# Stage 2: Serve the Vite application with Nginx
FROM nginx:1.23-alpine
COPY --from=build-stage /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
