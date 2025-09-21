
FROM python:3.11.13-slim

# Prevent Python from writing .pyc files and buffer their stdout/stderr
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install system dependencies and PostgreSQL client libs for psycopg build
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    libpq-dev \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory inside container where app code will live
WORKDIR /app

# Copy only requirements file first to use Docker cache and speed up installs
COPY requirements.txt /app/

# Install Python dependencies including psycopg from requirements.txt
RUN pip install --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt

# Copy project code into the working directory
COPY . /app/

# Expose the port the app runs on (default Django runserver port or Gunicorn)
EXPOSE 8080

# Run Django migrations and start Gunicorn WSGI server
CMD ["sh", "-c", "python manage.py migrate && python manage.py collectstatic && gunicorn main_dir.wsgi:application"]