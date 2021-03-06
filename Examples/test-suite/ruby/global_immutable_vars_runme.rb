#!/usr/bin/env ruby
#
# Here the proper generation of mutable and immutable variables is tested
# in the target language.
# Immutable variables do not have "<var>=" methods generated by SWIG,
# therefore trying to assign these variables shall throw a NoMethodError
# exception.
#

require 'swig_assert'

require 'global_immutable_vars'

# first check if all variables can be read
swig_assert_each_line( <<EOF )
Global_immutable_vars::default_mutable_var == 40
Global_immutable_vars::global_immutable_var == 41
Global_immutable_vars::specific_mutable_var == 42
Global_immutable_vars::global_mutable_var == 43
Global_immutable_vars::specific_immutable_var == 44
EOF

# check that all mutable variables can be modified
swig_assert_each_line( <<EOF )
Global_immutable_vars::default_mutable_var = 80
Global_immutable_vars::default_mutable_var == 80
Global_immutable_vars::specific_mutable_var = 82
Global_immutable_vars::specific_mutable_var == 82
Global_immutable_vars::global_mutable_var = 83
Global_immutable_vars::global_mutable_var == 83
EOF

# now check that immutable variables cannot be modified
had_exception = false
begin
  Global_immutable_vars::global_immutable_var = 81
rescue NoMethodError => e
  had_exception = true
end
swig_assert(had_exception, nil,
            "Global_immutable_vars::global_immutable_var is writable (expected to be immutable)")

had_exception = false
begin
  Global_immutable_vars::specific_immutable_var = 81
rescue NoMethodError => e
  had_exception = true
end
swig_assert(had_exception, nil,
            "Global_immutable_vars::specific_immutable_var is writable (expected to be immutable)")

swig_assert(Global_immutable_vars::check_values(80, 41, 82, 83, 44) == 1, nil, "Check values failed")
