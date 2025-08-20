class JobItem {
  JobItem({
    required this.id,
    required this.ownerToken,
    required this.title,
    required this.category,
    required this.frequency,
    this.skills = const <String>[],
    this.timeCommitment,
    this.timeOfDay,
    this.distanceMiles,
    this.startDate,
    this.endDate,
    this.description,
    this.status = JobStatus.published,
  });

  final String id;
  final String ownerToken;
  final String title;
  final String category;
  final String frequency;
  final List<String> skills;
  final String? timeCommitment;
  final String? timeOfDay;
  final int? distanceMiles;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? description;
  final JobStatus status;

  JobItem copyWith({
    String? title,
    String? category,
    String? frequency,
    List<String>? skills,
    String? timeCommitment,
    String? timeOfDay,
    int? distanceMiles,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    JobStatus? status,
  }) {
    return JobItem(
      id: id,
      ownerToken: ownerToken,
      title: title ?? this.title,
      category: category ?? this.category,
      frequency: frequency ?? this.frequency,
      skills: skills ?? this.skills,
      timeCommitment: timeCommitment ?? this.timeCommitment,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      distanceMiles: distanceMiles ?? this.distanceMiles,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }
}

enum JobStatus { draft, published, closed }


