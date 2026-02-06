## 1. Database Schema

- [x] 1.1 建立 categories 資料表 migration（name: string, order: integer）
- [x] 1.2 新增 questions 資料表的 category_id 欄位 migration
- [x] 1.3 新增 results 資料表的 question_sequence (json) 和 current_index (integer) 欄位 migration
- [x] 1.4 執行 db:migrate

## 2. Models

- [x] 2.1 建立 Category model，加入 has_many :questions 關聯
- [x] 2.2 修改 Question model，加入 belongs_to :category 關聯
- [x] 2.3 修改 Result model，確認 question_sequence 和 current_index 欄位可用

## 3. LineBotController - start_test

- [x] 3.1 修改 start_test：取得所有有題目的分類
- [x] 3.2 修改 start_test：從每個分類隨機抽一題，產生題目序列
- [x] 3.3 修改 start_test：打亂題目順序
- [x] 3.4 修改 start_test：儲存 question_sequence 和 current_index 到 result
- [x] 3.5 修改 start_test：發送 question_sequence[0] 的題目

## 4. LineBotController - handle_postback

- [x] 4.1 修改 handle_postback：以 category_id 為 key 儲存答案
- [x] 4.2 修改 handle_postback：更新 current_index
- [x] 4.3 修改 handle_postback：用 question_sequence 和 current_index 判斷下一題
- [x] 4.4 修改 handle_postback：結果顯示改為按分類 order 排序答案後串接
