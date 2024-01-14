FROM python:3.11

WORKDIR /app

# Install FFmpeg and Git
RUN apt-get update && \
    apt-get install -y ffmpeg git && \
    rm -rf /var/lib/apt/lists/*

RUN pip install -U pip && pip install pipenv


# Install the CPU-only version of PyTorch
# Replace '2.0.0' with the actual version you need
RUN pip install torch==2.1.2 --index-url https://download.pytorch.org/whl/cpu

COPY Pipfile Pipfile.lock ./

RUN pipenv install --system --deploy

COPY . .

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "80"]