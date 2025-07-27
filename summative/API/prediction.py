import uvicorn
import pickle
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, field_validator
import pandas as pd
import numpy as np
from typing import Literal
from os import environ

app = FastAPI(
    title="Teacher Performance Prediction API",
    description="API for predicting teacher performance based on various input parameters",
    version="1.0.0",
    docs_url="/api/docs",
    redoc_url="/api/redoc"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load model and scaler paths from environment variables or use defaults
MODEL_PATH = environ.get("MODEL_PATH", "../linear_regression/best_model_post_training.pkl")
SCALER_PATH = environ.get("SCALER_PATH", "../linear_regression/scaler_post_training.pkl")

# Pydantic model for input validation
class TeacherInput(BaseModel):
    age: int
    gender: Literal["Male", "Female"]
    highest_education: Literal["A0", "A1", "A2"]
    years_teaching: int
    student_count: str
    periods_per_week: int
    subject_leader: Literal["Yes", "No"]

    @field_validator("age")
    @classmethod
    def validate_age(cls, v):
        if v < 18 or v > 100:
            raise ValueError("Age must be between 18 and 100")
        return v

    @field_validator("years_teaching")
    @classmethod
    def validate_years_teaching(cls, v):
        if v < 0:
            raise ValueError("Years of teaching experience cannot be negative")
        return v

    @field_validator("periods_per_week")
    @classmethod
    def validate_periods(cls, v):
        if v < 0 or v > 168:  # Reasonable upper limit (24 hours * 7 days)
            raise ValueError("Periods per week must be between 0 and 168")
        return v

    @field_validator("student_count")
    @classmethod
    def validate_student_count(cls, v):
        valid_ranges = ["0-10", "10-20", "20-30", "30-40", "40-50", "50+"]
        if v not in valid_ranges:
            raise ValueError(f"Student count must be one of: {', '.join(valid_ranges)}")
        return v

def convert_student_count(student_count: str) -> int:
    ranges = {
        "0-10": 5,
        "10-20": 15,
        "20-30": 25,
        "30-40": 35,
        "40-50": 45,
        "50+": 55
    }
    return ranges.get(student_count, 0)

def load_model_and_scaler(model_path: str, scaler_path: str):
    try:
        with open(model_path, 'rb') as model_file:
            model = pickle.load(model_file)
        with open(scaler_path, 'rb') as scaler_file:
            scaler = pickle.load(scaler_file)
        print(f"Model loaded from {model_path} and scaler loaded from {scaler_path}")
        return model, scaler
    except Exception as e:
        print(f"Error loading model or scaler: {e}")
        raise

def predict_teacher_performance(input_data: TeacherInput) -> float:
    features = [
        "Age",
        "Your Gender",
        "Your Highest level of education",
        "Years of teaching experience (please write 0 if you don't have any teaching experience)",
        "Number of students in your classes",
        "How many periods of classes (all subjects) do you teach in a typical week?",
        "Are you a subject leader at your school?"
    ]

    input_dict = input_data.model_dump()
    input_dict = {
        "Age": input_dict["age"],
        "Your Gender": input_dict["gender"],
        "Your Highest level of education": input_dict["highest_education"],
        "Years of teaching experience (please write 0 if you don't have any teaching experience)": input_dict["years_teaching"],
        "Number of students in your classes": input_dict["student_count"],
        "How many periods of classes (all subjects) do you teach in a typical week?": input_dict["periods_per_week"],
        "Are you a subject leader at your school?": input_dict["subject_leader"]
    }
    
    input_df = pd.DataFrame([input_dict], columns=features)
    
    gender_map = {"Male": 0, "Female": 1}
    education_map = {"A1": 1, "A2": 0, "A0": 0}
    subject_leader_map = {"Yes": 1, "No": 0}

    input_df["Your Gender"] = input_df["Your Gender"].map(gender_map)
    if input_df["Your Gender"].isna().any():
        raise ValueError("Invalid value for 'Your Gender'. Expected 'Male' or 'Female'.")

    input_df["Your Highest level of education"] = input_df["Your Highest level of education"].map(education_map)
    if input_df["Your Highest level of education"].isna().any():
        raise ValueError("Invalid value for 'Your Highest level of education'. Expected 'A1', 'A2', or 'A0'.")

    input_df["Are you a subject leader at your school?"] = input_df["Are you a subject leader at your school?"].map(subject_leader_map)
    if input_df["Are you a subject leader at your school?"].isna().any():
        raise ValueError("Invalid value for 'Are you a subject leader at your school?'. Expected 'Yes' or 'No'.")

    input_df["Number of students in your classes"] = input_df["Number of students in your classes"].apply(convert_student_count)

    if input_df.isna().any().any():
        raise ValueError(f"Input contains NaN values after preprocessing: {input_df}")

    # Load the model and scaler using the new function
    model, scaler = load_model_and_scaler(
        model_path=MODEL_PATH,
        scaler_path=SCALER_PATH
    )

    # Scale the input data
    input_scaled = scaler.transform(input_df)
    print(f"Scaled input data: {input_scaled}")
    # Make prediction
    prediction = model.predict(input_scaled)
    return float(prediction[0])

@app.post("/api/predict")
async def predict(input_data: TeacherInput):
    try:
        prediction = predict_teacher_performance(input_data)
        return {"predicted_score": round(prediction, 2)}
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail="Internal server error")

@app.get("/api/health")
async def health_check():
    return {"status": "healthy"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
