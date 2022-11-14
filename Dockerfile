FROM node:16
# Installing libvips-dev for sharp Compatability
RUN apt-get update && apt-get install libvips-dev -y
# We are setting an argument as default to develop as we want to not have to provide this every time we run our setup.
# The ENV is a way to override it if we want to like production
ARG NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}
# WORKDIR we are creating a folder inside our container 🚀 where our node_modules will live
WORKDIR /opt/
# We copy package.json and yarn.lock (or package-lock.json if you use npm) into our work directory.
# We do this FIRST as 🐳 docker caches each layer and this will then speed up our build process. Unless the file changes. 📝
COPY ./package.json ./yarn.lock ./
# We then tell Docker where to look for our node_modules
ENV PATH /opt/node_modules/.bin:$PATH
# install dependencies
RUN yarn config set network-timeout 600000 -g && yarn install
# change the directory
WORKDIR /opt/app
# We then copy the project that we created first into this folder.
COPY ./ .
# Then we run yarn build to build our strapi project.
RUN yarn build
# At the end, we expose the port 1337 and tell Docker to run yarn develop
EXPOSE 1337
CMD ["yarn", "develop"]