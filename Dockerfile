# Stage 1: Build the Astro project
FROM node:22-alpine AS builder

WORKDIR /app

# Copy package files and install dependencies
COPY package.json ./
RUN npm install

# Copy the rest of the project files
COPY . .

# Build the project (output goes to /app/dist)
RUN npm run build

# Stage 2: Serve the static files using Nginx
FROM nginx:stable-alpine

# Copy the build output to Nginx's default content directory
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80 for the web server
EXPOSE 80

# The default command will start Nginx automatically in the background
CMD ["nginx", "-g", "daemon off;"]
