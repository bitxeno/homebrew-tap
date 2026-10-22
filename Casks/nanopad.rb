# typed: strict
# frozen_string_literal: true

cask "nanopad" do
arch arm: "arm64", intel: "amd64"

    version "0.15.2"
    sha256 arm: "e178d52c52cc6ebe59a28befa96b5b9f8f412c7d62e9333b7b7772de61268bd2", intel: "b45af36c68e728213257e71b6b393125ce7410d45e800fafb86fe7c93e838f9b"

    if ENV["HOMEBREW_GITHUB_API_TOKEN"].to_s.empty?
      url "https://github.com/bitxeno/NanoPad/releases/download/v0.15.2/NanoPad-0.15.2-darwin-#{arch}.zip"
    else
      url "https://api.github.com/repos/bitxeno/NanoPad/releases/assets/#{arch == "arm64" ? "665238918" : "665238915"}",
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
