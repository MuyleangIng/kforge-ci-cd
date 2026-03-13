FROM python:3.12-slim AS build

WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV VENV_PATH=/opt/venv

RUN python -m venv ${VENV_PATH}
ENV PATH="${VENV_PATH}/bin:${PATH}"

COPY . .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt gunicorn

FROM python:3.12-slim AS release

WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV VENV_PATH=/opt/venv
ENV PATH="${VENV_PATH}/bin:${PATH}"
ENV APP_ENV=production
ENV PORT=8000
ENV GUNICORN_WORKERS=2
ENV APP_MODULE=app:app

COPY --from=build ${VENV_PATH} ${VENV_PATH}
COPY . .
ENV HEALTHCHECK_PATH=/health
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 CMD python -c "import os, urllib.request; port=os.environ.get('PORT', '8000'); path=os.environ.get('HEALTHCHECK_PATH', '/health'); urllib.request.urlopen(f'http://127.0.0.1:{port}{path}', timeout=2).read()" || exit 1
ENV APP_ENV=production

EXPOSE 8000

CMD ["sh", "-c", "gunicorn --bind 0.0.0.0:${PORT:-8000} --workers ${GUNICORN_WORKERS:-2} ${APP_MODULE}"]
