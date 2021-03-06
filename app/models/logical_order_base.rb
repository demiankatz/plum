class LogicalOrderBase < ActiveFedora::Base
  property :nodes, predicate: ::RDF::Vocab::DC.hasPart
  property :head, predicate: ::RDF::Vocab::IANA['first'], multiple: false
  property :tail, predicate: ::RDF::Vocab::IANA.last, multiple: false

  def order=(order)
    nodes_will_change!
    head_will_change!
    tail_will_change!
    order = LogicalOrder.new((order), ::RDF::URI(rdf_subject))
    graph = order.to_graph
    # Delete old statements
    subj = resource.subjects.to_a.select { |x| x.to_s.split("/").last.to_s.include?("#g") }
    subj.each do |s|
      resource.delete [s, nil, nil]
    end
    self.head = nil
    self.tail = nil
    resource << graph
    # Set nodes so that hash URIs get persisted to Fedora.
    self.nodes = graph.subjects.select { |x| x != rdf_subject }
    @order = nil
    order
  end

  def order
    @order ||= LogicalOrderGraph.new(resource, rdf_subject).to_h
  end

  # Not useful and slows down indexing.
  def create_date
    nil
  end

  # Not useful, slows down indexing.
  def modified_date
    nil
  end

  # Serializing head/tail/nodes slows things down CONSIDERABLY, and is not
  # useful.
  # @note This method is used by ActiveFedora::Base upstream for indexing,
  #   at https://github.com/projecthydra/active_fedora/blob/master/lib/active_fedora/profile_indexing_service.rb.
  def serializable_hash(_options = nil)
    {}
  end
end
