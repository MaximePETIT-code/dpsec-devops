FROM public.ecr.aws/bitnami/python:3.9.18

COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt --progress-bar off

COPY src/app.py ./app.py

CMD ["python", "app.py"]