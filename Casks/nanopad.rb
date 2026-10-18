# typed: strict
# frozen_string_literal: true

cask "nanopad" do
arch arm: "arm64", intel: "amd64"

    version "0.7.0"
    sha256 arm: "59805db6aeb287ecbf72a92869a2fd2e79176cdecb842bd734d2c6d9677aadc7", intel: "b20b208c995e0ad3e69750dfe0bbef83ddda9c756ea9c2ee79e3ad80204c6cb4"

    if ENV["HOMEBREW_GITHUB_API_TOKEN"].to_s.empty?
      url "https://github.com/bitxeno/NanoPad/releases/download/v0.7.0/NanoPad-0.7.0-darwin-#{arch}.zip"
    else
      url "https://api.github.com/repos/bitxeno/NanoPad/releases/assets/#{arch == "arm64" ? "653580371" : "653580373"}",
        header: [
          "Accept: application/octet-stream",
          "Authorization: Bearer #{ENV["HOMEBREW_GITHUB_API_TOKEN"]}",
        ]
    end
  name "NanoPad"
  desc "Lightweight native code editor"
  homepage "https://github.com/bitxeno/NanoPad"

  app "NanoPad.app"

  # 构建未公证（ad-hoc 签名）：装完立即去隔离，免掉首启的 Gatekeeper 拦截。
  # 直接从 Release 下载 zip 的用户不走这条路径，caveats 里保留手动方法。
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/NanoPad.app"]
  end

  caveats <<~EOS
    直接下载 zip 安装（不经 Homebrew）时，构建未做公证（ad-hoc 签名），
    首次启动若被 Gatekeeper 拦截：右键 App 选"打开"，或执行
      xattr -dr com.apple.quarantine /Applications/NanoPad.app
  EOS
end
