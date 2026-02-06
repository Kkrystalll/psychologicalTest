## ADDED Requirements

### Requirement: Category data model
系統 SHALL 提供分類資料模型，包含分類名稱和顯示順序。

#### Scenario: Category has required attributes
- **GIVEN** 分類資料模型已建立
- **WHEN** 建立新分類
- **THEN** 分類 SHALL 包含 `name` (string) 和 `order` (integer) 欄位

### Requirement: Category-Question relationship
系統 SHALL 建立分類與題目的一對多關聯，一個分類可以有多個題目。

#### Scenario: Question belongs to category
- **GIVEN** 存在分類 A
- **WHEN** 建立題目並指定 category_id 為分類 A
- **THEN** 該題目 SHALL 屬於分類 A

#### Scenario: Category has many questions
- **GIVEN** 分類 A 下有題目 Q1、Q2、Q3
- **WHEN** 查詢分類 A 的題目
- **THEN** SHALL 回傳 Q1、Q2、Q3

### Requirement: Category ordering
系統 SHALL 支援依 `order` 欄位排序分類。

#### Scenario: Categories sorted by order
- **GIVEN** 存在分類 A (order: 2)、B (order: 1)、C (order: 3)
- **WHEN** 查詢所有分類並依 order 排序
- **THEN** SHALL 回傳順序為 B、A、C
