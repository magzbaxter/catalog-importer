# Setting up Homebrew Tap for catalog-importer

## Step 1: Create a new GitHub repository called `homebrew-catalog-importer`

Create a new repo at: https://github.com/new
- Repository name: `homebrew-catalog-importer`
- Description: "Homebrew tap for catalog-importer with multi-header authentication"
- Public repository

## Step 2: Create the formula file

In that repository, create: `Formula/catalog-importer.rb`

```ruby
class CatalogImporter < Formula
  desc "Import catalog data into incident.io with multi-header authentication support"
  homepage "https://github.com/magzbaxter/catalog-importer"
  url "https://github.com/magzbaxter/catalog-importer/archive/refs/heads/maggie-backstage.tar.gz"
  version "maggie-backstage"
  sha256 "REPLACE_WITH_ACTUAL_SHA256"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/catalog-importer"
  end

  test do
    assert_match "catalog-importer", shell_output("#{bin}/catalog-importer --help")
  end
end
```

## Step 3: Calculate SHA256

```bash
curl -L https://github.com/magzbaxter/catalog-importer/archive/refs/heads/maggie-backstage.tar.gz | shasum -a 256
```

Replace `REPLACE_WITH_ACTUAL_SHA256` with the output.

## Step 4: Usage

Users can then install with:

```bash
brew tap magzbaxter/catalog-importer
brew install catalog-importer
```

Or in one command:

```bash
brew install magzbaxter/catalog-importer/catalog-importer
```