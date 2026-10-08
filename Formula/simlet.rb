# typed: strict
# frozen_string_literal: true

class Simlet < Formula
  desc "Agentless iOS/tvOS simulator automation CLI (HID + accessibility)"
  homepage "https://github.com/bitxeno/simlet-cli"

  version "0.1.0"

  if Hardware::CPU.arm?
    if ENV["HOMEBREW_GITHUB_API_TOKEN"].to_s.empty?
      url "https://github.com/bitxeno/simlet-cli/releases/download/v0.1.0/simlet-0.1.0-darwin-arm64.tar.gz"
    else
      url "https://api.github.com/repos/bitxeno/simlet-cli/releases/assets/622029729",
          headers: [
            "Accept: application/octet-stream",
            "Authorization: Bearer #{ENV["HOMEBREW_GITHUB_API_TOKEN"]}",
          ]
    end
    sha256 "5c269b0f016310c39a01210891acd209e4fa6068800fb2e119a48a639722c67e"
  else
    if ENV["HOMEBREW_GITHUB_API_TOKEN"].to_s.empty?
      url "https://github.com/bitxeno/simlet-cli/releases/download/v0.1.0/simlet-0.1.0-darwin-amd64.tar.gz"
    else
      url "https://api.github.com/repos/bitxeno/simlet-cli/releases/assets/622029721",
          headers: [
            "Accept: application/octet-stream",
            "Authorization: Bearer #{ENV["HOMEBREW_GITHUB_API_TOKEN"]}",
          ]
    end
    sha256 "be3111792479de97de500279c2c638e20f0eb960283e6384a3c2181a9754a46f"
  end

  # macOS-only: simlet dlopens Xcode's private SimulatorKit and
  # CoreSimulator frameworks in-process.
  depends_on macos: :monterey

  def install
    bin.install "simlet"
  end

  def caveats
    <<~EOS
      simlet drives simulators through Xcode's private frameworks —
      Xcode must be installed, and the target simulator booted.
      Requires macOS 12+; on tvOS only Siri Remote keys and focus
      navigation are supported (no coordinate taps).
    EOS
  end

  test do
    assert_match "simlet", shell_output("#{bin}/simlet --help")
  end
end
