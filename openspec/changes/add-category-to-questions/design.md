## Context

心理測驗系統目前使用 LINE Bot 進行互動，題目按 id 順序出題，答案以 `question_id` 為 key 存於 `results.answers` JSON 欄位。使用者回答完所有題目後，答案直接串接顯示。

現需支援分類機制：每個分類隨機抽一題、隨機順序出題、但結果按分類順序顯示。

## Goals / Non-Goals

**Goals:**
- 建立分類資料模型，支援分類名稱與順序
- 題目可歸屬於分類
- 測驗開始時，從每個有題目的分類隨機抽一題
- 出題順序隨機，但結果按分類 order 順序顯示
- 追蹤測驗進度（已答到第幾題）

**Non-Goals:**
- 分類的 CRUD UI（本次僅建立資料模型，管理介面另案處理）
- 一個分類出多題並計算多數決（未來擴充）
- 處理分類沒有題目的錯誤提示（暫時跳過該分類）

## Decisions

### 1. 資料模型設計

**決定**: 新增 `categories` 表，`questions` 加上 `category_id` 外鍵

**替代方案**:
- 在 question 上直接加 `category_name` 字串 → 無法統一管理順序，不採用

**Schema**:
```ruby
# categories
create_table :categories do |t|
  t.string :name, null: false
  t.integer :order, null: false
  t.timestamps
end

# questions - 新增欄位
add_reference :questions, :category, foreign_key: true
```

### 2. 測驗進度追蹤

**決定**: 在 `results` 新增 `question_sequence` (JSON array) 和 `current_index` (integer)

**替代方案**:
- 動態計算已回答分類 → 每次都要查詢，效能較差
- 用 session 存 → LINE Bot 是 stateless，不適合

**Schema**:
```ruby
# results - 新增欄位
add_column :results, :question_sequence, :json, default: []
add_column :results, :current_index, :integer, default: 0
```

### 3. 答案存儲方式

**決定**: `answers` 的 key 使用 `category_id`（而非 `question_id` 或 `category_order`）

**理由**:
- 分類身份穩定，即使 order 調整，舊資料仍可正確關聯
- 未來擴充多題多數決時，可存成 `{ category_id => [answers...] }`
- 方便按分類統計答案分布

**替代方案**:
- 用 `question_id` → 顯示時需額外查分類，且不利於未來多題擴充
- 用 `category_order` → 順序調整後舊資料語意會混亂

### 4. 題目抽選邏輯

**決定**: `start_test` 時預先產生完整題目序列

```ruby
# 虛擬碼
categories = Category.joins(:questions).distinct.order(:order)
sequence = categories.map { |c| c.questions.sample.id }
sequence.shuffle!  # 打亂出題順序
result.update(question_sequence: sequence, current_index: 0)
```

### 5. 結果顯示邏輯

**決定**: 顯示時按 `Category.order(:order)` 排序，取出對應答案串接

```ruby
# 虛擬碼
sorted_answers = Category.order(:order).map do |cat|
  result.answers[cat.id.to_s]
end.compact.join
```

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| 分類沒有題目會被跳過，可能導致結果長度不一致 | 暫時接受；未來可加驗證確保每個分類都有題目 |
| `question_sequence` 存的是 id，若題目被刪除會有問題 | 測驗進行中不應刪除題目；可加 soft delete |
| 舊的 Result 資料格式與新格式不相容 | 新欄位有 default 值，舊資料不影響；舊測驗結果維持原樣 |
