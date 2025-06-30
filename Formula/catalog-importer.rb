class CatalogImporter < Formula
  desc "Tool for importing catalog data into incident.io with multi-header authentication support"
  homepage "https://github.com/magzbaxter/catalog-importer"
  url "https://github.com/magzbaxter/catalog-importer/archive/maggie-backstage.tar.gz"
  version "maggie-backstage"
  sha256 "" # Will need to be calculated after creating the release
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/catalog-importer"
  end

  test do
    assert_match "catalog-importer", shell_output("#{bin}/catalog-importer --help")
  end
end