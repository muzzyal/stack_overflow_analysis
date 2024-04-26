FROM mcr.microsoft.com/devcontainers/python:1-3.11-bullseye

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/pip/

RUN pip3 --no-cache-dir install -r /tmp/pip/requirements.txt \
    && rm -rf /tmp/pip
