FROM python:3.11.4-slim-bullseye

# Prevent Python from buffering stdout and from writing .pyc files
ENV PYTHONUNBUFFERED=1 
ENV PYTHONDONTWRITEBYTECODE=1 

# Create a non-root user for security
RUN adduser --disabled-password --gecos "" appuser

# Set working directory
WORKDIR /app

# Install dependencies and cleanup (reduce image size)
RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y netcat && rm -rf /var/lib/apt/lists/*

# Install Python dependencies early (better caching)
COPY ./requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy start script and make it executable
COPY ./start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Copy the full project code into the container
COPY . /app/

# Switch to non-root user
USER appuser

# Optional: Healthcheck for Docker (requires /health/ endpoint)
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8000/health/ || exit 1

# Default command
CMD ["/app/start.sh"]