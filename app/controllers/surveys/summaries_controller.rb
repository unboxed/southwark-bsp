module Surveys
  class SummariesController < ApplicationController
    def show
      @survey = survey
      @finish_survey = survey_early_finished? || @survey.sections.length == 6  
byebug
        
        # @next_section = next_survey_section(current_section: building_status.section, survey: survey, next_section: next_section)
    end

    private

      def survey
        Survey.find params[:survey_id]
      end

      def survey_early_finished?
        for m in @survey.sections
          case m.content_type 
          when "BuildingOwnership"
            if m.content.ownership_status == "i_am_not_associated_with_this_building"
              return true
            end
          when "BuildingStatus"
            if m.content.status == "demolished"
              return true
            end
          when "BuildingTenure"
            next
          when "BuildingHeight"
            if !m.content.higher_than_18_meters?
              return true
            end
          else
            return false
          end
        end
      end 
  end
end
