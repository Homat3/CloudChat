
export interface Message {
  id: number;
  senderId: number;
  receiverId: number;
  content: string | string[];
  timestamp: string;
  status: 'sending' | 'sent' | 'read';
  type: 'text' | 'image' | 'file';
}

export class TextMessage implements Message {
  id: number;
  senderId: number;
  receiverId: number;
  content: string;
  timestamp: string;
  status: 'sending' | 'sent' | 'read';
  readonly type: 'text' | 'image' | 'file' = 'text';

  constructor(
    id: number,
    senderId: number,
    receiverId: number,
    content: string,
    timestamp: string,
    status: 'sending' | 'sent' | 'read' = 'sent'
  ) {
    this.id = id;
    this.senderId = senderId;
    this.receiverId = receiverId;
    this.content = content;
    this.timestamp = timestamp;
    this.status = status;
  }
}

export class ImageMessage implements Message {
  id: number;
  senderId: number;
  receiverId: number;
  content: string[];
  timestamp: string;
  status: 'sending' | 'sent' | 'read';
  readonly type: 'text' | 'image' | 'file' = 'image';

  constructor(
    id: number,
    senderId: number,
    receiverId: number,
    content: string[],
    timestamp: string,
    status: 'sending' | 'sent' | 'read' = 'sent'
  ){
    this.id = id;
    this.senderId = senderId;
    this.receiverId = receiverId;
    this.content = content;
    this.timestamp = timestamp;
    this.status = status;
  }
}

export class FileMessage implements Message {
  id: number;
  senderId: number;
  receiverId: number;
  content: string[];
  timestamp: string;
  status: 'sending' | 'sent' | 'read';
  readonly type: 'text' | 'image' | 'file' = 'file';

  constructor(
    id: number,
    senderId: number,
    receiverId: number,
    content: string[],
    timestamp: string,
    status: 'sending' | 'sent' | 'read' = 'sent'
  ){
    this.id = id;
    this.senderId = senderId;
    this.receiverId = receiverId;
    this.content = content;
    this.timestamp = timestamp;
    this.status = status;
  }
}
