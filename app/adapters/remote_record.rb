##
# An adapter class to handle the difference between PUL's opinions on metadata
# and CC's "open world" assumptions. IE the date_created field is single-valued
# in MARC records, but multi-valued in Curation Concerns.
class RemoteRecord < SimpleDelegator
  class << self
    def retrieve(id)
      if id.present?
        new(PulMetadataServices::Client.retrieve(id))
      else
        Null.retrieve(id)
      end
    end
  end

  def attributes
    result = super
    result[:date_created] = Array(result[:date_created])
    result
  end

  # Null class.
  class Null
    include Singleton
    class << self
      def retrieve(_id)
        instance
      end
    end

    def source
      nil
    end

    def attributes
      {}
    end
  end
end
