# Configure Spree Preferences
#
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# In order to initialize a setting do:
# config.setting_name = 'new value'

S3_CONFIG = YAML.load_file("#{Rails.root}/config/s3.yml")[Rails.env]

Spree.config do |config|
  # Example:
  # Uncomment to override the default site name.
  # config.site_name = "Spree Demo Site"
  #config.allow_ssl_in_production = false
  config.use_s3 = true
  config.s3_bucket = S3_CONFIG['bucket']
  config.s3_access_key = S3_CONFIG['access_key_id']
  config.s3_secret = S3_CONFIG['secret_access_key']
  config.attachment_path = '/spree/products/:id/:style/:basename.:extension'
end

Spree.user_class = "Spree::User"

Spree::Auth::Config[:registration_step] = false;

Paperclip.interpolates(:s3_eu_url) do |attachment, style|
  "#{attachment.s3_protocol}://#{Spree::Config[:s3_host_alias]}/#{attachment.bucket_name}/#{attachment.path(style).gsub(%r{^/},"")}"
end
