FROM python:3.11-slim

# libgl1/libglib: cv2 (even -headless builds) dlopen these at import on some distros.
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1 libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /srv

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app app
COPY models models
COPY data data
COPY kaggle kaggle
COPY yolo11m.pt .

# HF Spaces caches/HF model downloads (ViTPose) need a writable HOME.
ENV HOME=/srv \
    CRICLENS_HOST=0.0.0.0 \
    CRICLENS_PORT=7860

EXPOSE 7860

CMD ["python", "-m", "app.server"]
