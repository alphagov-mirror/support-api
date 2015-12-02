require 'organisation_lookups/base_info_lookup'

module OrganisationLookups
  class DeptsAndPolicyContentLookup < BaseInfoLookup
    def applies?(path)
      path =~ %r{^/government/} && path !~ %r{^/government/organisations}
    end

    def path_of_parent_content_item(path)
      # to handle sub-pages that belong to a particular document (eg an HTML publication)
      # eg /government/publications/customer-service-commitments-uk-visas-and-immigration/uk-visas-and-immigration-customer-commitments
      # the path is stripped back to the parent page
      # (in the example, this is /government/publications/customer-service-commitments-uk-visas-and-immigration)
      URI(path).path.split("/")[0..3].join("/")
    end
  end
end
