FROM python:3.12-alpine3.18
LABEL maintainer="mateusbarbosa999@gmail.com"

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apk add --no-cache build-base python3-dev
RUN apk add --no-cache postgresql-dev gcc python3-dev musl-dev
COPY ./djangoProject /djangoProject
COPY Scripts.sh /Scripts/commands.sh
# Adjusted COPY command for manage.py to ensure it's in the correct directory
COPY ./manage.py /djangoProject/manage.py
# Adjusted WORKDIR to match the directory where manage.py is located
WORKDIR /djangoProject
EXPOSE 8000
RUN python -m venv /venv
RUN /venv/bin/pip install --upgrade pip
RUN /venv/bin/pip install -r /djangoProject/requirements.txt
RUN adduser --disabled-password --no-create-home duser
RUN mkdir -p /data/web/static && mkdir -p /data/web/media
RUN chown -R duser:duser /venv /data/web/static /data/web/media
RUN chmod -R 755 /data/web/static /data/web/media
RUN chmod +x /Scripts/commands.sh
ENV PATH="/Scripts:/venv/bin:$PATH"
USER duser
CMD ["/Scripts/commands.sh"]
