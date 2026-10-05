# typed: strict
# frozen_string_literal: true

cask "guguclip" do
arch arm: "arm64", intel: "amd64"

    version "0.3.0"
    sha256 arm: "f48591f01cc28c97e1b7fd66584919066b3e66f7b8c5fd40b87727634bdcea26", intel: "a3765dc0e8914804d8f469272828a7d2583ff70266c94071c702ec4e0737723e"

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
