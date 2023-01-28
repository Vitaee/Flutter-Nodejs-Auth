import register from './auth/register.js';
import login from './auth/login.js';
import getUser from './getUser.js';
export const registerUser = register;
export const loginUser = login;
export const currentUser = getUser;