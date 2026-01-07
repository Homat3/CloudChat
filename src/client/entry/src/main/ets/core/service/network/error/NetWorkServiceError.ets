export class NetworkServiceError extends Error {
  constructor(message: string) {
    super("Network Service Error: " + message);
  }
}