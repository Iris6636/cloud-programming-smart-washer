# config/ — IoT 憑證與設定目錄

此目錄用於存放 AWS IoT Core 的裝置憑證檔案。
**這些檔案不應上傳至 Git。**

This directory holds AWS IoT Core device certificates.
**These files must NOT be committed to Git.**

---

## 需要的檔案｜Required Files

```
config/
├── AmazonRootCA1_RSA.pem      # AWS Root CA 憑證
├── certificate.pem             # IoT 裝置憑證（從 AWS IoT Console 下載）
└── private.pem.key             # IoT 裝置私鑰（從 AWS IoT Console 下載）
```

## 如何取得｜How to Obtain

1. 登入 [AWS IoT Console](https://console.aws.amazon.com/iot/)（Region: us-east-1）
2. 前往 **Manage → All devices → Things → team06_IoT**
3. 選擇已附加的 Certificate
4. 下載 Root CA、Certificate、Private Key
5. 重新命名並放入此目錄

詳細步驟請見 [docs/iot_setup_guide.md](../docs/iot_setup_guide.md)。

## 安全提醒｜Security Notice

- `.gitignore` 已設定忽略 `*.pem` 與 `*.key` 檔案
- 切勿將憑證檔案分享或上傳至公開 repository
- 若憑證洩漏，請立即至 AWS IoT Console 撤銷（Revoke）該 Certificate
