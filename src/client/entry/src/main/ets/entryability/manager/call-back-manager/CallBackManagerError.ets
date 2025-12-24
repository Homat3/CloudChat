export class CallBackManagerError extends Error{
  constructor(message: string) {
    super("Call Back Manager Error: " + message);
  }
}