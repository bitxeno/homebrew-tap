# typed: strict
# frozen_string_literal: true

class Maclet < Formula
  desc "Polite macOS automation CLI for coding agents"
  homepage "https://github.com/bitxeno/maclet-cli"

  version "0.2.0"

  if Hardware::CPU.arm?
    if ENV["HOMEBREW_GITHUB_API_TOKEN"].to_s.empty?
      url "https://github.com/bitxeno/maclet-cli/releases/download/v0.2.0/maclet-0.2.0-darwin-arm64.tar.gz"
    else
      url "https://api.github.com/repos/bitxeno/maclet-cli/releases/assets/627385089",
          headers: [
            "Accept: application/octet-stream",
            "Authorization: Bearer #{ENV["HOMEBREW_GITHUB_API_TOKEN"]}",
          ]
    end
    sha256 "6186cfbae5faf20bfce01e47343399ad4163558f9af3e6503ceda940d257bb4d"
  else
    if ENV["HOMEBREW_GITHUB_API_TOKEN"].to_s.empty?
      url "https://github.com/bitxeno/maclet-cli/releases/download/v0.2.0/maclet-0.2.0-darwin-amd64.tar.gz"
    else
      url "https://api.github.com/repos/bitxeno/maclet-cli/releases/assets/627385085",
          headers: [
            "Accept: application/octet-stream",
            "Authorization: Bearer #{ENV["HOMEBREW_GITHUB_API_TOKEN"]}",
          ]
    end
    sha256 "5fbcd11f584f3f786474dea8c307553e9819f05a6e475bb9d42f17b8f437d8a4"
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
