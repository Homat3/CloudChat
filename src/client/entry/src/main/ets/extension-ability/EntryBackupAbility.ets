import { hilog } from '@kit.PerformanceAnalysisKit'; //日志模块
import { BackupExtensionAbility, BundleVersion } from '@kit.CoreFileKit';

const DOMAIN = 0x0000;  //日志域

export default class EntryBackupAbility extends BackupExtensionAbility {
  //实现备份恢复能力
  async onBackup() {
    hilog.info(DOMAIN, 'testTag', 'onBackup ok');
    await Promise.resolve();
    //TODO 数据备份逻辑
  }

  async onRestore(bundleVersion: BundleVersion) {
    hilog.info(DOMAIN, 'testTag', 'onRestore ok %{public}s', JSON.stringify(bundleVersion));
    await Promise.resolve();
    //TODO 数据恢复逻辑
  }
}