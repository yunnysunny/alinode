import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
const ENV = process.env;

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  await app.listen(ENV.APP_PORT || 8000);
}
async function bootstrap2() {
  const app = await NestFactory.create(AppModule);
  await app.listen(8001);
}
bootstrap();
bootstrap2();
