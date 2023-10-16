# frozen_string_literal: true

# This module creates an independent copy of array/hash.
module DeepCopy
  def deep_copy(object)
    Marshal.load(Marshal.dump(object))
  end
end
