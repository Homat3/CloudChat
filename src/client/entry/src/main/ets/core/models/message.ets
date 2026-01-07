export interface Message {
  id: number;
  senderId: number;
  receiverId: number;
  content: string;
  timestamp: string;
  status: 'sending' | 'sent' | 'read';
  type: 'text' | 'image' | 'file';
}

export interface AiMessage {
  id: string;
  role: 'user' | 'assistant',
  timestamp: string,
  content: string,
}