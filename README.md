# linear_regression_model
Predicting teachers’ post-test scores in Science and Elementary Technology (SET) after undergoing Continuous Professional Development (CPD) training.
It demonstrates an effect of educational training on teachers' teaching performance.

## Mission & Problem.

My mission is to bridge the technology education gap in Rwanda by delivering innovative educational programs. The lack of access to quality tech education limits students' opportunities. I plan address this through targeted training and predictive tools for teachers and students. This enhances teaching quality and student quality and outcomes in Technology.

## Documentation

The documentation can be found on the following links:
- Swagger: [Swagger docs](https://linear-regression-model-lw2t.onrender.com/api/docs)
- Redocs: [Redocs docs](https://linear-regression-model-lw2t.onrender.com/api/redoc)

*NB*: The server requires a minute of restart time as it uses Render's free hosting plan.

## Video DEMO

Youtube: [Video Link](https://youtu.be/IVG0OdKuTYM)

## API

The predictive model for teachers’ post-test scores in SET after CPD training is accessible via a publicly routable API endpoint. Use the following endpoint to get predictions based on input features (e.g., training hours, prior test scores, teaching experience):

Request:
```http
POST https://rwanda-tech-edu-api.example.com/api/predict
{
  "age": 30,
  "gender": "Female",
  "highest_education": "A0",
  "years_teaching": 30,
  "student_count": "30-40",
  "periods_per_week": 6,
  "subject_leader": "No"
}
```
Response:
```json
{
  "predicted_score": 82.5
}
```

## Mobile App
Check [README.md](https://github.com/degide/linear_regression_model/tree/master/summative/FlutterApp)

## Contributors

- Egide Harerimana <h.egide@alustudent.com>

## License

This project is licensed under the MIT License - see the LICENSE file for details.
