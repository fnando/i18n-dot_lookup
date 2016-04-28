require "test_helper"

class DotLookupTest < Minitest::Test
  attr_reader :user

  def store_translations(translations = {})
    I18n.backend.store_translations :en, translations
  end

  setup do
    I18n.backend = I18n::Backend::DotLookup.new
    @user = OpenStruct.new(name: "john")
  end

  test "interpolate using property" do
    store_translations hello: "hello %{user.name}"
    assert_equal "hello john", I18n.t(:hello, user: user)
  end

  test "interpolate using nested property" do
    store_translations hello: "hello %{payload.user.name}"
    assert_equal "hello john", I18n.t(:hello, payload: OpenStruct.new(user: user))
  end

  test "interpolate nil value" do
    store_translations hello: "hello %{user.name}"
    assert_equal "hello ", I18n.t(:hello, user: OpenStruct.new(name: nil))
  end

  test "fail when object does not respond to property" do
    store_translations hello: "hello %{user.name}"

    assert_raises(I18n::MissingInterpolationArgument) {
      I18n.t(:hello, user: Object.new)
    }
  end
end
