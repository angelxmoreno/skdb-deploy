# Use the Bun-based image that includes git
FROM imbios/bun-node:1.1.18-18.20.2-alpine-git

# Set the working directory for building the FE
WORKDIR /src

# Accept build arguments for authentication and repository details.
ARG GITHUB_USERNAME
ARG GITHUB_ACCESS_TOKEN
ARG GITHUB_FE_REPO

# Clone the FE repository using the GitHub personal access token.
RUN git clone https://${GITHUB_USERNAME}:${GITHUB_ACCESS_TOKEN}@github.com/${GITHUB_FE_REPO}.git .

# Install dependencies (including dev dependencies) and build the app.
RUN bun install
RUN bun run build

# Copy the built assets from /src/dist to /public.
# The /public directory will be mounted to a Docker volume (skdb_fe_data) so that
# the final nginx container can serve these files.
RUN mkdir -p /public && cp -r /src/dist/* /public/

# Keep the container running so that you can exec into it for updates.
CMD ["tail", "-f", "/dev/null"]
