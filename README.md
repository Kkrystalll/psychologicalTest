# Ruby on Rails 串接 LINE 快速構建心理測驗

本專案是根據我在 [2024 Hello World Dev Conference](https://hwdc.ithome.com.tw/2024/lab-page/3295) 擔任講者，並主持工作坊的經驗分享。

若需要工作坊詳細步驟內容，可以參考 [使用 Ruby on Rails 串接 LINE 快速構建心理測驗](https://kkrystalll.github.io/posts/rails-line-psychological-test/) 這篇文章。

## 使用技術

- Ruby version: 3.3.1
- Rails version: 7.1.4

## 自備裝置

- 創建[LINE 官方帳號](https://account.line.biz/login)(若還沒有建立可以參考[這篇文章](https://kkrystalll.github.io/posts/create-line-official-account/))

## 啟動專案

1. 安裝好 Ruby . Rails
2. 將 `.example.env` 檔名的檔案，改名為 `.env`，並填上需要的環境變數
3. 在終端機執行 `bundle install`，安裝相依套件
4. 在終端機執行 `rails db:migrate`，執行數據庫遷移，將變更寫進資料庫中
5. 在終端機執行 `rails s`，啟動專案
