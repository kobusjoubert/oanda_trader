# Replacement for Rails.application.secrets, which is deprecated in 7.1 and
# removed in 7.2. Loads config/secrets.yml via the supported config_for path
# and exposes it as a top-level SECRETS constant.
#
# Usage:
#   SECRETS.access_token_key
SECRETS = Rails.application.config_for(:secrets)
