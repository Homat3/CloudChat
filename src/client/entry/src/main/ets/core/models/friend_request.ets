export interface FriendRequestInfo {
  id: number;
  requesterId: number;
  targetId: number;
  requesterUsername: string;
  targetUsername: string;
  requesterAvatar: string;
  targetAvatar: string;
  status: 'pending' | 'accepted' | 'refused';
}

export class FriendRequest implements FriendRequestInfo {
  id: number;
  requesterId: number;
  targetId: number;
  requesterUsername: string;
  targetUsername: string;
  requesterAvatar: string;
  targetAvatar: string;
  status: 'pending' | 'accepted' | 'refused';

  constructor(
    id: number,
    requestId: number,
    targetId: number,
    requesterUsername: string,
    targetUsername: string,
    requesterAvatar: string,
    targetAvatar: string,
    status: 'pending' | 'accepted' | 'refused'
  ) {
    this.id = id;
    this.requesterId = requestId;
    this.targetId = targetId;
    this.requesterUsername = requesterUsername;
    this.targetUsername = targetUsername;
    this.requesterAvatar = requesterAvatar;
    this.targetAvatar = targetAvatar;
    this.status = status;
  }
}
