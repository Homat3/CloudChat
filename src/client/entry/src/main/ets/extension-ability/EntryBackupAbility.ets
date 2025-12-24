import { hilog } from '@kit.PerformanceAnalysisKit'; //日志模块
import { BackupExtensionAbility, BundleVersion } from '@kit.CoreFileKit';

const DOMAIN = 0x0000;  //日志域

export default class EntryBackupAbility extends BackupExtensionAbility {
  //实现备份恢复能力
  async onBackup() {
    hilog.info(DOMAIN, 'testTag', 'onBackup ok');
    try {
      const backupDir = this.context.filesDir + "/backup/";
      await fileIo.mkdir(backupDir);

      // 备份数据库
      const dbFile = this.context.filesDir + "/RAG.db";
      const backupFile = backupDir + "RAG_backup.db";
      await fileIo.copy(dbFile, backupFile);

      hilog.info(DOMAIN, 'testTag', 'Database backup completed: %{public}s', backupFile);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Backup failed: %{public}s', JSON.stringify(err));
    }
  }

  async onRestore(bundleVersion: BundleVersion) {
    hilog.info(DOMAIN, 'testTag', 'onRestore ok %{public}s', JSON.stringify(bundleVersion));
    try {
      const backupFile = this.context.filesDir + "/backup/RAG_backup.db";
      const dbFile = this.context.filesDir + "/RAG.db";

      // 恢复前备份当前数据库
      const tempBackup = dbFile + ".temp";
      await fileIo.copy(dbFile, tempBackup);

      // 执行恢复操作
      await fileIo.copy(backupFile, dbFile);

      hilog.info(DOMAIN, 'testTag', 'Database restore completed');
      await fileIo.unlink(tempBackup);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Restore failed: %{public}s', JSON.stringify(err));
      // 恢复失败时回滚
      if (await fileIo.access(tempBackup)) {
        await fileIo.copy(tempBackup, dbFile);
        await fileIo.unlink(tempBackup);
      }
    }
  }
}