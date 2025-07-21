export class Organization {
  constructor({
    id,
    name,
    email,
    description,
    // Add more fields as needed
  }) {
    this.id = id;
    this.name = name;
    this.email = email;
    this.description = description;
  }

  static fromObject(obj) {
    return new Organization(obj);
  }
} 