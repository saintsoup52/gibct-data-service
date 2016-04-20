class Sec702School < ActiveRecord::Base
  include Standardizable 
  
  validates :facility_code, presence: true, uniqueness: true

  USE_COLUMNS = [:sec_702]

  override_setters :facility_code, :sec_702

  # #############################################################################
  # ## facility_code=
  # ## Strips whitespace and sets value to upcase
  # #############################################################################
  # def facility_code=(value)
  #   write_attribute(:facility_code, value.try(:strip).try(:upcase))
  # end

  # #############################################################################
  # ## sec_702=
  # ## Converts truthy/falsy strings to booleans
  # #############################################################################
  # def sec_702=(value)
  #   write_attribute(:sec_702, DS::Truth.truthy?(value))
  # end
end
