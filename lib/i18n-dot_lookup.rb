# frozen_string_literal: true

require "i18n/backend/dot_lookup"
I18n.backend = I18n::Backend::DotLookup.new

if I18n.config.respond_to?(:interpolation_patterns)
  I18n.config.interpolation_patterns <<
    I18n::Backend::DotLookup::INTERPOLATION_PATTERN
end
