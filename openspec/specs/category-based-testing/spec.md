## ADDED Requirements

### Requirement: Random question selection per category
測驗開始時，系統 SHALL 從每個有題目的分類中隨機抽取一題。

#### Scenario: One question per category
- **GIVEN** 分類 A 有題目 Q1、Q4、Q7，分類 B 有題目 Q2、Q5，分類 C 有題目 Q3、Q6
- **WHEN** 使用者開始測驗
- **THEN** 系統 SHALL 從 A 隨機抽 1 題、從 B 隨機抽 1 題、從 C 隨機抽 1 題

#### Scenario: Skip empty categories
- **GIVEN** 分類 A 有題目，分類 B 沒有題目，分類 C 有題目
- **WHEN** 使用者開始測驗
- **THEN** 系統 SHALL 僅從 A 和 C 抽題，跳過 B

### Requirement: Randomized question order
出題順序 SHALL 為隨機，不依照分類順序。

#### Scenario: Questions presented in random order
- **GIVEN** 從分類 A、B、C 各抽出題目 Q7、Q2、Q6
- **WHEN** 題目序列產生
- **THEN** 出題順序 SHALL 為隨機排列（例如 Q2、Q6、Q7）

### Requirement: Test progress tracking
系統 SHALL 追蹤測驗進度，記錄題目序列和目前答題位置。

#### Scenario: Store question sequence
- **GIVEN** 使用者開始測驗
- **WHEN** 題目序列產生為 [7, 2, 6]
- **THEN** 系統 SHALL 將 question_sequence 存為 [7, 2, 6]，current_index 設為 0

#### Scenario: Progress to next question
- **GIVEN** 使用者的 question_sequence 為 [7, 2, 6]，current_index 為 0
- **WHEN** 使用者回答第一題
- **THEN** 系統 SHALL 將 current_index 更新為 1，並發送 question_sequence[1] 的題目

#### Scenario: Test completion
- **GIVEN** 使用者的 question_sequence 為 [7, 2, 6]，current_index 為 2
- **WHEN** 使用者回答最後一題
- **THEN** 系統 SHALL 顯示測驗結果

### Requirement: Answer storage by category
系統 SHALL 以 category_id 為 key 儲存答案。

#### Scenario: Store answer with category_id
- **GIVEN** 使用者回答題目 Q7，Q7 屬於分類 A (id: 5)
- **WHEN** 答案為 "X"
- **THEN** 系統 SHALL 將答案存為 `{ "5" => "X" }`

### Requirement: Result display by category order
顯示結果時，系統 SHALL 按分類的 `order` 順序排列答案後串接。

#### Scenario: Answers ordered by category order
- **GIVEN** 分類 A (id: 5, order: 1)、B (id: 3, order: 2)、C (id: 8, order: 3)
- **GIVEN** 答案為 `{ "5" => "X", "3" => "Y", "8" => "Z" }`
- **WHEN** 顯示測驗結果
- **THEN** 系統 SHALL 顯示 "XYZ"（按 order 1, 2, 3 排序）

#### Scenario: Answers ordered correctly even if answered out of order
- **GIVEN** 使用者以 B → C → A 的順序回答
- **GIVEN** 答案為 `{ "5" => "X", "3" => "Y", "8" => "Z" }`
- **WHEN** 顯示測驗結果
- **THEN** 系統 SHALL 仍顯示 "XYZ"（按分類 order 排序，非作答順序）
