# typed: strict
# frozen_string_literal: true

class Maclet < Formula
  desc "Polite macOS automation CLI for coding agents"
  homepage "https://github.com/bitxeno/maclet-cli"

  version "0.1.1"

  if Hardware::CPU.arm?
    if ENV["HOMEBREW_GITHUB_API_TOKEN"].to_s.empty?
      url "https://github.com/bitxeno/maclet-cli/releases/download/v0.1.1/maclet-0.1.1-darwin-arm64.tar.gz"
    else
      url "https://api.github.com/repos/bitxeno/maclet-cli/releases/assets/626920784",
          headers: [
            "Accept: application/octet-stream",
            "Authorization: Bearer #{ENV["HOMEBREW_GITHUB_API_TOKEN"]}",
          ]
    end
    sha256 "bd83002e6946d18ee248bc57d5ac783f66ff08658c2bb3c122143bf22cd97992"
  else
    if ENV["HOMEBREW_GITHUB_API_TOKEN"].to_s.empty?
      url "https://github.com/bitxeno/maclet-cli/releases/download/v0.1.1/maclet-0.1.1-darwin-amd64.tar.gz"
    else
      url "https://api.github.com/repos/bitxeno/maclet-cli/releases/assets/626920788",
          headers: [
            "Accept: application/octet-stream",
            "Authorization: Bearer #{ENV["HOMEBREW_GITHUB_API_TOKEN"]}",
          ]
    end
    sha256 "2831ce4d1256e69b679b200510300dc88018753188c0f1f2e6e025c58e5d376b"
  end

  # macOS-only: maclet dlopens system frameworks in-process
  # (libSystem/CF/CG/HIServices/AppKit), pure Go, no Xcode needed.
  depends_on macos: :sonoma

  def install
    bin.install "maclet"
  end

  def caveats
    <<~EOS
      maclet automates macOS through the accessibility and
      screen-recording grants of the app that runs it (your
      terminal / agent host) — not of the maclet binary itself.
      Run `maclet doctor`, enable Accessibility + Screen Recording
      for that app, then restart it. On macOS 15+, screen-recording
      approval re-asks about monthly.
    EOS
  end

  test do
    assert_match "maclet", shell_output("#{bin}/maclet --help")
  end
end
