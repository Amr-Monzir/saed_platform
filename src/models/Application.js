export class Application {
  constructor({
    id,
    jobId,
    volunteerId,
    answers,
    status = 'pending', // 'pending', 'accepted', 'rejected'
  }) {
    this.id = id;
    this.jobId = jobId;
    this.volunteerId = volunteerId;
    this.answers = answers;
    this.status = status;
  }

  static fromObject(obj) {
    return new Application({ ...obj, status: obj.status ?? 'pending' });
  }
} 