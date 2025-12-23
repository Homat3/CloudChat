import { localUnitTest, httpServiceTest, websocketServiceTest } from './LocalUnit.test';

export default function testsuite() {
  localUnitTest();
  httpServiceTest();
  websocketServiceTest();
}