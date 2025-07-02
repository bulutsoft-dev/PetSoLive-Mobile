// Pet entity burada olacak 

import 'adoption_request.dart';
import 'pet_owner.dart';

class Pet {
  final int id;
  final String name;
  final String species;
  final String breed;
  final int age;
  final String gender;
  final double weight;
  final String color;
  final DateTime dateOfBirth;
  final String description;
  final String vaccinationStatus;
  final String microchipId;
  final bool? isNeutered;
  final String imageUrl;
  final List<AdoptionRequest> adoptionRequests;
  final List<PetOwner> petOwners;

  Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.gender,
    required this.weight,
    required this.color,
    required this.dateOfBirth,
    required this.description,
    required this.vaccinationStatus,
    required this.microchipId,
    this.isNeutered,
    required this.imageUrl,
    this.adoptionRequests = const [],
    this.petOwners = const [],
  });
} 