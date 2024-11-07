# Use the official Node.js image
FROM node:16

# Create app directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install app dependencies
RUN npm install

# Copy everything from the local src directory to the container's src directory
COPY src/ src/

# Expose port 3000 for the app
EXPOSE 3000

# Define the command to run the app
CMD ["npm", "start"]
