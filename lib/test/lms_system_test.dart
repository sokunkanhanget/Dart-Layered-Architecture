import 'package:test/test.dart';

import '../service/lms_system.dart';

void main() {

  test('Add and remove course', () {
    final lms = LmsSystem();

    lms.addCourse(courseId: 'C1', courseName: 'Dart');

    expect(lms.courses.length, 1);

    lms.removeCourse(courseId: 'C1');

    expect(lms.courses.length, 0);
  });

  test('Reject duplicate course', () {
    final lms = LmsSystem();

    lms.addCourse(courseId: 'C1', courseName: 'Dart');

    expect(
      () => lms.addCourse(courseId: 'C1', courseName: 'Java'),
      throwsException,
    );
  });

  test('Reject removing nonexistent course', () {
    final lms = LmsSystem();

    expect(
      () => lms.removeCourse(courseId: 'C1'),
      throwsException,
    );
  });

  test('Enroll student in course', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: 'Ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Dart');

    lms.enrollStudentToCourse(
      studentId: 'S1',
      courseId: 'C1',
    );

    expect(lms.courses.first.studentIds, contains('S1'));
  });

  test('Reject duplicate enrollment', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: 'Ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Dart');

    lms.enrollStudentToCourse(
      studentId: 'S1',
      courseId: 'C1',
    );

    expect(
      () => lms.enrollStudentToCourse(
        studentId: 'S1',
        courseId: 'C1',
      ),
      throwsException,
    );
  });

  test('Reject enrollment with nonexistent student', () {
    final lms = LmsSystem();

    lms.addCourse(courseId: 'C1', courseName: 'Dart');

    expect(
      () => lms.enrollStudentToCourse(
        studentId: 'S1',
        courseId: 'C1',
      ),
      throwsException,
    );
  });

    test('Remove enrollment but keep student and course', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: 'Ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Dart');

    lms.enrollStudentToCourse(
      studentId: 'S1',
      courseId: 'C1',
    );

    lms.discardStudentFromCourse(
      studentId: 'S1',
      courseId: 'C1',
    );

    expect(lms.courses.first.studentIds, isEmpty);
    expect(lms.students.length, 1);
    expect(lms.courses.length, 1);
  });

  test('Reject removing nonexistent enrollment', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: 'Ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Dart');

    expect(
      () => lms.discardStudentFromCourse(
        studentId: 'S1',
        courseId: 'C1',
      ),
      throwsException,
    );
  });

  test('Remove result', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: 'Ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Dart');

    lms.enrollStudentToCourse(
      studentId: 'S1',
      courseId: 'C1',
    );

    lms.addResult(
      studentId: 'S1',
      courseId: 'C1',
      score: 85,
    );

    lms.removeResult(resultId: 'S1_C1');

    expect(lms.results, isEmpty);
    expect(lms.students.length, 1);
    expect(lms.courses.length, 1);
  });

  test('Reject removing nonexistent result', () {
    final lms = LmsSystem();

    expect(
      () => lms.removeResult(resultId: 'wrong'),
      throwsException,
    );
  });

    test('Add a valid result', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: 'Ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Dart');

    lms.enrollStudentToCourse(
      studentId: 'S1',
      courseId: 'C1',
    );

    lms.addResult(
      studentId: 'S1',
      courseId: 'C1',
      score: 85,
    );

    expect(lms.results.first.score, 85);
  });

  test('Reject invalid score', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: 'Ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Dart');

    lms.enrollStudentToCourse(
      studentId: 'S1',
      courseId: 'C1',
    );

    expect(
      () => lms.addResult(
        studentId: 'S1',
        courseId: 'C1',
        score: 101,
      ),
      throwsException,
    );
  });

  test('Reject duplicate result', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: 'Ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Dart');

    lms.enrollStudentToCourse(
      studentId: 'S1',
      courseId: 'C1',
    );

    lms.addResult(
      studentId: 'S1',
      courseId: 'C1',
      score: 85,
    );

    expect(
      () => lms.addResult(
        studentId: 'S1',
        courseId: 'C1',
        score: 90,
      ),
      throwsException,
    );
  });

  test('Removing student also removes enrollments and results', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: 'Ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Dart');

    lms.enrollStudentToCourse(
      studentId: 'S1',
      courseId: 'C1',
    );

    lms.addResult(
      studentId: 'S1',
      courseId: 'C1',
      score: 85,
    );

    lms.removeStudent(studentId: 'S1');

    expect(lms.students, isEmpty);
    expect(lms.courses.first.studentIds, isEmpty);
    expect(lms.results, isEmpty);
  });


  test('creates a student', () {
    final lms = LmsSystem();

    // Create a student
    lms.addStudent(studentId: 'S1', studentName: "ronan");

    expect(lms.students.first.name, 'ronan');

    // Remove the student
    lms.removeStudent(studentId: 'S1');
    expect(lms.students.length, 0);
  });


 }
