FROM python:3-alpine

WORKDIR /usr/src/app
#RUN addgroup -S app_user && adduser -S -g app_user -h . app_user
#USER app_user

COPY . .
RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "main.py"]
