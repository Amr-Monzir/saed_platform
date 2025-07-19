export class Job {
  constructor({
    id,
    organizationId,
    title,
    description,
    category,
    frequency,
    skills,
    timeCommitment,
    location,
    locationType,
    volunteersNeeded,
    startDate,
    startTime,
    deadline,
    screeningQuestions,
    archived = false,
  }) {
    this.id = id;
    this.organizationId = organizationId;
    this.title = title;
    this.description = description;
    this.category = category;
    this.frequency = frequency;
    this.skills = skills;
    this.timeCommitment = timeCommitment;
    this.location = location;
    this.locationType = locationType;
    this.volunteersNeeded = volunteersNeeded;
    this.startDate = startDate;
    this.startTime = startTime;
    this.deadline = deadline;
    this.screeningQuestions = screeningQuestions;
    this.archived = archived;
  }

  static fromObject(obj) {
    return new Job({ ...obj, archived: obj.archived ?? false });
  }
} 