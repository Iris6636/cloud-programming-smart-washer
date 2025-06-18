# 🤖 WasherHelper — Amazon Lex V2 聊天機器人設定

本資料夾為 Amazon Lex V2 聊天機器人「WasherHelper」的完整匯出設定，支援自然語言查詢洗衣機狀態，可作為智慧洗衣機系統的對話介面元件。

---

## 📌 專案簡介

WasherHelper 是一個以中文為主要語言的對話式機器人，用於查詢可用的洗衣機資訊。使用者可以透過自然語言提問，例如：

- 「請幫我找一台目前沒人預約且最快可用的洗衣機」

機器人會透過 Amazon Lex V2 接收輸入，並呼叫 AWS Lambda 函數查詢後端（如 DynamoDB）資料，回覆使用者即時狀態。

---

## 🚀 使用方式（如何在 AWS Lex 匯入）

1. 前往 [Amazon Lex V2 控制台](https://console.aws.amazon.com/lexv2/)
2. 點選左側選單 `Bots` → `Import`
3. 上傳此資料夾中的 [`WasherHelper-export.zip`](./WasherHelper-export.zip)
4. 選擇匯入至新的 Bot 或取代現有 Bot
5. 匯入完成後即可在 Lex 介面中查看 intents、utterances、slot types 等設定

⚠️ **注意：**
- 若原先 Lambda 函數名稱與你的帳號中不同，請在匯入後手動重新指派。
- 匯入後可直接於 Lex console 進行模擬測試。
- 建議搭配 AWS Lambda + DynamoDB 使用。

---

## 🧩 系統架構（簡要說明）

[User Query]
↓
Amazon Lex V2 (WasherHelper)
↓（Fulfillment）
AWS Lambda Function
↓
DynamoDB 查詢洗衣機狀態
↓
Lex 回應使用者


---

## 🧪 測試語句範例（Utterances）

- 現在有洗衣機可以用嗎？
- 哪台洗衣機最先空出來？
- 請幫我找可以使用的洗衣機
- 還有空的洗衣機嗎？

---

## 🔧 相關資源與延伸整合

此 Lex Bot 預期搭配以下服務使用：

- AWS Lambda（查詢洗衣機狀態）
- AWS DynamoDB（儲存洗衣機使用狀態）
- AWS API Gateway（如需透過 HTTP 整合其他前端）
- AWS IoT Core（若有感測器同步洗衣機狀態）

---

若有任何建議或問題，歡迎提出 🙌
