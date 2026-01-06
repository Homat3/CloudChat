export namespace send{
  export interface CreateNewConversationPayload{
    username: string;
  }
}

export namespace receive{
  export interface ConversationCreateSuccessPayload{
    id: string,
    name: string
  }
}