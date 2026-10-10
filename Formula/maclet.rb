# typed: strict
# frozen_string_literal: true

class Maclet < Formula
  desc "Polite macOS automation CLI for coding agents"
  homepage "https://github.com/bitxeno/maclet-cli"

  version "0.1.0"

  if Hardware::CPU.arm?
    if ENV["HOMEBREW_GITHUB_API_TOKEN"].to_s.empty?
      url "https://github.com/bitxeno/maclet-cli/releases/download/v0.1.0/maclet-0.1.0-darwin-arm64.tar.gz"
    else
      url "https://api.github.com/repos/bitxeno/maclet-cli/releases/assets/626911690",
          headers: [
            "Accept: application/octet-stream",
            "Authorization: Bearer #{ENV["HOMEBREW_GITHUB_API_TOKEN"]}",
          ]
    end
    sha256 "036cdb734f0e3722f0b4982341d68cf022c2f0fbec2493aaed29e6c43a4488e2"
  else
    if ENV["HOMEBREW_GITHUB_API_TOKEN"].to_s.empty?
      url "https://github.com/bitxeno/maclet-cli/releases/download/v0.1.0/maclet-0.1.0-darwin-amd64.tar.gz"
    else
      url "https://api.github.com/repos/bitxeno/maclet-cli/releases/assets/626911702",
          headers: [
            "Accept: application/octet-stream",
            "Authorization: Bearer #{ENV["HOMEBREW_GITHUB_API_TOKEN"]}",
          ]
    end
    sha256 "8fb01761e8a170b8346e594e7736a6b3f1d0cdde4ba87e7423db95f8badbd209"
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
