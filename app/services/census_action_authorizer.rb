# frozen_string_literal: true

# It allows to set a list of valid
# - districts
# - district_councils
# for an authorization.
class CensusActionAuthorizer < Decidim::Verifications::DefaultActionAuthorizer
  attr_reader :allowed_districts, :allowed_district_councils

  # Overrides the parent class method, but it still uses it to keep the base behavior
  def authorize
    # Remove the additional setting from the options hash to avoid to be considered missing.
    @allowed_districts ||= options.delete("district")&.split(/[\W,;]+/)
    @allowed_district_councils ||= options.delete("district_council")&.split(/[\W,;]+/)

    status_code, data = *super

    extra_explanations = []
    if allowed_districts.present?
      # Does not authorize users with different districts
      if status_code == :ok && !allowed_districts.member?(authorization.metadata['district'])
        status_code = :unauthorized
        data[:fields] = { 'district' => authorization.metadata['district'] }
        # Adds an extra message to inform the user the additional restriction for this authorization
        extra_explanations << { key: "extra_explanation.districts",
                                params: { scope: "decidim.verifications.census_authorization",
                                          count: allowed_districts.count,
                                          districts: allowed_districts.join(", ") } }
      end
    end

    if allowed_district_councils.present?
      # Does not authorize users with different districts
      if status_code == :ok && !allowed_district_councils.member?(authorization.metadata['district_council'])
        status_code = :unauthorized
        data[:fields] = { 'district_council' => authorization.metadata['district_council'] }
        # Adds an extra message to inform the user the additional restriction for this authorization
        extra_explanations << { key: "extra_explanation.district_councils",
                                params: { scope: "decidim.verifications.census_authorization",
                                          count: allowed_district_councils.count,
                                          districts: allowed_district_councils.join(", ") } }
      end
    end

    data[:extra_explanation] = extra_explanations if extra_explanations.any?

    [status_code, data]
  end
end