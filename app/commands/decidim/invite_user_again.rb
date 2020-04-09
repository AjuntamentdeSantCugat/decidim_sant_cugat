# frozen_string_literal: true

module Decidim
  # A command with the business logic to invite an user to an organization.
  class InviteUserAgain < Rectify::Command
    # Public: Initializes the command.
    #
    # form - A form object with the params.
    def initialize(user, instructions)
      @user = user
      @instructions = instructions
    end

    def call
      Sidekiq.logger.info "
        **********

        Dentro del InviteUserAgain en el call antes del return, user&.invited_to_sign_up?:\n
        #{user&.invited_to_sign_up?}
        
        **********
      "
      return broadcast(:invalid) unless user&.invited_to_sign_up?

      Sidekiq.logger.info "
        **********

        Dentro del InviteUserAgain en el call después del return, user.invited_by:\n
        #{user.invited_by}

        **********
      "

      user.invite!(user.invited_by, invitation_instructions: instructions)

      broadcast(:ok)
    end

    private

    attr_reader :user, :instructions
  end
end
