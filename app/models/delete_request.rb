class DeleteRequest < ActiveRecord::Base
  validates_uniqueness_of :song, :scope => [:artist, :album]
end
