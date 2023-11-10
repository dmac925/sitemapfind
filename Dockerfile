# Use a Node.js version compatible with your dependencies
# This example uses the official Node.js 16 image with Debian (buster-slim)
# You can choose a different image if you have specific requirements
FROM node:16-buster-slim

# Optionally, install Chrome if your project requires it
# This step is necessary if you're using Puppeteer
RUN apt-get update \
    && apt-get install -y wget gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory in the Docker container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json files
COPY package*.json ./

# Install NPM packages, skip optional and development dependencies
RUN npm --quiet set progress=false \
 && npm install --only=prod --no-optional \
 && echo "Installed NPM packages:" \
 && npm list \
 && echo "Node.js version:" \
 && node --version \
 && echo "NPM version:" \
 && npm --version

# Copy the remaining files and directories with the source code
COPY . ./

# Specify how to run the source code
CMD ["npm", "start"]
