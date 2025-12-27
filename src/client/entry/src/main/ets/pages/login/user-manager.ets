import { LoginSuccessPayload } from "../../core/protocol/http/service.http.protocol";

export type LoginUserData = LoginSuccessPayload;


export interface LocalTokenInfo {
  username: string;
  token: string;
}

export class UserManager {
  // 保存用户数据
  static saveUserData(userData: LoginSuccessPayload, rememberMe: boolean): void {
    try {
      console.log('保存用户数据', userData);

      AppStorage.setOrCreate('user_id', userData.userId);
      AppStorage.setOrCreate('username', userData.username);
      AppStorage.setOrCreate('user_token', userData.token);
      AppStorage.setOrCreate('user_email', userData.email || '');
      AppStorage.setOrCreate('user_avatar', userData.avatar);
      AppStorage.setOrCreate('is_logged_in', true);

      if (rememberMe) {
        AppStorage.setOrCreate('remembered_username', userData.username);
      } else {
        AppStorage.delete('remembered_username');
      }

      console.log('用户数据保存成功');
    } catch (err) {
      console.error('用户数据保存失败', err);
    }
  }

  /**
   * 检查是否存在本地的令牌
   */
  static hasLocalToken(): boolean {
    const username = AppStorage.get<string>('username');
    const token = AppStorage.get<string>('user_token');

    return !!(username && token);
  }

  /**
   * 获取本地的令牌
   */
  static getLocalTokenInfo(): LocalTokenInfo | null {
    const username = AppStorage.get<string>('username');
    const token = AppStorage.get<string>('user_token');

    if (username && token) {
      return { username, token };
    }
    return null;
  }

  // 获取记住的用户名
  static getRememberedUsername(): string | undefined {
    return AppStorage.get<string>('remembered_username');
  }

  // 清除用户数据（退出登录）
  static clearUserData(): void {
    AppStorage.delete('user_id');
    AppStorage.delete('username');
    AppStorage.delete('user_token');
    AppStorage.delete('user_email');
    AppStorage.delete('user_avatar');
    AppStorage.delete('is_logged_in');
    AppStorage.delete('remembered_username');
  }

  // 获取当前登录的用户ID
  static getUserId(): number | undefined {
    return AppStorage.get<number>('user_id');
  }

  // 获取当前登录的用户名
  static getCurrentUsername(): string | undefined {
    return AppStorage.get<string>('username');
  }

  // 获取当前登录的token
  static getCurrentToken(): string | undefined {
    return AppStorage.get<string>('user_token');
  }

  // 检查是否已登录
  static isLoggedIn(): boolean {
    return AppStorage.get<boolean>('is_logged_in') === true;
  }
}