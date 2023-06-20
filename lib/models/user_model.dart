import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_mate/models/location_model.dart';

class User extends Equatable {
  final String? id;
  final String name;
  final int age;
  final String gender;
  final List<dynamic> imageUrls;
  final List<dynamic> interests;
  final String bio;
  final String jobTitle;
  final double radius;
  final List<String>? swipeLeft;
  final List<String>? swipeRight;
  final List<Map<String, dynamic>>? matches;

  const User(
      {this.id,
      required this.name,
      required this.age,
      required this.gender,
      required this.imageUrls,
      required this.interests,
      required this.bio,
      required this.jobTitle,
      required this.radius,
      this.swipeRight,
      this.swipeLeft,
      this.matches});

  static User fromSnapshot(DocumentSnapshot snap) {
    User user = User(
        id: snap.id,
        name: snap['name'],
        age: snap['age'],
        gender: snap['gender'],
        imageUrls: snap['imageUrls'],
        interests: snap['interests'],
        bio: snap['bio'],
        jobTitle: snap['jobTitle'],
        radius: snap['radius'].toDouble(),
        swipeLeft: (snap['swipeLeft'] as List)
            .map((swipeLeft) => swipeLeft as String)
            .toList(),
        swipeRight: (snap['swipeRight'] as List)
            .map((swipeRight) => swipeRight as String)
            .toList(),
        matches: (snap['matches'] as List)
            .map((matches) => matches as Map<String, dynamic>)
            .toList());
    return user;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'imageUrls': imageUrls,
      'interests': interests,
      'bio': bio,
      'jobTitle': jobTitle,
      'radius': radius,
      'swipeLeft': swipeLeft,
      'swipeRight': swipeRight,
      'matches': matches
    };
  }

  User copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    List<dynamic>? imageUrls,
    List<dynamic>? interests,
    String? bio,
    String? jobTitle,
    double? radius,
    List<String>? swipeLeft,
    List<String>? swipeRight,
    List<Map<String, dynamic>>? matches,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      imageUrls: imageUrls ?? this.imageUrls,
      interests: interests ?? this.interests,
      bio: bio ?? this.bio,
      jobTitle: jobTitle ?? this.jobTitle,
      radius: radius ?? this.radius,
      swipeLeft: swipeLeft ?? this.swipeLeft,
      swipeRight: swipeRight ?? this.swipeRight,
      matches: matches ?? this.matches,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        age,
        gender,
        imageUrls,
        interests,
        bio,
        jobTitle,
        radius,
        swipeLeft,
        swipeRight,
        matches
      ];
}
