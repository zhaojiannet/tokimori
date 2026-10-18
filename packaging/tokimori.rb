cask "tokimori" do
  version "@VERSION@"
  sha256 "@SHA256@"

  url "https://github.com/zhaojiannet/tokimori/releases/download/v#{version}/Tokimori-#{version}.dmg"
  name "Tokimori"
  desc "Keep your Mac awake on demand or on a schedule, and open or quit apps at set times"
  homepage "https://github.com/zhaojiannet/tokimori"

  depends_on macos: ">= :sonoma"

  app "Tokimori.app"

  uninstall quit: "net.zhaojian.tokimori"

  zap trash: [
    "~/Library/Application Support/net.zhaojian.tokimori",
    "~/Library/Preferences/net.zhaojian.tokimori.plist",
  ]
end
