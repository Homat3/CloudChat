export class PermissionManagerError extends Error {
  constructor(message: string) {
    super("Permission Manager Error: " + message)
  }
}

export class PermissionRequestFailedError extends PermissionManagerError {
  constructor(message: string) {
    super("Permission Request Failed: " + message);
  }
}

export class PermissionGroupAlreadyExistError extends PermissionManagerError {
  constructor(groupName: string) {
    super("Permission Group Already Exist: " + groupName);
  }
}

export class NoSuchPermissionGroupError extends PermissionManagerError {
  constructor(groupName: string) {
    super("No Such Permission Group: " + groupName);
  }
}

export class NoSuchPermissionError extends PermissionManagerError {
  constructor(permission: string) {
    super("No Such Permission: " + permission);
  }
}

export class PermissionCheckFailedError extends PermissionManagerError {
  constructor(permission: string) {
    super("Permission Check Failed: " + permission);
  }
}