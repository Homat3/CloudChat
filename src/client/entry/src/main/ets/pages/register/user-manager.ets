// src/
import { User } from '../../core/models/models';
import { LoginSuccessPayload, RegisterSuccessPayload } from '../../core/protocol/http/service.http.protocol';

export interface LocalTokenInfo {
  username: string;
  token: string;
}

export class UserManager {
  /**
   * 保存用户数据 - 使用User模型
   * @param userData 用户数据（可以是LoginSuccessPayload或RegisterSuccessPayload）
   * @param rememberMe 是否记住用户名
   */
  static saveUserData(
    userData: LoginSuccessPayload | RegisterSuccessPayload,
    rememberMe: boolean
  ):void {
    try {
      console.log('保存用户数据:', userData);

      // 创建User对象
      const user = new User(
        userData.userId,
        userData.username,
        userData.email,
        userData.avatar,
        userData.token
      );

      // 保存到AppStorage
      AppStorage.setOrCreate('user_id', user.userId);
      AppStorage.setOrCreate('username', user.username);
      AppStorage.setOrCreate('user_token', user.token);
      AppStorage.setOrCreate('user_email', user.email);
      AppStorage.setOrCreate('user_avatar', user.avatar);
      AppStorage.setOrCreate('is_logged_in', true);

      if (rememberMe) {
        AppStorage.setOrCreate('remembered_username', user.username);
      } else {
        AppStorage.delete('remembered_username');
      }

      console.log('用户数据保存成功，User对象:', user);
    } catch (err) {
      console.error('用户数据保存失败:', err);
    }
  }

  /**
   * 获取本地保存的用户名和令牌
   */
  static getLocalTokenInfo(): LocalTokenInfo | null {
    const username= AppStorage.get<string>('username');
    const token= AppStorage.get<string>('user_token');

    if (username && token) {
      return { username, token };
    }
    return null;
  }

  /**
   * 获取记住的用户名
   */
  static getRememberedUsername(): string | undefined {
    return AppStorage.get<string>('remembered_username');
  }

  /**
   * 从本地存储获取当前登录的User对象
   */
  static getCurrentUser(): User | null {
    try {
      const userId = AppStorage.get<number>('user_id');
      const username = AppStorage.get<string>('username');
      const email = AppStorage.get<string>('user_email');
      const avatar = AppStorage.get<string>('user_avatar');
      const token = AppStorage.get<string>('user_token');

      if (userId && username && token) {
        return new User(userId, username, email || '', avatar || '', token);
      }
      return null;
    } catch (error) {
      console.error('获取当前用户失败:', error);
      return null;
    }
  }

  /**
   * 检查是否已登录
   */
  static isLoggedIn(): boolean {
    return AppStorage.get<boolean>('is_logged_in') === true;
  }

  /**
   * 清除用户数据（退出登录）
   */
  static clearUserData(): void {
    AppStorage.delete('user_id');
    AppStorage.delete('username');
    AppStorage.delete('user_token');
    AppStorage.delete('user_email');
    AppStorage.delete('user_avatar');
    AppStorage.delete('is_logged_in');
    AppStorage.delete('remembered_username');
  }
}