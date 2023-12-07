# Use the Alpine Linux base image with a specified version
FROM alpine:latest

# Update the package list and install Python 3, Git, and Python pip
RUN apk update && \
    apk add --no-cache python3 git bash && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools

# Set the working directory inside the container
WORKDIR /app

# Copy the local contents into the container at /app
COPY . /app

