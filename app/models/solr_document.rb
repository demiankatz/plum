# -*- encoding : utf-8 -*-
class SolrDocument
  include Blacklight::Solr::Document
  # Adds CurationConcerns behaviors to the SolrDocument.
  include CurationConcerns::SolrDocumentBehavior

  # self.unique_key = 'id'
  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)
  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  # Do content negotiation for AF models.

  use_extension(Hydra::ContentNegotiation)

  def date_created
    self[Solrizer.solr_name('date_created')]
  end

  def state
    Array(self[Solrizer.solr_name("state")]).first
  end

  def type
    self['active_fedora_model_ssi']
  end

  def viewing_hint
    Array(self[Solrizer.solr_name("viewing_hint")]).first
  end

  def viewing_direction
    Array(self[Solrizer.solr_name("viewing_direction")]).first
  end

  def identifier
    Array(self[Solrizer.solr_name("identifier")]).first
  end

  def workflow_note
    self[Solrizer.solr_name('workflow_note')]
  end

  def logical_order
    @logical_order ||=
      begin
        JSON.parse(self[Solrizer.solr_name("logical_order", :symbol)].first)
      rescue
        {}
      end
  end

  def file_label
    Array(self[Solrizer.solr_name('label')]).first
  end

  def exhibit_id
    self[Solrizer.solr_name('exhibit_id')]
  end
end
