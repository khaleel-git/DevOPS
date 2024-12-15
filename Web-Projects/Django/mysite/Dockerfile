FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy project files
COPY requirements.txt /app/
COPY . /app/

# Install dependencies
RUN apt update && \
    apt install -y python3 && \
    python3 -m pip install --upgrade pip && \
    python3 -m pip install -r requirements.txt

# Expose the Django app port
EXPOSE 8000

# Run the Django app
ENTRYPOINT ["python3", "manage.py", "runserver", "0.0.0.0:8000"]
