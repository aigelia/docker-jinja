ARG BASE_IMAGE=python:3.11-slim
FROM ${BASE_IMAGE}

WORKDIR /app

ARG VERSION=0.1.1
ARG HASH

ADD --checksum=sha256:${HASH} \
    https://github.com/MrDave/StaticJinjaPlus/archive/refs/tags/${VERSION}.tar.gz \
    SJP.tar.gz
RUN tar xzf SJP.tar.gz --strip-components=1 && rm SJP.tar.gz

RUN if [ -f /etc/lsb-release ]; then \
        apt-get update && \
        apt-get install -y python3 python3-pip && \
        rm -rf /var/lib/apt/lists/*; \
    fi

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python3", "main.py", "--srcpath", "/templates", "--outpath", "/render"]
