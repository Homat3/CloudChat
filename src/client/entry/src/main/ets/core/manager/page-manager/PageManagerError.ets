export class PageManagerError extends Error{
  constructor(message: string) {
    super("Page Manager Error: " + message)
  }
}

export class PageSwitchError extends PageManagerError{
  constructor(message: string) {
    super("Page Switch Error: " + message);
  }
}