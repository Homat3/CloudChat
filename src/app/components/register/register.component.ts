import {Component, OnInit} from '@angular/core';
import {CommonModule} from '@angular/common';
import {FormsModule} from '@angular/forms';
import {Router} from '@angular/router';
import {RequestService} from '../../core/services/request.service';
import {AuthService} from '../../core/services/auth.service';

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.css']
})
export class RegisterComponent implements OnInit {
  username = '';
  password = '';
  password_repeat = '';
  email = '';
  isLoading = false;
  errorMessage = '';
  
  private registerTimeout: any;

  constructor(
    private router: Router,
    private requestService: RequestService,
    private authService: AuthService
  ) { }

  ngOnInit(): void {
    if (this.authService.currentUserValue) {
      this.router.navigate(['/']);
    }
  }

  onRegister(): void {
    if (!this.username || !this.password) {
      this.errorMessage = '请输入用户名和密码';
      return;
    }

    if (this.password != this.password_repeat) {
      this.errorMessage = '两次输入密码不一致';
      return;
    }

    if (!this.email) {
      this.errorMessage = '请输入邮箱';
      return;
    }

    this.isLoading = true;
    this.errorMessage = '';

    this.requestService.register(
      { username: this.username, password: this.password, email: this.email },
      () => {
        this.isLoading = false;
        // Navigation is handled in AuthService
        if (this.registerTimeout) {
          clearTimeout(this.registerTimeout);
          this.registerTimeout = null;
        }
      },
      (error) => {
        this.isLoading = false;
        this.errorMessage = error;
        if (this.registerTimeout) {
          clearTimeout(this.registerTimeout);
          this.registerTimeout = null;
        }
      }
    );


    this.registerTimeout = setTimeout(() => {
      if (!this.authService.currentUserValue && !this.errorMessage) {
        this.isLoading = false;
        this.errorMessage = '注册超时，请重试';
      }
      this.registerTimeout = null;
    }, 5000);
  }
  
  ngOnDestroy(): void {
    if (this.registerTimeout) {
      clearTimeout(this.registerTimeout);
    }
  }
}