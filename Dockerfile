FROM alpine:latest

RUN apk add --no-cache \
    python3 \
    py3-pip \
    curl
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
COPY . /app
WORKDIR /app
RUN /bin/sh -lc "uv sync"

ENV PREFERRED_PROVIDER=ollama
ENV BIG_MODEL=llama4:maverick
ENV SMALL_MODEL=llama4:scout
ENV PORT=8080
EXPOSE ${PORT}

ENTRYPOINT [ "/bin/sh", "-lc" ]
CMD [ "uv run -v uvicorn server:app --host 0.0.0.0 --port ${PORT} --access-log --proxy-headers --log-config logging.yaml" ]