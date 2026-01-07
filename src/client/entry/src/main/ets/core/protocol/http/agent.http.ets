export namespace send {
  export interface CreateNewConversationPayload {
    username: string;
  }

  export interface DeleteConversationPayload {
    conversationId: string
  }

  export interface PostMessagePayload{
    conversationId: string,
    username: string,
    userId: number,
    message: string
  }
}

export namespace receive {
  export interface ConversationCreateSuccessPayload {
    conversationId: string,
    conversationName: string
  }

  export interface ReplyMessagePayload{
    role: 'user' | 'assistant',
    type: 'question' | 'answer',
    content: string,
  }
}