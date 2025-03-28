from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

# Configure your PostgreSQL connection with your actual credentials
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://a_cole:teachers10@localhost:5432/deploy'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Define the Student model
class students(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    programme = db.Column(db.String(120), nullable=False)

# Define the Subject model 
class subjects(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    academic_year = db.Column(db.Integer, nullable=False)
    name = db.Column(db.String(100), nullable=False)

# Endpoint to retrieve all students
@app.route('/students', methods=['GET'])
def get_students():
    studs = students.query.all()
    students_list = [{"name": student.name, "program": student.programme} for student in studs]
    return jsonify(students_list)

# Endpoint to retrieve subjects organized by academic year
@app.route('/subjects', methods=['GET'])
def get_subjects():
    subs = subjects.query.all()
    subjects_by_year = {}
    for subject in subs:
        subjects_by_year.setdefault(subject.academic_year, []).append(subject.name)
    return jsonify(subjects_by_year)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
