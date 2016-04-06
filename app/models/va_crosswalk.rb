class VaCrosswalk < ActiveRecord::Base  
  validates :facility_code, presence: true, uniqueness: true
  before_save :set_derived_fields

  USE_COLUMNS = [:ope, :cross, :ope6]

  #############################################################################
  ## facility_code=
  ## Strips whitespace and sets value to upcase
  #############################################################################
  def facility_code=(value)
    write_attribute(:facility_code, value.try(:strip).try(:upcase))
  end

  #############################################################################
  ## ope=
  ## Strips whitespace and sets value to downcase, and pads ope with 0s
  #############################################################################
  def ope=(value)
    value = value.try(:strip).try(:downcase)
    value = nil if value.blank? || value == 'none' 

    write_attribute(:ope, DS::OpeId.pad(value))
  end

  #############################################################################
  ## cross=
  ## Strips whitespace and sets value to downcase, and pads ipeds with 0s
  #############################################################################
  def cross=(value)
    value = value.try(:strip).try(:downcase)
    value = nil if value.blank? || value == 'none' 

    write_attribute(:cross, DS::IpedsId.pad(value))
  end

  #############################################################################
  ## set_derived_fields=
  ## Computes the values of derived fields just prior to saving. Note that 
  ## any fields here cannot be part of validations.
  #############################################################################
  def set_derived_fields
    self.ope6 = DS::OpeId.to_ope6(ope)
  end
end
