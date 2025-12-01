export interface User {
  userId: string;
  username: string;
  email: string;
  avatar: string;
  token?: string;
}

export function isUser(obj: any): boolean {
  return obj.id && obj.username && obj.email && obj.avatar;
}
