export class Volunteer {
  constructor({
    id,
    name,
    email,
    skills,
    description,
    nickname,
    rating = 0,
    // Add more fields as needed
  }) {
    this.id = id;
    this.name = name;
    this.email = email;
    this.skills = skills;
    this.description = description;
    this.nickname = nickname;
    this.rating = rating;
  }

  static fromObject(obj) {
    return new Volunteer({ ...obj, rating: obj.rating ?? 0 });
  }
} 