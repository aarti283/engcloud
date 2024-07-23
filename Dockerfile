# Use the official Python image from the Docker Hub
FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set the working directory
WORKDIR /app

# Install system dependencies for Poetry
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Add Poetry to the PATH
ENV PATH="/root/.local/bin:$PATH"
ENV SECURE_WEATHER_API_KEY="adfadfa"

# Copy poetry files first to utilize docker caching
COPY pyproject.toml /app/

# Install project dependencies
RUN poetry config virtualenvs.create false \
    && poetry install --no-root --only main

# Copy the rest of the application code
COPY ./weather_app/ /app

# Expose the port the app runs on
EXPOSE 5000



# Define the command to run the application
CMD ["flask", "run"]