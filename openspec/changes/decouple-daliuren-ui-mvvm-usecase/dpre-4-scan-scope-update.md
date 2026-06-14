# DPRE-4: Boundary Scan Scope Update

## 背景

design.md 中的边界扫描（import boundary test）当前仅针对 `domain/services/calculators/**` 子目录。
然而，`KetiDataService` 和 `YuDingKetiMatchService` 位于 `domain/services/` 根层级，不在 calculators 子目录下。

## 变更

扫描范围必须从 `domain/services/calculators/**` 扩展为 `domain/services/**`（含所有子目录）。

### 受限导入列表（Presentation 层禁止导入）

| 路径模式 | 说明 |
|----------|------|
| `domain/services/calculators/**` | 计算器服务（原有范围） |
| `domain/services/keti_data_service.dart` | 课体数据服务（新增） |
| `domain/services/yuding_keti_match_service.dart` | 御定课体匹配服务（新增） |
| `domain/services/*.dart` | 服务根层级所有文件（新增） |
| `domain/repositories/**` | 领域仓库接口 |
| `data/repositories/**` | 数据层仓库实现 |
| `data/services/**` | 数据层服务 |
| `package:repository_interface_daliuren` | 仓库接口包 |

## 影响

- `test/architecture/import_boundary_test.dart` 的扫描正则已更新为 `domain/services`（无子路径限定）
- 后续新增的 `domain/services/` 下的服务自动纳入边界约束
