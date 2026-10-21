import 'package:lms_layered_architecture_example/model/course.dart';
import 'package:lms_layered_architecture_example/model/course_result.dart';

import '../model/student.dart';

class LmsSystem {
  final List<Student> students = [];
  final List<Course> courses = [];
 
  void addCourse({required String courseId, required courseName }) {
    if (_findCourseOrNull(courseId) != null) {
      throw Exception("course $courseId is already exist.");
    }
    courses.add(Course(id: courseId, name: courseName));
  }

  void removeCourse({required String courseId}) {
    courses.removeWhere((c) => c.id == courseId);
  }

  void enrollStudentToCourse({required String studentId, required String courseId}) {
    Student? student = _findStudentOrNull(studentId);

    if (student != null) {
      for ( Course c in courses) { 
        if (c.id == courseId && c.studentIds == studentId ) {
          throw Exception("The student is already in this course.");
        } else {
          c.studentIds.add(studentId);
        }
      }
    } else {
      throw Exception("Student $studentId does not exists.");
    }
  }

  void discardStudentFromCourse ({required String studentId, required String courseId}) {
    Course? course = _findCourseOrNull(courseId);
    Student? student = _findStudentOrNull(studentId);

    if ( course != null && student != null) {
      for ( Course c in courses) {
        if ( c.id == courseId && c.studentIds == studentId ) {
          c.studentIds.remove(studentId);
          
        } else {
          throw Exception("The student $studentId is not in the course ${c.name}");
        }
      }
    } else if (course == null && student != null) {
      throw Exception("The course does not exist.");
    } else if (course != null && student == null) {
      throw Exception("The student does not exist.");
    } else {
      throw Exception("The course and student do not exist.");
    }
    
 
  }

  String addResult({
    required String studentId,
    required String courseId,
    required int score,
  }) {
    final student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId does not exist');
    }
    final course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception('Course $courseId does not exist');
    }
    if (!course.studentIds.contains(studentId)) {
      throw Exception('Student $studentId is not enrolled in $courseId');
    }
    if (score < 0 || score > 100) {
      throw Exception('Score must be between 0 and 100');
    };studentId: studentId, courseId: courseId, score: score));
    return id;
  }

  // void removeStudentFromCourse

  void addStudent({required String studentId, required String studentName}) {
    // ! Student shall not exist already
    Student? student = _findStudentOrNull(studentId);
    if (student != null) {
      throw Exception('Student $student already exists');
    }

    students.add(Student(id: studentId, name: studentName));
  }
 
  void removeStudent({required String studentId}) {
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }
    // 1- Remove student from the students list
    students.removeWhere((student) => student.id == studentId);
 
  }

  Student? _findStudentOrNull(String studentId) {
    for (Student s in students) {
      if (s.id == studentId) {
        return s;
      }
    }
    return null; // not found
  } 

  Course? _findCourseOrNull(String courseId) {
    for (Course c in courses) {
      if (c.id == courseId ) {
        return c;
      }
    }
    return null;
  }


}
