
FROM alpine:3.20 AS downloader

RUN apk add --no-cache curl

RUN curl -fL --retry 3 \
  "https://huggingface.co/tensorblock/SmolLM2-135M-Instruct-GGUF/resolve/main/SmolLM2-135M-Instruct-Q3_K_M.gguf" \
  -o /smollm2.gguf

FROM ghcr.io/ggml-org/llama.cpp:server

COPY --from=downloader /smollm2.gguf /app/smollm2.gguf

EXPOSE 8080


CMD ["-m", "/app/smollm2.gguf", "--alias", "smollm2", "--host", "0.0.0.0", "--port", "8080", "-c", "256", "-b", "32", "-t", "1", "-n", "48", "--ui"]

