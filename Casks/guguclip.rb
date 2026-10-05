# typed: strict
# frozen_string_literal: true

cask "guguclip" do
arch arm: "arm64", intel: "amd64"

    version "0.3.2"
    sha256 arm: "572c78549a36c767dabb241d162f2393d40a56275d786e99a8aba6c1faed8ed0", intel: "7f60257adb9d5460c09d195a88b7adf522f4076bb9f2a4e3af3867aed3e33ce2"

    if ENV["HOMEBREW_GITHUB_API_TOKEN"].to_s.empty?
      url "https://github.com/bitxeno/GuguClip/releases/download/v0.3.2/GuguClip-0.3.2-darwin-#{arch}.zip"
    else
      url "https://api.github.com/repos/bitxeno/GuguClip/releases/assets/#{arch == "arm64" ? "611711113" : "611711112"}",
        header: [
          "Accept: application/octet-stream",
          "Authorization: Bearer #{ENV["HOMEBREW_GITHUB_API_TOKEN"]}",
        ]
    end
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
