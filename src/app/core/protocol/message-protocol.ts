export enum MessageType {
    // User
    LOGIN = 'LOGIN',
    LOGIN_SUCCESS = 'LOGIN_SUCCESS',
    LOGIN_FAILURE = 'LOGIN_FAILURE',
    REGISTER = 'REGISTER',
    REGISTER_SUCCESS = 'REGISTER_SUCCESS',
    REGISTER_FAILURE = 'REGISTER_FAILURE',
    UPDATE_PROFILE = 'UPDATE_PROFILE',
    PROFILE_UPDATED = 'PROFILE_UPDATED',
    LOGOUT = 'LOGOUT',

    // Contact
    LOAD_CONTACTS = 'LOAD_CONTACTS',
    CONTACTS_LOADED = 'CONTACTS_LOADED',
    ADD_CONTACT = 'ADD_CONTACT',
    CONTACT_ADDED = 'CONTACT_ADDED',
    DELETE_CONTACT = 'DELETE_CONTACT',
    CONTACT_DELETED = 'CONTACT_DELETED',
}

export interface FilePayload {
    fileName: string;
    content: string[]; // List of hex codes
    contactId: number;
}

export interface ProtocolMessage {
    type: MessageType;
    payload: any;
}
