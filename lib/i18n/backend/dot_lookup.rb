# frozen_string_literal: true

require "i18n"

module I18n
  module Backend
    class DotLookup < Simple
      INTERPOLATION_PATTERN = /%\{(\w+(?:\.\w+)+)\}/.freeze
      UNKNOWN_PROPERTY      = Object.new
      DOT                   = "."

      verbose = $VERBOSE
      $VERBOSE = nil
      ::I18n::INTERPOLATION_PATTERN =
        Regexp.union(INTERPOLATION_PATTERN, ::I18n::INTERPOLATION_PATTERN)
      $VERBOSE = verbose

      def translate(locale, key, options = {})
        raise InvalidLocale, locale unless locale

        options = options.dup
        entry = key && lookup(locale, key, options[:scope], options)

        if options.empty?
          entry = resolve(locale, key, entry, options)
        else
          count, default = options.values_at(:count, :default)
          values = options.except(*RESERVED_KEYS)

          entry = if entry.nil? && default
                    default(locale, key, default, options)
                  else
                    resolve(locale, key, entry, options)
                  end
        end

        if entry.nil?
          throw(:exception, I18n::MissingTranslation.new(locale, key, options))
        end

        entry = entry.dup if entry.is_a?(String)

        populate_options(entry, values) if entry.is_a?(String)
        entry = pluralize(locale, entry, count) if count
        entry = interpolate(locale, entry, values) if values
        entry
      end

      def populate_options(subject, options)
        extract_keys(subject).each_with_object(options) do |key, buffer|
          names = key.split(DOT)
          object = buffer[names.shift.to_sym]
          value = catch(:unknown_property) { get_value(object, names) }
          buffer[key.to_sym] = value if value != UNKNOWN_PROPERTY
        end
      end

      def extract_keys(subject)
        subject.scan(INTERPOLATION_PATTERN).flatten
      end

      def get_value(object, keys)
        keys.inject(object) do |target, key|
          unless target&.respond_to?(key)
            throw :unknown_property, UNKNOWN_PROPERTY
          end

          target.public_send(key)
        end
      end
    end
  end
end
