# Use official Python slim image for a smaller footprint
FROM python:3.13-slim

# Set working directory
WORKDIR /app

# Copy requirements file
COPY summative/API/requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code and model files
COPY summative/API/prediction.py .
COPY summative/linear_regression/best_model_post_training.pkl .
COPY summative/linear_regression/scaler_post_training.pkl .

# Expose port 8000 for FastAPI
EXPOSE 8000

# Set environment variables for model paths (can be overridden)
ENV MODEL_PATH=/app/best_model_post_training.pkl
ENV SCALER_PATH=/app/scaler_post_training.pkl

# Run FastAPI with uvicorn
CMD ["uvicorn", "prediction:app", "--host", "0.0.0.0", "--port", "8000"]