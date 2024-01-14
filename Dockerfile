FROM python:3.11
WORKDIR /code
COPY Pipfile Pipfile.lock ./
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt
COPY ./app /code/app

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "80"]