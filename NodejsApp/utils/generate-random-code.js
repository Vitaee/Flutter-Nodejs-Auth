import { generate } from 'randomstring';

export default () => generate({ length: 4, charset: 'numeric' });