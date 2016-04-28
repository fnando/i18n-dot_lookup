require "i18n"

module I18n
  module Backend
    class DotLookup < Simple
      KEY_EXTRACTOR     = /%\{(\w+(?:\.\w+)+)\}/
      UNKNOWN_PROPERTY  = Object.new
      DOT               = ".".freeze

      verbose, $VERBOSE = $VERBOSE, nil
      ::I18n::INTERPOLATION_PATTERN = Regexp.union(KEY_EXTRACTOR, ::I18n::INTERPOLATION_PATTERN)
      $VERBOSE = verbose

      def translate(locale, key, options = {})
        raise InvalidLocale.new(locale) unless locale
        entry = key && lookup(locale, key, options[:scope], options)

        if options.empty?
          entry = resolve(locale, key, entry, options)
        else
          count, default = options.values_at(:count, :default)
          values = options.except(*RESERVED_KEYS)
          entry = entry.nil? && default ?
            default(locale, key, default, options) : resolve(locale, key, entry, options)
        end

        throw(:exception, I18n::MissingTranslation.new(locale, key, options)) if entry.nil?
        entry = entry.dup if entry.is_a?(String)

        populate_options(entry, values) if entry.kind_of?(String)
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
        subject.scan(KEY_EXTRACTOR).flatten
      end

      def get_value(object, keys)
        value = keys.inject(object) do |target, key|
          throw :unknown_property, UNKNOWN_PROPERTY unless target && target.respond_to?(key)
          target.public_send(key)
        end

        value
      end
    end
  end
end
