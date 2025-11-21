import { Injectable } from '@angular/core';
import { Observable, Subject, BehaviorSubject } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class SocketService {
  private url = "ws://test.infinomat.com:14514";
  private isConnected = false;
  private socket: WebSocket | null = null;
  private messageSubject = new Subject<any>();
  private connectionStatusSubject = new BehaviorSubject<boolean>(false);
  private errorSubject = new Subject<string>();

  constructor() {
    this.connect();
  }

  connect() {
    try {
      this.socket = new WebSocket(this.url);

      this.socket.onopen = () => {
        this.isConnected = true;
        this.connectionStatusSubject.next(true);
        console.log('WebSocket连接已建立');
      };

      this.socket.onmessage = (event) => {
        try {
          const data = JSON.parse(event.data);
          this.messageSubject.next(data);
        } catch (e) {
          this.messageSubject.next(event.data);
        }
      };

      this.socket.onerror = (error) => {
        this.errorSubject.next('WebSocket连接发生错误');
        console.error('WebSocket错误:', error);
      };

      this.socket.onclose = (event) => {
        this.isConnected = false;
        this.connectionStatusSubject.next(false);
        console.log('WebSocket连接已关闭');

        if (!event.wasClean) {
          this.handleReconnection();
        }
      };
    } catch (error) {
      this.errorSubject.next('创建WebSocket连接时出错');
      console.error('创建WebSocket连接失败:', error);
    }
  }

  private handleReconnection() {
    setTimeout(() => {
      if (!this.isConnected) {
        console.log('尝试重新连接...');
        this.connect();
      }
    }, 5000);
  }

  public sendMessage(message: any) {
    if (this.isConnected && this.socket) {
      try {
        const messageStr = typeof message === 'string' ? message : JSON.stringify(message);
        this.socket.send(messageStr);
      } catch (error) {
        console.error('发送消息失败:', error);
      }
    } else {
      console.warn('WebSocket未连接，无法发送消息');
    }
  }

  public getMessages(): Observable<any> {
    return this.messageSubject.asObservable();
  }

  public getConnectionStatus(): Observable<boolean> {
    return this.connectionStatusSubject.asObservable();
  }

  public getConnectionErrors(): Observable<string> {
    return this.errorSubject.asObservable();
  }

  public isConnectedStatus(): boolean {
    return this.isConnected;
  }

  public disconnect() {
    if (this.socket) {
      this.socket.close();
      this.socket = null;
    }
    this.isConnected = false;
    this.connectionStatusSubject.next(false);
  }
}