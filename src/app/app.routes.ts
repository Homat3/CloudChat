import {Routes} from '@angular/router';
import {ChatLayoutComponent} from './components/chat-layout/chat-layout.component';
import {LoginComponent} from './components/login/login.component';
import {SettingsComponent} from './components/settings/settings.component';
import {authGuard} from './core/guards/auth.guard';
import {RegisterComponent} from './components/register/register.component';
import {ProfileUpdateComponent} from './components/settings/profile-update.component';

export const routes: Routes = [
  { path: 'login', component: LoginComponent },
  { path: 'register', component: RegisterComponent},
  { path: 'settings', component: SettingsComponent, canActivate: [authGuard] },
  { path: 'profile-update', component: ProfileUpdateComponent, canActivate: [authGuard] },
  { path: '', component: ChatLayoutComponent, canActivate: [authGuard] }
];