# bitxeno/homebrew-tap

自定义 Homebrew tap，cask 由 [dsh-dock](https://github.com/bitxeno/dsh-dock)
的 release workflow 自动更新（`.github/workflows/release.yml`）。

## 安装

```bash
brew install --cask bitxeno/tap/dshdock
```

## 手动更新

若自动推送不可用，从 dsh-dock 最新 Release 资产里下载 `dshdock.rb`，
覆盖 `Casks/dshdock.rb` 并提交即可。
