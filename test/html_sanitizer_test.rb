require "test_helper"

class HtmlSanitizerTest < Test::Unit::TestCase

  test "disallow a script tag" do
    html = "<script>alert('XSS')</script>"
    assert_equal "alert('XSS')", Govspeak::HtmlSanitizer.new(html).sanitize
  end

  test "disallow a javascript protocol in an attribute" do
    html = %q{<a href="javascript:alert(document.location);"
              title="Title">an example</a>}
    assert_equal "<a title=\"Title\">an example</a>", Govspeak::HtmlSanitizer.new(html).sanitize
  end

  test "disallow on* attributes" do
    html = %q{<a href="/" onclick="alert('xss');">Link</a>}
    assert_equal "<a href=\"/\">Link</a>", Govspeak::HtmlSanitizer.new(html).sanitize
  end

  test "allow non-JS HTML content" do
    html = "<a href='foo'>"
    assert_equal "<a href=\"foo\"></a>", Govspeak::HtmlSanitizer.new(html).sanitize
  end

  test "keep things that should be HTML entities" do
    html = "Fortnum & Mason"
    assert_equal "Fortnum &amp; Mason", Govspeak::HtmlSanitizer.new(html).sanitize
  end
end
