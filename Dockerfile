FROM python:3.11
WORKDIR /app

RUN pip install -U pip && pip install pipenv
COPY Pipfile Pipfile.lock ./
RUN pipenv install --system --deploy
COPY ./src ./src

EXPOSE 8000

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0"]