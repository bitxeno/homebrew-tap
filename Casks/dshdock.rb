# typed: strict
# frozen_string_literal: true

cask "dshdock" do
  version "0.1.0"
  sha256 "ca26b10c5feb11b732819faca5b99201d6c400e2c30feff9c256813dd7554be7"

  url "https://github.com/bitxeno/dsh-dock/releases/download/v0.1.0/DshDock-0.1.0.dmg"
  name "DshDock"
  desc "Desktop shell hosting managed dsh web"
  homepage "https://github.com/bitxeno/dsh-dock"

  app "DshDock.app"

  caveats <<~EOS
    构建 未做公证（ad-hoc 签名）。首次启动若被 Gatekeeper 拦截：
    右键 App 选"打开"，或执行
      xattr -dr com.apple.quarantine /Applications/DshDock.app
  EOS
end
