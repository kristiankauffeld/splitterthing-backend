FROM python:3.11
WORKDIR /code
COPY Pipfile Pipfile.lock ./
RUN pip install -U pip && pip install --no-cache-dir pipenv
RUN pipenv install --system --deploy --ignore-pipfile
COPY ./app /code/app

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "80"]