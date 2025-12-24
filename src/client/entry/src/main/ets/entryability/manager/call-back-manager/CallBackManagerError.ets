import { Event } from "./CallBackManager";

export class CallBackManagerError extends Error{
  constructor(message: string) {
    super("Call Back Manager Error: " + message);
  }
}

export class NoSuchEventSubscribedError extends CallBackManagerError{
  constructor(event: Event) {
    super("No Such Event Subscribed: " + event);
  }
}

export class EventAlreadySubscribedError extends CallBackManagerError{
  constructor(event: Event) {
    super("Event Already Subscribed: " + event);
  }
}