## Why

目前心理測驗的題目沒有分類機制，無法依分類出題或依分類順序呈現結果。需要新增分類功能，讓每次測驗從各分類隨機抽題，並在最後按分類順序組合答案顯示結果。

## What Changes

- 新增 `categories` 資料表，包含 `name`（分類名稱）和 `order`（顯示順序）
- `questions` 資料表新增 `category_id` 外鍵，建立分類與題目的關聯
- `results` 資料表新增 `question_sequence`（預先產生的題目序列）和 `current_index`（目前答題進度）
- `answers` 欄位的 key 改用 `category_id`（原為 `question_id`）
- `start_test` 改為從每個分類隨機抽一題，打亂順序後發送
- `handle_postback` 改用 `question_sequence` 和 `current_index` 追蹤進度
- 結果顯示改為按分類 `order` 排序答案後串接

## Capabilities

### New Capabilities

- `category-management`: 分類資料的 CRUD 與排序管理
- `category-based-testing`: 依分類抽題、追蹤進度、按分類順序顯示結果

### Modified Capabilities

（目前無既有 specs）

## Impact

- **Models**: 新增 `Category` model，修改 `Question`、`Result` model
- **Controllers**: 修改 `LineBotController` 的 `start_test` 和 `handle_postback`
- **Database**: 新增 migration 建立 `categories` 表、修改 `questions` 和 `results` 表
- **Rollback**: 若需回滾，移除 `categories` 表、移除 `questions.category_id`、移除 `results` 的新欄位，恢復原本的出題與顯示邏輯
