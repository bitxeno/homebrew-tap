# typed: strict
# frozen_string_literal: true

cask "guguclip" do
arch arm: "arm64", intel: "amd64"

    version "0.3.0"
    sha256 arm: "22618bb4d7598d4dbfdcfc9944570df4e20418bc0c2a5c5f1d8cf83ab78e9896", intel: "58290f6eb62b0e6f1c37fc4d575d2e1eac29ff70e8ba51642c8906f3588a7d60"

    url "https://github.com/bitxeno/GuguClip/releases/download/v0.3.0/GuguClip-0.3.0-darwin-#{arch}.zip"
  name "GuguClip"
  desc "Menu-bar clipboard manager with LAN sync"
  homepage "https://github.com/bitxeno/GuguClip"

  app "GuguClip.app"

  # 构建未公证（ad-hoc 签名）：装完立即去隔离，免掉首启的 Gatekeeper 拦截。
  # 直接从 Release 下载 zip 的用户不走这条路径，caveats 里保留手动方法。
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/GuguClip.app"]
  end

  caveats <<~EOS
    直接下载 zip 安装（不经 Homebrew）时，构建未做公证（ad-hoc 签名），
    首次启动若被 Gatekeeper 拦截：右键 App 选"打开"，或执行
      xattr -dr com.apple.quarantine /Applications/GuguClip.app
    Cmd+Shift+V 呼出与自动粘贴需要"辅助功能"权限，首次使用时按提示授予。
  EOS
end
