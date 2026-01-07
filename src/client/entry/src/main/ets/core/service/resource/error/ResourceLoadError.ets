export class ResourceLoadError extends Error {
  constructor(message: string) {
    super("Resource Load Error: " + message)
  }
}

export class StringResourceLoadError extends ResourceLoadError {
  constructor(resourceName: string) {
    super("String Resource: " + resourceName)
  }
}

export class ColorResourceLoadError extends ResourceLoadError {
  constructor(resourceName: string) {
    super("Color Resource: " + resourceName)
  }
}

export class FloatResourceLoadError extends ResourceLoadError {
  constructor(resourceName: string) {
    super("Float Resource: " + resourceName)
  }
}