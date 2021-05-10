module WebpackBundleHelper
  class BundleNotFound < StandardError; end

  def javascript_bundle_tag(entry, **options)
    path = asset_bundle_path("#{entry}.js")

    options = {
      src: path,
      defer: true,
    }.merge(options)

    options.delete(:defer) if options[:async]

    javascript_include_tag "", **options
  end

  private

  MANIFEST_PATH = Rails.root.join('public', 'assets', 'manifest.json')

  def manifest
    @manifest ||= JSON.parse(File.read(MANIFEST_PATH))
  end

  def asset_bundle_path(entry, **options)
    raise BundleNotFound, "Could not find bundle with name #{entry}" unless manifest.key? entry
    asset_path(manifest.fetch(entry), **options)
  end
end