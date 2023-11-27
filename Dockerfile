# ./Dockerfile

# Extend from the official Elixir image.
FROM elixir:latest
# Install PostgreSQL client
RUN apt-get update && \
    apt-get install -y postgresql-client
    
# Create app directory and copy the Elixir projects into it.
RUN mkdir /app
COPY . /app
WORKDIR /app

# Install Hex package manager.
# By using `--force`, we don’t need to type “Y” to confirm the installation.
RUN mix local.hex --force
RUN mix deps.get

# Compile the project.
RUN mix do compile
