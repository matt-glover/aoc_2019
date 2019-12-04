defmodule FindPassword.MatcherTest do
  use ExUnit.Case
  doctest FindPassword.Matcher

  test "accepts a password that meets all criteria" do
    assert FindPassword.Matcher.is_match?(122_345) == true
    assert FindPassword.Matcher.is_match?(112_233) == true
    assert FindPassword.Matcher.is_match?(111_122) == true
  end

  test "rejects passwords that are fewer or greater than 6 digits" do
    assert FindPassword.Matcher.is_match?(0) == false
    assert FindPassword.Matcher.is_match?(11) == false
    assert FindPassword.Matcher.is_match?(112) == false
    assert FindPassword.Matcher.is_match?(446) == false
    assert FindPassword.Matcher.is_match?(7790) == false
    assert FindPassword.Matcher.is_match?(99999) == false
    assert FindPassword.Matcher.is_match?(9_999_999) == false
    assert FindPassword.Matcher.is_match?(99_999_999) == false
  end

  test "rejects values with no doubled digits" do
    assert FindPassword.Matcher.is_match?(123_789) == false
  end

  test "rejects values where a digit on the right is a decrease from the prior digit" do
    assert FindPassword.Matcher.is_match?(223_450) == false
    assert FindPassword.Matcher.is_match?(988_777) == false
  end

  test "rejects values where the doubled digits are part of a larger group" do
    assert FindPassword.Matcher.is_match?(111_111) == false
    assert FindPassword.Matcher.is_match?(123_444) == false
  end
end
