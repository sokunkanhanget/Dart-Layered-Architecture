import 'package:lms_layered_architecture_example/model/course.dart';
import 'package:lms_layered_architecture_example/model/course_result.dart';
import '../model/student.dart';

class LmsSystem {
  final List<Student> students = [];
  final List<Course> courses = [];
  final List<CourseResult> results =[];
 
  void addCourse({required String courseId, required courseName }) {
    if (_findCourseOrNull(courseId) != null) {
      throw Exception("course $courseId is already exist.");
    }
    courses.add(Course(id: courseId, name: courseName));
  }

  void removeCourse({required String courseId}) {
    Course? course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception('Course does not exist');
    }
    if (course.studentIds.isNotEmpty) {
      throw Exception('Cannot remove a course with students');
    }
    for (CourseResult r in results) {
      if (r.courseId == courseId) {
        throw Exception('Cannot remove a course with results');
      }
    }
    courses.removeWhere((c) => c.id == courseId);
  }

  void enrollStudentToCourse({required String studentId, required String courseId}) {
    Student? student = _findStudentOrNull(studentId);
    Course? course = _findCourseOrNull(courseId);

    if (student == null) {
      throw Exception('Student does not exist');
    }

    if (course == null) {
      throw Exception('Course does not exist');
    }

    if (course.studentIds.contains(studentId)) {
      throw Exception('Student is already enrolled');
    }
    course.studentIds.add(studentId);

  }

  void discardStudentFromCourse ({required String studentId, required String courseId}) {
    Course? course = _findCourseOrNull(courseId);
    Student? student = _findStudentOrNull(studentId);

    if (student == null) {
      throw Exception('Student does not exist');
    }

    if (course == null) {
      throw Exception('Course does not exist');
    }

    if (!course.studentIds.contains(studentId)) {
      throw Exception('Student is not enrolled');
    }
    course.studentIds.remove(studentId);
    results.removeWhere(
      (r) => r.studentId == studentId && r.courseId == courseId,
    );
  }

  void addResult({required String studentId, required String courseId, required int score,}) {
    Student? student = _findStudentOrNull(studentId);
    Course? course = _findCourseOrNull(courseId);

    if (student == null) {
      throw Exception('Student $studentId does not exist');
    }

    if (course == null) {
      throw Exception('Course $courseId does not exist');
    }
    if (!course.studentIds.contains(studentId)) {
      throw Exception('Student $studentId is not enrolled in $courseId');
    }
    if (score < 0 || score > 100) {
      throw Exception('Score must be between 0 and 100');
    }

    for (CourseResult r in results) {
      if (r.studentId == studentId && r.courseId == courseId) {
        throw Exception('Result already exists');
      }
    }

    results.add(CourseResult(
      id: '${studentId}_$courseId',
      studentId: studentId,
      courseId: courseId,
      score: score,
    ));

  }

  // void removeStudentFromCourse
  void removeResult({required String resultId}) {
    bool exists = false;
    for (CourseResult r in results) {
      if (r.id == resultId) {
        exists = true;
      }
    }

    if (!exists) {
      throw Exception('Result does not exist');
    }

    results.removeWhere((r) => r.id == resultId);
  }

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

