FROM python:3.11-slim

# 1. Create app dir
WORKDIR /api

# 2. Copy only requirements first (cache-friendly)
COPY requirements.txt .

# 3. Upgrade pip, install deps
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# 4. Copy the rest of your code
COPY . .

# 5. Set Flask env & expose port
ENV FLASK_APP=api.py
ENV FLASK_RUN_HOST=0.0.0.0
EXPOSE 5000

# 6. Launch
CMD ["flask", "run"]

