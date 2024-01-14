FROM python:3.11
WORKDIR /app
COPY Pipfile Pipfile.lock ./
RUN pip install -U pip && pip install --no-cache-dir pipenv
RUN pipenv install --system --deploy --ignore-pipfile

CMD ["uvicorn", "src.app:app", "--host", "0.0.0.0", "--port", "80", "--reload"]