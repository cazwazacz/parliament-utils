# Temporarily increasing to account for HybridBill document uploads
Rails.application.config.middleware.insert_before Rack::Runtime, Rack::Timeout, service_timeout: 60
