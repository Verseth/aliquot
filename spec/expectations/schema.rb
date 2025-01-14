require 'rspec/expectations'

RSpec::Matchers.define :satisfy_schema do |expected|
  match do |actual|
    @check = expected.call(actual)
    @check.success?
  end

  failure_message do
    <<~EOM
      expected that the given hash satisfy the schema, but:
        #{@check}
    EOM
  end
end

RSpec::Matchers.define :dissatisfy_schema do |expected, mismatches|
  match do |actual|

    check = expected.call(actual)

    @mismatches = mismatches

    @errors = check.errors.to_h

    return false if check.success?

    return true unless mismatches

    return false unless @errors.keys.include? mismatches.keys.first

    @errors.values.each do |error|
      return false unless mismatches.values.include? error
    end

    mismatches.values.each do |mismatch|
      return false unless @errors.values.include? mismatch
    end

    true
  end

  failure_message do
    <<~EOM
      expected that the given hash unsatisfy the schema this way:
        #{@mismatches}
      but got:
        #{@errors}
    EOM
  end
end
