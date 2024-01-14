FROM python:3.11

WORKDIR /app
RUN pip install -U pip && pip install pipenv

# Install FFmpeg and Git
RUN apt-get update && \
    apt-get install -y ffmpeg git && \
    rm -rf /var/lib/apt/lists/*

COPY Pipfile Pipfile.lock ./
RUN pipenv install --system --deploy
COPY . .

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "80"]