import { HttpClientMessageType, LoginByTokenPayload, LoginPayload } from '../../core/protocol/http/client.http.protocol'
import { HttpService } from '../../core/service/network/http/server.http';
import { LoginUserData } from './user-manager';
import { http } from '@kit.NetworkKit';
import { HttpServiceMessage, HttpServiceMessageType,
  LoginFailurePayload,
  LoginSuccessPayload } from '../../core/protocol/http/service.http.protocol';

//登录请求参数
interface LoginRequest{
  type : HttpClientMessageType;
  payload : LoginPayload;
}

//令牌登录
interface LoginByTokenRequest{
  type : HttpClientMessageType;
  payload : LoginByTokenPayload;
}

export interface LoginResult{
  success:boolean;
  userData ?: LoginUserData;
  error?:string;
}

/**
 * 登录用到的一些检验过程.
 */
export class LoginService{
  private httpService:HttpService;

  constructor() {
    this.httpService = new HttpService("cloudchat.Infinomat.com","14514",false);
  }

  /**
   * 账密登录的解决方式
   * @param username 用户名
   * @param password 密码
   * @returns
   */
  async passwordLogin(username:string,password:string):Promise<LoginResult>{
    return new Promise((resolve)=>{
      const loginRequest: LoginRequest ={
        type : HttpClientMessageType.LOGIN,
        payload : {username,password}
      };

      console.log('Send Request:',loginRequest);
      //发送http请求
      this.httpService.post('/login',loginRequest,(err:BusinessError,res:http.HttpResponse)=>{
        if(err){
          resolve({success:false,error:'http connected failed'});
          return;
        }
        //解析数据
        try {
          const resultData = this.parseHttpResponse(res);
          console.log('Password_login Response:', resultData);
          //解析相应结构
          const response: HttpServiceMessage = JSON.parse(resultData);
          console.log('Data After parse:', response);

          if (res.responseCode === 200) {
            if (response.type === HttpServiceMessageType.LOGIN_SUCCESS) {
              //断言为成功登录
              const payload = response.payload as LoginSuccessPayload;
              if (payload?.userId && payload?.token) {
                resolve({
                  success: true,
                  userData: {
                    userId: payload.userId,
                    username: payload.username || username,
                    token: payload.token,
                    avatar: payload.avatar || '',
                    email: payload.email
                  }
                });
                return;
              }
            //返回类型不完整
            resolve({ success: false, error: '服务器返回类型不完整' });
          } else if (response.type === HttpServiceMessageType.LOGIN_FAILURE) {
            const payload = response.payload as LoginFailurePayload;
            const errorMsg = payload?.error || '登录失败';
            resolve({ success: false, error: errorMsg });
          }
        }else{
            resolve({success:false,error:`服务器错误:${res.responseCode}`});
          }
        }catch(parseErr){
            console.error('解析响应失败:',parseErr);
        }
      });
    });
  }

  /**
   * 检验本地的Token登录
   * @param username
   * @param token
   * @returns
   */
  async tokenLogin(username:string,token:string):Promise<LoginResult>{
    return new Promise((resolve)=>{
      const loginByTokenRequest : LoginByTokenRequest = {
        type:HttpClientMessageType.LOGIN_BY_TOKEN,
        payload:{username,token} as LoginByTokenPayload
      };
      console.log('Send Token Request:',loginByTokenRequest);

      //发送http请求
      this.httpService.post('/login',loginByTokenRequest,(err:BusinessError,res:http.HttpResponse)=>{
        if(err){
          resolve({success:false,error:'网络连接错误'});
          return ;
        }
        try{
          const resultData = this.parseHttpResponse(res);
          console.log('Token_login response:',resultData);

          //解析JSON
          const response: HttpServiceMessage = JSON.parse(resultData);
          console.log('Data After parse:',response);

          if(res.responseCode === 200){
            if(response.type === HttpServiceMessageType.LOGIN_SUCCESS){
              const payload = response.payload as LoginSuccessPayload;
              if(payload?.userId && payload?.token){
                resolve({
                  success:true,
                  userData:{
                    userId : payload.userId,
                    username : payload.username,
                    token : payload.token,
                    avatar:payload.avatar,
                    email:payload.email
                  }
                });
                return;
              }
              resolve({success:false,error:'服务器数据不完整'});
            }else if(response.type === HttpServiceMessageType.LOGIN_FAILURE){
              const payload = response.payload as LoginFailurePayload;
              const errorMsg = payload?.error || 'Token 失效';
              resolve({success:false,error:errorMsg});
            }else{
              resolve({success:false,error:'响应类型错误'});
            }
          }else{
            resolve({success:false,error:`服务器错误${res.responseCode}`});
          }
        }catch(parseError){
          console.error('parse respond failure:',parseError);
          resolve({success:false,error:'服务器响应格式错误'})
        }
      });
    });
  }

  //解析http解析数据
  private parseHttpResponse(res:http.HttpResponse):string{
    let resultData : string;

    if(typeof res.result === 'string'){
        resultData = res.result;
    }else if(res.result instanceof ArrayBuffer){
      const http2str = new Uint8Array(res.result);//ArrayBuffer转换为字符串
      resultData = '';
      //加到结果中
      for(let i=0;i<http2str.length;i++){
        resultData += String.fromCharCode(http2str[i]);
      }
    }else{
      resultData = JSON.stringify(res.result);
    }

    return resultData;
  }
}