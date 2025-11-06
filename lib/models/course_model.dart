import 'stream_model.dart';

// Main Course class for database/API interactions
class Course {
  final String? id;
  final String? universityId;
  String? name;
  String? abbreviation; // Short form of course name
  String? code;
  String? status; // 'draft' or 'published'
  List<CourseStream>? streams; // Associated streams
  String? department;
  String? degreeType;
  String? duration;
  String? modeOfStudy;
  String? level;
  double? fees;
  int? totalSeats;
  int? availableSeats;
  String? description;
  List<String>? eligibility;
  bool? isActive;
  bool? scholarshipAvailable;
  bool? placementSupport;
  DateTime? createdAt;
  DateTime? updatedAt;
  
  // Indian Education System Specific Fields
  String? specialization;
  String? accreditation; // NAAC, NBA, etc.
  String? approvedBy; // AICTE, UGC, MCI, etc.
  int? semesterCount;
  String? mediumOfInstruction;
  String? entranceExam; // JEE, NEET, CAT, etc.
  double? cutoffPercentage;
  List<String>? careerOptions;
  String? affiliatedUniversity;
  bool? internshipIncluded;
  bool? industryTieups;
  String? labFacilities;
  String? researchOpportunities;
  
  // Additional India-Specific Fields
  String? recognizedBy; // UGC, AICTE, MCI, DCI, BCI, PCI, INC, COA
  String? universityType; // Central, State, Deemed, Private
  String? courseType; // Regular, Distance, Part-time, Online
  int? yearOfEstablishment;
  String? state; // Location state
  String? city; // Location city
  double? averagePackage; // in LPA
  double? highestPackage; // in LPA
  int? placementPercentage;
  List<String>? topRecruiters;
  String? hostelFacility; // Available, Not Available, Separate for Boys/Girls
  double? hostelFees; // per year
  String? transportFacility;
  String? libraryFacility;
  String? sportsFacilities;
  String? medicalFacilities;
  List<String>? extracurricularActivities;
  String? nbaAccreditationValidity; // Till year
  String? naacGrade; // A++, A+, A, B++, etc.
  int? nirfRanking;
  String? autonomousStatus; // Yes/No
  List<String>? courseHighlights;
  String? admissionProcess;
  List<String>? documentsRequired;
  String? reservationPolicy; // SC/ST/OBC/EWS quotas
  String? feeStructure; // Detailed breakdown
  List<String>? scholarships; // Available scholarships
  String? loanFacility;
  String? alumniNetwork;
  int? facultyCount;
  String? facultyQualification;
  double? studentFacultyRatio;
  String? infrastructureRating;
  List<String>? collaborations; // International/National
  String? exchangePrograms;
  bool? industryVisits;
  bool? guestLectures;
  bool? workshops;
  bool? seminars;
  String? projectWork;
  String? examPattern; // Semester/Annual
  String? gradingSystem; // CGPA/Percentage
  String? attendanceRequirement;
  List<String>? courseOutcomes;
  String? jobProspects;
  String? higherStudyOptions;
  List<String>? certifications; // Additional certifications offered

  Course({
    this.id,
    this.universityId,
    this.name,
    this.abbreviation,
    this.code,
    this.status,
    this.streams,
    this.department,
    this.degreeType,
    this.duration,
    this.modeOfStudy,
    this.level,
    this.fees,
    this.totalSeats,
    this.availableSeats,
    this.description,
    this.eligibility,
    this.isActive,
    this.scholarshipAvailable,
    this.placementSupport,
    this.createdAt,
    this.updatedAt,
    this.specialization,
    this.accreditation,
    this.approvedBy,
    this.semesterCount,
    this.mediumOfInstruction,
    this.entranceExam,
    this.cutoffPercentage,
    this.careerOptions,
    this.affiliatedUniversity,
    this.internshipIncluded,
    this.industryTieups,
    this.labFacilities,
    this.researchOpportunities,
    this.recognizedBy,
    this.universityType,
    this.courseType,
    this.yearOfEstablishment,
    this.state,
    this.city,
    this.averagePackage,
    this.highestPackage,
    this.placementPercentage,
    this.topRecruiters,
    this.hostelFacility,
    this.hostelFees,
    this.transportFacility,
    this.libraryFacility,
    this.sportsFacilities,
    this.medicalFacilities,
    this.extracurricularActivities,
    this.nbaAccreditationValidity,
    this.naacGrade,
    this.nirfRanking,
    this.autonomousStatus,
    this.courseHighlights,
    this.admissionProcess,
    this.documentsRequired,
    this.reservationPolicy,
    this.feeStructure,
    this.scholarships,
    this.loanFacility,
    this.alumniNetwork,
    this.facultyCount,
    this.facultyQualification,
    this.studentFacultyRatio,
    this.infrastructureRating,
    this.collaborations,
    this.exchangePrograms,
    this.industryVisits,
    this.guestLectures,
    this.workshops,
    this.seminars,
    this.projectWork,
    this.examPattern,
    this.gradingSystem,
    this.attendanceRequirement,
    this.courseOutcomes,
    this.jobProspects,
    this.higherStudyOptions,
    this.certifications,
  });

  Course copyWith({
    String? id,
    String? universityId,
    String? name,
    String? abbreviation,
    String? code,
    String? status,
    List<CourseStream>? streams,
    String? department,
    String? degreeType,
    String? duration,
    String? modeOfStudy,
    String? level,
    double? fees,
    int? totalSeats,
    int? availableSeats,
    String? description,
    List<String>? eligibility,
    bool? isActive,
    bool? scholarshipAvailable,
    bool? placementSupport,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? specialization,
    String? accreditation,
    String? approvedBy,
    int? semesterCount,
    String? mediumOfInstruction,
    String? entranceExam,
    double? cutoffPercentage,
    List<String>? careerOptions,
    String? affiliatedUniversity,
    bool? internshipIncluded,
    bool? industryTieups,
    String? labFacilities,
    String? researchOpportunities,
  }) {
    return Course(
      id: id ?? this.id,
      universityId: universityId ?? this.universityId,
      name: name ?? this.name,
      abbreviation: abbreviation ?? this.abbreviation,
      code: code ?? this.code,
      status: status ?? this.status,
      streams: streams ?? this.streams,
      department: department ?? this.department,
      degreeType: degreeType ?? this.degreeType,
      duration: duration ?? this.duration,
      modeOfStudy: modeOfStudy ?? this.modeOfStudy,
      level: level ?? this.level,
      fees: fees ?? this.fees,
      totalSeats: totalSeats ?? this.totalSeats,
      availableSeats: availableSeats ?? this.availableSeats,
      description: description ?? this.description,
      eligibility: eligibility ?? this.eligibility,
      isActive: isActive ?? this.isActive,
      scholarshipAvailable: scholarshipAvailable ?? this.scholarshipAvailable,
      placementSupport: placementSupport ?? this.placementSupport,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      specialization: specialization ?? this.specialization,
      accreditation: accreditation ?? this.accreditation,
      approvedBy: approvedBy ?? this.approvedBy,
      semesterCount: semesterCount ?? this.semesterCount,
      mediumOfInstruction: mediumOfInstruction ?? this.mediumOfInstruction,
      entranceExam: entranceExam ?? this.entranceExam,
      cutoffPercentage: cutoffPercentage ?? this.cutoffPercentage,
      careerOptions: careerOptions ?? this.careerOptions,
      affiliatedUniversity: affiliatedUniversity ?? this.affiliatedUniversity,
      internshipIncluded: internshipIncluded ?? this.internshipIncluded,
      industryTieups: industryTieups ?? this.industryTieups,
      labFacilities: labFacilities ?? this.labFacilities,
      researchOpportunities: researchOpportunities ?? this.researchOpportunities,
    );
  }

  // Helper methods for status
  bool get isDraft => (status ?? 'draft') == 'draft';
  bool get isPublished => status == 'published';
  
  // Update status methods
  Course publish() => copyWith(status: 'published');
  Course saveToDraft() => copyWith(status: 'draft');
}

// Detailed course information class
class CourseDetails {
  final String department;
  String courseName;
  String courseCode;
  String duration;
  String eligibility;
  String careerProspectus;
  String description;
  String intake;
  String seats;
  bool isActive;
  bool scholarshipAvailable;
  String tuitionFee;
  String hostelFee;
  String admissionFee;
  String registrationFee;
  String miscFee;

  CourseDetails({
    required this.department,
    required this.courseName,
    required this.courseCode,
    required this.duration,
    required this.eligibility,
    required this.careerProspectus,
    required this.description,
    required this.intake,
    required this.seats,
    required this.isActive,
    required this.scholarshipAvailable,
    required this.tuitionFee,
    required this.hostelFee,
    required this.admissionFee,
    required this.registrationFee,
    required this.miscFee,
  });

  CourseDetails copyWith({
    String? department,
    String? courseName,
    String? courseCode,
    String? duration,
    String? eligibility,
    String? careerProspectus,
    String? description,
    String? intake,
    String? seats,
    bool? isActive,
    bool? scholarshipAvailable,
    String? tuitionFee,
    String? hostelFee,
    String? admissionFee,
    String? registrationFee,
    String? miscFee,
  }) {
    return CourseDetails(
      department: department ?? this.department,
      courseName: courseName ?? this.courseName,
      courseCode: courseCode ?? this.courseCode,
      duration: duration ?? this.duration,
      eligibility: eligibility ?? this.eligibility,
      careerProspectus: careerProspectus ?? this.careerProspectus,
      description: description ?? this.description,
      intake: intake ?? this.intake,
      seats: seats ?? this.seats,
      isActive: isActive ?? this.isActive,
      scholarshipAvailable: scholarshipAvailable ?? this.scholarshipAvailable,
      tuitionFee: tuitionFee ?? this.tuitionFee,
      hostelFee: hostelFee ?? this.hostelFee,
      admissionFee: admissionFee ?? this.admissionFee,
      registrationFee: registrationFee ?? this.registrationFee,
      miscFee: miscFee ?? this.miscFee,
    );
  }
}
