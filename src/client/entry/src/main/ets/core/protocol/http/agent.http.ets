export namespace send {
  export interface CreateNewConversationPayload {
    username: string;
  }

  export interface DeleteConversationPayload {
    conversationId: string
  }
}

export namespace receive {
  export interface ConversationCreateSuccessPayload {
    conversationId: string,
    conversationName: string
  }
}