# This is to fix a (bug?) in jruby.
# typically, when a ruby symbol is passed into a native java function,
# it should be converted to a java string by jruby.
# unfortunately, this conversion does not seem to take place when the native
# java function is overloaded.
# This method allows me to specify :symbol.to_java_string,
# so that I do not need to create a Ruby string from a symbol,
# just so that i can get a native java string

class Symbol
  JString = java.lang.String
  def to_java_string
    to_java(JString)
  end
end
