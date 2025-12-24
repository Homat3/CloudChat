export class WindowStageManagerError extends Error{
  constructor(message: string) {
    super("Window Stage Manager Error: " + message)
  }
}

export class PageSwitchError extends WindowStageManagerError{
  constructor(message: string) {
    super("Page Switch Error: " + message);
  }
}