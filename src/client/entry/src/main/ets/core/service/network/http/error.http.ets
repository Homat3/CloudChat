import { NetworkServiceError } from '../error/NetWorkServiceError';

//在错误消息前添加前缀
export class HttpServiceError extends NetworkServiceError{
  constructor(message: string) {
    super("Http Service Error: " + message);
  }
}

export class PostServiceError extends HttpServiceError{
  constructor(message: string) {
    super("Post Error: " + message);
  }
}

export class GetServiceError extends HttpServiceError{
  constructor(message: string) {
    super("Get Error: " + message);
  }
}

export class PutServiceError extends HttpServiceError{
  constructor(message: string) {
    super("Put Error: " + message);
  }
}

export class DeleteServiceError extends HttpServiceError{
  constructor(message: string) {
    super("Delete Error: " + message);
  }
}