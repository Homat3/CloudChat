// src/main/ets/pages/register/register-service.ts
import {
  HttpClientMessage,
  HttpClientMessageType,
  RegisterPayload
} from '../../core/protocol/http/client.http.protocol';
import {
  HttpServiceMessage,
  HttpServiceMessageType,
  RegisterSuccessPayload,
  RegisterFailurePayload
} from '../../core/protocol/http/service.http.protocol';
import { HttpService } from '../../core/service/network/http/server.http';
import { User } from '../../core/models/models';
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@ohos.base';

// 注册结果类型
export interface RegisterResult {
  success: boolean;
  user?: User;  // 返回User对象
  error?: string;
}

export class RegisterService {
  private httpService: HttpService;

  constructor() {
    this.httpService = new HttpService("cloudchat.infinomat.com", "14514", false);
  }

  /**
   * 注册用户
   * @param username 用户名
   * @param password 密码
   * @param email 邮箱
   * @returns 注册结果
   */
  async register(username: string, password: string, email: string): Promise<RegisterResult> {
    return new Promise((resolve) => {
      // 构建符合协议的请求消息
      const registerMessage: HttpClientMessage = {
        type: HttpClientMessageType.REGISTER,
        payload: {
          username,
          password,
          email
        } as RegisterPayload
      };

      console.log('发送注册请求:', JSON.stringify(registerMessage));

      this.httpService.post('/test', registerMessage, (err: BusinessError, res: http.HttpResponse) => {
        if (err) {
          resolve({ success: false, error: '网络连接失败' });
          return;
        }

        try {
          const resultData = this.parseHttpResponse(res);
          console.log('注册响应数据:', resultData);

          // 解析为符合协议的响应消息
          const response: HttpServiceMessage = JSON.parse(resultData);
          console.log('解析后的响应对象:', response);

          if (res.responseCode === 200) {
            if (response.type === HttpServiceMessageType.REGISTER_SUCCESS) {
              const payload = response.payload as RegisterSuccessPayload;
              if (payload?.userId && payload?.token) {
                // 创建User对象
                const user = new User(
                  payload.userId,
                  payload.username,
                  payload.email,
                  payload.avatar || '',
                  payload.token
                );
                resolve({
                  success: true,
                  user: user
                });
                return;
              }
              resolve({ success: false, error: '服务器返回数据不完整' });
            } else if (response.type === HttpServiceMessageType.REGISTER_FAILURE) {
              const payload = response.payload as RegisterFailurePayload;
              const errorMsg = payload?.error || '注册失败';
              resolve({ success: false, error: errorMsg });
            } else {
              resolve({ success: false, error: '未知的响应类型' });
            }
          } else {
            resolve({ success: false, error: `服务器错误: ${res.responseCode}` });
          }
        } catch (parseError) {
          console.error('解析响应失败:', parseError);
          resolve({ success: false, error: '服务器响应格式错误' });
        }
      });
    });
  }

  /**
   * 将HTTP响应数据解析成字符串内容
   * @param res
   * @returns
   */
  private parseHttpResponse(res: http.HttpResponse): string {
    let resultData: string;

    if (typeof res.result === 'string') {
      resultData = res.result;
    } else if (res.result instanceof ArrayBuffer) {
      const uint8Array = new Uint8Array(res.result);
      resultData = '';
      for (let i = 0; i < uint8Array.length; i++) {
        resultData += String.fromCharCode(uint8Array[i]);
      }
    } else {
      resultData = JSON.stringify(res.result);
    }

    return resultData;
  }

  }