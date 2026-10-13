# typed: strict
# frozen_string_literal: true

cask "nanopad" do
arch arm: "arm64", intel: "amd64"

    version "0.1.0"
    sha256 arm: "5443bcaf3f7e0ee3420578ddb31891e939c5299ff7a3f3869ba3f2c7526f2b9b", intel: "0760a14d673b23a1a464a8dad236cc4dcd6b3a8c802b85d16d970a822c13fe49"

    if ENV["HOMEBREW_GITHUB_API_TOKEN"].to_s.empty?
      url "https://github.com/bitxeno/NanoPad/releases/download/v0.1.0/NanoPad-0.1.0-darwin-#{arch}.zip"
    else
      url "https://api.github.com/repos/bitxeno/NanoPad/releases/assets/#{arch == "arm64" ? "637533254" : "637533255"}",
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
