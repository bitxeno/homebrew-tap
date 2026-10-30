# typed: strict
# frozen_string_literal: true

class Simlet < Formula
  desc "Agentless iOS/tvOS simulator automation CLI (HID + accessibility)"
  homepage "https://github.com/bitxeno/simlet-cli"

  version "0.3.1"

  if Hardware::CPU.arm?
    if ENV["HOMEBREW_GITHUB_API_TOKEN"].to_s.empty?
      url "https://github.com/bitxeno/simlet-cli/releases/download/v0.3.1/simlet-0.3.1-darwin-arm64.tar.gz"
    else
      url "https://api.github.com/repos/bitxeno/simlet-cli/releases/assets/691960915",
          headers: [
            "Accept: application/octet-stream",
            "Authorization: Bearer #{ENV["HOMEBREW_GITHUB_API_TOKEN"]}",
          ]
    end
    sha256 "d552a23c3cf729c11bcec7b4ff4d60a639c8d509ee12a532ae1cf78f26d35ce9"
  else
    if ENV["HOMEBREW_GITHUB_API_TOKEN"].to_s.empty?
      url "https://github.com/bitxeno/simlet-cli/releases/download/v0.3.1/simlet-0.3.1-darwin-amd64.tar.gz"
    else
      url "https://api.github.com/repos/bitxeno/simlet-cli/releases/assets/691960914",
          headers: [
            "Accept: application/octet-stream",
            "Authorization: Bearer #{ENV["HOMEBREW_GITHUB_API_TOKEN"]}",
          ]
    end
    sha256 "01c6f4f2014a18a5a7873f8b7543fdb9c3aca995806a3ef86b31117f87bb3ce3"
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
