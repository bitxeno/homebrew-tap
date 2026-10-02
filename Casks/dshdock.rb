# typed: strict
# frozen_string_literal: true

cask "dshdock" do
  version "0.1.3"
  sha256 "5356e06e11e483c11fdb172b37daf3f94d46a9c8165d4c96cf408de8158077dc"

  url "https://github.com/bitxeno/dsh-dock/releases/download/v0.1.3/DshDock-0.1.3.dmg"
  name "DshDock"
  desc "Desktop shell hosting managed dsh web"
  homepage "https://github.com/bitxeno/dsh-dock"

  app "DshDock.app"

  # 构建未公证（ad-hoc 签名）：装完立即去隔离，免掉首启的 Gatekeeper 拦截。
  # 直接从 Release 下载 DMG 的用户不走这条路径，caveats 里保留手动方法。
  # 新 install-steps DSL 的坑（全部实测）：路径要用 {{appdir}} 模板标记
  # （Ruby 插值 #{appdir} 在块内未定义、相对路径不锚定 base、cop 只认
  # 纯字符串参数），块内只允许 run 等步骤调用。
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/DshDock.app"]
  end

  caveats <<~EOS
    直接下载 DMG 安装（不经 Homebrew）时，构建未做公证（ad-hoc 签名），
    首次启动若被 Gatekeeper 拦截：右键 App 选"打开"，或执行
      xattr -dr com.apple.quarantine /Applications/DshDock.app
  EOS
end
