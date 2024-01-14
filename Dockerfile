FROM python:3.11

WORKDIR /app

# Install FFmpeg and Git
RUN apt-get update && \
    apt-get install -y ffmpeg git && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip install -U pip && pip install pipenv

# Install FFmpeg Python package
RUN pip install ffmpeg

# Install the CPU-only version of PyTorch, torchvision, and torchaudio
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# Install SoundFile and Sox
RUN pip install soundfile sox

# Copy the Pipfile and Pipfile.lock into the container
COPY Pipfile Pipfile.lock ./

# Install any additional dependencies from Pipfile.lock
RUN pipenv install --system --deploy

# Copy the rest of your application's code
COPY . .

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "80"]
