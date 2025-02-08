# Stage 1: Build the React app using Bun
FROM imbios/bun-node:1.1.18-18.20.2-alpine-git AS builder

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

# Stage 2: Copy only the built assets to the /app directory.
FROM alpine:latest AS copier
WORKDIR /app
COPY --from=builder /src/dist/ .

# Note: This stage exists solely to provide the built assets in /app,
# which will be output to the shared volume skdb_fe_data when used as a build context.
