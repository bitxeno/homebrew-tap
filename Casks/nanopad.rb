# typed: strict
# frozen_string_literal: true

cask "nanopad" do
arch arm: "arm64", intel: "amd64"

    version "0.15.5"
    sha256 arm: "6c9bdb502403553b179ca1744525e7937cba47c6ea1698ac2a3ec7d120ac4b5a", intel: "78196b531cdd18c20a98eedb4d55480187bc881b0706b02bdae96f9184634011"

    if ENV["HOMEBREW_GITHUB_API_TOKEN"].to_s.empty?
      url "https://github.com/bitxeno/NanoPad/releases/download/v0.15.5/NanoPad-0.15.5-darwin-#{arch}.zip"
    else
      url "https://api.github.com/repos/bitxeno/NanoPad/releases/assets/#{arch == "arm64" ? "671070650" : "671070652"}",
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
