export interface Message {
  id: number;
  sender: 'me' | 'other';
  content: string;
  timestamp: string;
  status: 'sending' | 'sent' | 'read';
  type: 'text' | 'image' | 'file';
}

export class MessageImpl implements Message {
  id: number;
  sender: 'me' | 'other';
  content: string;
  timestamp: string;
  status: 'sending' | 'sent' | 'read';
  type: 'text' | 'image' | 'file';

  constructor(
    id: number,
    sender: 'me' | 'other',
    content: string,
    timestamp: string,
    status: 'sending' | 'sent' | 'read' = 'sent',
    type: 'text' | 'image' | 'file' = 'text'
  ) {
    this.id = id;
    this.sender = sender;
    this.content = content;
    this.timestamp = timestamp;
    this.status = status;
    this.type = type;
  }
}