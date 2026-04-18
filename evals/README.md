# Evals

本目录按 [skill-creator](https://github.com/anthropics/skills) 的 evals.json schema 存放测试用例。

## 用法

修改任一命令或 reference 文档后，手动跑 `evals.json` 里的 7 条 prompt，对照 `expectations` 判断输出质量：

1. 在 Claude Code 里开新会话
2. 按 `evals.json` 里顺序逐条输入 prompt
3. 对照每条的 `expectations` 打分（通过 1 分 / 不通过 0 分 / 存疑 0.5 分）
4. 总通过率 < 80% → 检查最近改动，回退或修正

## 什么时候跑

- 改方法论 reference（`references/*.md`）后——必跑
- 改命令流程（`.claude/commands/*.md`）后——跑对应那一条
- 新增命令——为新命令加一条 eval
- 不放心 Claude 版本升级后输出是否稳定——对比跑一次

## 扩展

加新命令时，同步在 `evals.json` 里追加一条 `{ id, command, prompt, expected_output, expectations }`，保持每个命令至少一个 eval 覆盖。
