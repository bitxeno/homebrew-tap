# typed: strict
# frozen_string_literal: true

cask "dshdock" do
  version "0.1.0"
  sha256 "ca26b10c5feb11b732819faca5b99201d6c400e2c30feff9c256813dd7554be7"

  url "https://github.com/bitxeno/dsh-dock/releases/download/v0.1.0/DshDock-0.1.0.dmg"
  name "DshDock"
  desc "Desktop shell hosting managed dsh web"
  homepage "https://github.com/bitxeno/dsh-dock"

  depends_on macos: :sequoia

  app "DshDock.app"

  # 构建未公证（ad-hoc 签名）：装完立即去隔离，免掉首启的 Gatekeeper 拦截。
  # 直接从 Release 下载 DMG 的用户不走这条路径，caveats 里保留手动方法。
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "#{appdir}/DshDock.app"]
  end

  caveats <<~EOS
    直接下载 DMG 安装（不经 Homebrew）时，构建未做公证（ad-hoc 签名），
    首次启动若被 Gatekeeper 拦截：右键 App 选"打开"，或执行
      xattr -dr com.apple.quarantine /Applications/DshDock.app
  EOS
end
