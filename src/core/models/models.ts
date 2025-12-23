export class Contact {
  contactId: number;
  username: string;
  online: boolean;
  avatar: string;
  constructor(contactId: number, userName: string, online: boolean, avatar: string) {
    this.contactId = contactId;
    this.username = userName;
    this.online = online;
    this.avatar = avatar;
  }
}

export class User {
  userId: number;
  username: string;
  email: string;
  avatar: string;
  token?: string;

  constructor(userId: number, username: string, email: string, avatar: string, token?: string) {
    this.userId = userId;
    this.username = username;
    this.email = email;
    this.avatar = avatar;
    this.token = token;
  }
}
