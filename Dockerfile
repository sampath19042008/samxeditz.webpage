# Dockerfile for Samxeditz - single container hosting frontend + Flask backend
FROM python:3.11-slim

# Install system deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set workdir
WORKDIR /app

# Copy backend requirements and install
COPY backend/requirements.txt /app/backend/requirements.txt
RUN pip install --upgrade pip setuptools
RUN pip install -r /app/backend/requirements.txt
# Install gunicorn for production server
RUN pip install gunicorn

# Copy entire project into container
COPY . /app

# Expose port (Cloud Run provides PORT env var at runtime)
ENV PORT=8080
EXPOSE 8080

# Run the app with gunicorn
CMD ["gunicorn", "backend.app:app", "--bind", "0.0.0.0:8080", "--workers", "2", "--threads", "4"]
