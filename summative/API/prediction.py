import uvicorn
import pickle
from fastapi import FastAPI

app = FastAPI()

@app.post('/predict')
def predict(data):
    # load the model from disk
    model = pickle.load(open('funmodel', 'rb'))
    return model.predict(data)

uvicorn.run(app, host = '127.0.0.1', port = 8000)
