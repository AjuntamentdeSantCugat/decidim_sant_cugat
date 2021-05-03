require 'csv'
require "#{Rails.root}/app/helpers/statistics_helper"
include StatisticsHelper

namespace :statistics do
  desc "Get statistics by gender and age"
  task by_gender_and_age: :environment do
    total_men_census = []
    total_women_census = []
    between_14_16_census = []
    between_17_25_census = []
    between_26_35_census = []
    between_36_50_census = []
    between_51_65_census = []
    between_66_80_census = []
    more_than_80_census = []
    
    puts "PROCESSING DATA......"
    
    csv = CSV.parse(File.read("data.csv"), headers: true)
    csv.each do |row|
      document = row[0].strip
      age = row[1]
      gender = row[2]

      unique_id = Digest::MD5.hexdigest("#{document}-#{Rails.application.secrets.secret_key_base}")
      auth = Decidim::Authorization.find_by(unique_id: unique_id)
      if auth.present?
        user = Decidim::User.find(auth.decidim_user_id)
        if gender == 'HOME'
          total_men_census << user.id
        else
          total_women_census << user.id
        end
        if age >= '14' && age <= '16'
          between_14_16_census << user.id
        elsif age >= '17' && age <= '25'
          between_17_25_census << user.id
        elsif age >= '26' && age <= '35'
          between_26_35_census << user.id
        elsif age >= '36' && age <= '50'
          between_36_50_census << user.id
        elsif age >= '51' && age <= '65'
          between_51_65_census << user.id
        elsif age >= '66' && age <= '80'
          between_66_80_census << user.id
        elsif age > '80'
          more_than_80_census << user.id
        end
      end
    end
    
    # QUERIES
    components_ids = [423, 424, 419, 420, 427, 421, 422, 417, 418, 425, 426, 429, 430]
    total_participants = Decidim::Proposals::ProposalVote.where(decidim_proposal_id: Decidim::Proposals::Proposal.where(decidim_component_id: components_ids).where("published_at IS NOT NULL AND (state != 'withdrawn' OR state IS NULL)").ids).pluck(:decidim_author_id).uniq
    total_participants_la_floresta = Decidim::Proposals::ProposalVote.where(decidim_proposal_id: Decidim::Proposals::Proposal.where(decidim_component_id: [417, 418]).where("published_at IS NOT NULL AND (state != 'withdrawn' OR state IS NULL)").ids).pluck(:decidim_author_id).uniq
    total_participants_mira_sol = Decidim::Proposals::ProposalVote.where(decidim_proposal_id: Decidim::Proposals::Proposal.where(decidim_component_id: [421, 422]).where("published_at IS NOT NULL AND (state != 'withdrawn' OR state IS NULL)").ids).pluck(:decidim_author_id).uniq
    total_participants_les_planes = Decidim::Proposals::ProposalVote.where(decidim_proposal_id: Decidim::Proposals::Proposal.where(decidim_component_id: [425, 426]).where("published_at IS NOT NULL AND (state != 'withdrawn' OR state IS NULL)").ids).pluck(:decidim_author_id).uniq
    total_participants_centre_est = Decidim::Proposals::ProposalVote.where(decidim_proposal_id: Decidim::Proposals::Proposal.where(decidim_component_id: [419, 420]).where("published_at IS NOT NULL AND (state != 'withdrawn' OR state IS NULL)").ids).pluck(:decidim_author_id).uniq
    total_participants_centre_oest = Decidim::Proposals::ProposalVote.where(decidim_proposal_id: Decidim::Proposals::Proposal.where(decidim_component_id: 427).where("published_at IS NOT NULL AND (state != 'withdrawn' OR state IS NULL)").ids).pluck(:decidim_author_id).uniq
    total_participants_nucli_antic = Decidim::Proposals::ProposalVote.where(decidim_proposal_id: Decidim::Proposals::Proposal.where(decidim_component_id: [423, 424]).where("published_at IS NOT NULL AND (state != 'withdrawn' OR state IS NULL)").ids).pluck(:decidim_author_id).uniq

    # PARTICIPANTS BY GENDER
    # ----------------------------------------------------------------------
    puts "TOTAL PARTICIPANTS BY GENDER"
    puts "% of women => #{percentage_participants_of_zone(total_women_census, total_participants)} %"
    puts "% of men => #{percentage_participants_of_zone(total_men_census, total_participants)} %"
    puts "-----------------------------"

    puts "TOTAL PARTICIPANTS BY GENDER IN 'LA FLORESTA'"
    puts "% of women => #{percentage_participants_of_zone(total_women_census, total_participants_la_floresta)} %"
    puts "% of men => #{percentage_participants_of_zone(total_men_census, total_participants_la_floresta)} %"
    puts "-----------------------------"

    puts "TOTAL PARTICIPANTS BY GENDER IN 'MIRA SOL'"
    puts "% of women => #{percentage_participants_of_zone(total_women_census, total_participants_mira_sol)} %"
    puts "% of men => #{percentage_participants_of_zone(total_men_census, total_participants_mira_sol)} %"
    puts "-----------------------------"

    puts "TOTAL PARTICIPANTS BY GENDER IN 'LES PLANES'"
    puts "% of women => #{percentage_participants_of_zone(total_women_census, total_participants_les_planes)} %"
    puts "% of men => #{percentage_participants_of_zone(total_men_census, total_participants_les_planes)} %"
    puts "-----------------------------"

    puts "TOTAL PARTICIPANTS BY GENDER IN 'CENTRE EST'"
    puts "% of women => #{percentage_participants_of_zone(total_women_census, total_participants_centre_est)} %"
    puts "% of men => #{percentage_participants_of_zone(total_men_census, total_participants_centre_est)} %"
    puts "-----------------------------"

    puts "TOTAL PARTICIPANTS BY GENDER IN 'CENTRE OEST'"
    puts "% of women => #{percentage_participants_of_zone(total_women_census, total_participants_centre_oest)} %"
    puts "% of men => #{percentage_participants_of_zone(total_men_census, total_participants_centre_oest)} %"
    puts "-----------------------------"

    puts "TOTAL PARTICIPANTS BY GENDER IN 'NUCLI ANTIC'"
    puts "% of women => #{percentage_participants_of_zone(total_women_census, total_participants_nucli_antic)} %"
    puts "% of men => #{percentage_participants_of_zone(total_men_census, total_participants_nucli_antic)} %"
    puts "-----------------------------"

    # PARTICIPANTS BY AGE
    # ----------------------------------------------------------------------
    puts "TOTAL PARTICIPANTS BY AGE"
    puts "% between 14 and 16 => #{percentage_participants_of_zone(between_14_16_census, total_participants)} %"
    puts "% between 17 and 25 => #{percentage_participants_of_zone(between_17_25_census, total_participants)} %"
    puts "% between 26 and 35 => #{percentage_participants_of_zone(between_26_35_census, total_participants)} %"
    puts "% between 36 and 50 => #{percentage_participants_of_zone(between_36_50_census, total_participants)} %"
    puts "% between 51 and 65 => #{percentage_participants_of_zone(between_51_65_census, total_participants)} %"
    puts "% between 66 and 80 => #{percentage_participants_of_zone(between_66_80_census, total_participants)} %"
    puts "% more than 80 => #{percentage_participants_of_zone(more_than_80_census, total_participants)} %"
    puts "-----------------------------"
 
    puts "TOTAL PARTICIPANTS BY AGE IN 'LA FLORESTA'"
    puts "% between 14 and 16 => #{percentage_participants_of_zone(between_14_16_census, total_participants_la_floresta)} %"
    puts "% between 17 and 25 => #{percentage_participants_of_zone(between_17_25_census, total_participants_la_floresta)} %"
    puts "% between 26 and 35 => #{percentage_participants_of_zone(between_26_35_census, total_participants_la_floresta)} %"
    puts "% between 36 and 50 => #{percentage_participants_of_zone(between_36_50_census, total_participants_la_floresta)} %"
    puts "% between 51 and 65 => #{percentage_participants_of_zone(between_51_65_census, total_participants_la_floresta)} %"
    puts "% between 66 and 80 => #{percentage_participants_of_zone(between_66_80_census, total_participants_la_floresta)} %"
    puts "% more than 80 => #{percentage_participants_of_zone(more_than_80_census, total_participants_la_floresta)} %"
    puts "-----------------------------"

    puts "TOTAL PARTICIPANTS BY AGE IN 'MIRA SOL'"
    puts "% between 14 and 16 => #{percentage_participants_of_zone(between_14_16_census, total_participants_mira_sol)} %"
    puts "% between 17 and 25 => #{percentage_participants_of_zone(between_17_25_census, total_participants_mira_sol)} %"
    puts "% between 26 and 35 => #{percentage_participants_of_zone(between_26_35_census, total_participants_mira_sol)} %"
    puts "% between 36 and 50 => #{percentage_participants_of_zone(between_36_50_census, total_participants_mira_sol)} %"
    puts "% between 51 and 65 => #{percentage_participants_of_zone(between_51_65_census, total_participants_mira_sol)} %"
    puts "% between 66 and 80 => #{percentage_participants_of_zone(between_66_80_census, total_participants_mira_sol)} %"
    puts "% more than 80 => #{percentage_participants_of_zone(more_than_80_census, total_participants_mira_sol)} %"
    puts "-----------------------------"
 
    puts "TOTAL PARTICIPANTS BY AGE IN 'LES PLANES'"
    puts "% between 14 and 16 => #{percentage_participants_of_zone(between_14_16_census, total_participants_les_planes)} %"
    puts "% between 17 and 25 => #{percentage_participants_of_zone(between_17_25_census, total_participants_les_planes)} %"
    puts "% between 26 and 35 => #{percentage_participants_of_zone(between_26_35_census, total_participants_les_planes)} %"
    puts "% between 36 and 50 => #{percentage_participants_of_zone(between_36_50_census, total_participants_les_planes)} %"
    puts "% between 51 and 65 => #{percentage_participants_of_zone(between_51_65_census, total_participants_les_planes)} %"
    puts "% between 66 and 80 => #{percentage_participants_of_zone(between_66_80_census, total_participants_les_planes)} %"
    puts "% more than 80 => #{percentage_participants_of_zone(more_than_80_census, total_participants_les_planes)} %"
    puts "-----------------------------"
 
    puts "TOTAL PARTICIPANTS BY AGE IN 'CENTRE EST'"
    puts "% between 14 and 16 => #{percentage_participants_of_zone(between_14_16_census, total_participants_centre_est)} %"
    puts "% between 17 and 25 => #{percentage_participants_of_zone(between_17_25_census, total_participants_centre_est)} %"
    puts "% between 26 and 35 => #{percentage_participants_of_zone(between_26_35_census, total_participants_centre_est)} %"
    puts "% between 36 and 50 => #{percentage_participants_of_zone(between_36_50_census, total_participants_centre_est)} %"
    puts "% between 51 and 65 => #{percentage_participants_of_zone(between_51_65_census, total_participants_centre_est)} %"
    puts "% between 66 and 80 => #{percentage_participants_of_zone(between_66_80_census, total_participants_centre_est)} %"
    puts "% more than 80 => #{percentage_participants_of_zone(more_than_80_census, total_participants_centre_est)} %"
    puts "-----------------------------"
 
    puts "TOTAL PARTICIPANTS BY AGE IN 'CENTRE OEST'"
    puts "% between 14 and 16 => #{percentage_participants_of_zone(between_14_16_census, total_participants_centre_oest)} %"
    puts "% between 17 and 25 => #{percentage_participants_of_zone(between_17_25_census, total_participants_centre_oest)} %"
    puts "% between 26 and 35 => #{percentage_participants_of_zone(between_26_35_census, total_participants_centre_oest)} %"
    puts "% between 36 and 50 => #{percentage_participants_of_zone(between_36_50_census, total_participants_centre_oest)} %"
    puts "% between 51 and 65 => #{percentage_participants_of_zone(between_51_65_census, total_participants_centre_oest)} %"
    puts "% between 66 and 80 => #{percentage_participants_of_zone(between_66_80_census, total_participants_centre_oest)} %"
    puts "% more than 80 => #{percentage_participants_of_zone(more_than_80_census, total_participants_centre_oest)} %"
    puts "-----------------------------"
 
    puts "TOTAL PARTICIPANTS BY AGE IN 'NUCLI ANTIC'"
    puts "% between 14 and 16 => #{percentage_participants_of_zone(between_14_16_census, total_participants_nucli_antic)} %"
    puts "% between 17 and 25 => #{percentage_participants_of_zone(between_17_25_census, total_participants_nucli_antic)} %"
    puts "% between 26 and 35 => #{percentage_participants_of_zone(between_26_35_census, total_participants_nucli_antic)} %"
    puts "% between 36 and 50 => #{percentage_participants_of_zone(between_36_50_census, total_participants_nucli_antic)} %"
    puts "% between 51 and 65 => #{percentage_participants_of_zone(between_51_65_census, total_participants_nucli_antic)} %"
    puts "% between 66 and 80 => #{percentage_participants_of_zone(between_66_80_census, total_participants_nucli_antic)} %"
    puts "% more than 80 => #{percentage_participants_of_zone(more_than_80_census, total_participants_nucli_antic)} %"
    puts "-----------------------------"
  end
end
