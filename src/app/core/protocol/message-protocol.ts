export interface FilePayload {
    fileName: string;
    content: string[]; // List of hex codes
    contactId: number;
}

export interface ProtocolMessage {
    payload: any;
}
