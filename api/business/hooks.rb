# frozen_string_literal: true

require './api/dao/hooks_dao'
require './api/services/http_client'
require './api/utils/constants'

module Business
  # Handle business logic for hooks
  class Hooks
    include Singleton

    def handle_mifiel_sign(params)
      Services[:database].transaction do
        return {} unless params.key?(:signed)

        DAO::HooksDAO.instance.add(Constants::HookTypes::MIFIEL_SIGN, params)

        signed_by_all = params[:signed_by_all]

        handle_sign_by_all(params) if signed_by_all&.to_s == 'true'

        { status: :ok }
      end
    end

    def handle_sign_by_all(params)
      document_id = params[:external_id]
      document = DAO::DocumentsDAO.instance.search(id: document_id)
      HttpClient.post(document.callback_url, { event_name: Constants::ExternalEvent::CONTRACT_SIGNED,
                                               source_id: document.source_id })
      DAO::DocumentsDAO.instance.update(document_id, status: Constants::Documents::Status::SIGNED)
    end
  end
end
