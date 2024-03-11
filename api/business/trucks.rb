# frozen_string_literal: true

require './api/dao/trucks_dao'
require './api/services/http_client'
require './api/utils/constants'

module Business
  # Handle business logic for trucks
  class Trucks
    include Singleton

    def add(params)
      DAO::TrucksDAO.instance.add(params)
    end

    def remove(plate_number)
      p plate_number
      DAO::TrucksDAO.instance.remove(plate_number)
    end
    def trucks
      p 'trucks'
    end

    def available_trucks
      p 'available_trucks'
    end
    
    def truck_info(params)
      # document_id = params[:external_id]
      # document = DAO::DocumentsDAO.instance.search(id: document_id)
      # HttpClient.post(document.callback_url, { event_name: Constants::ExternalEvent::CONTRACT_SIGNED,
      #                                          source_id: document.source_id })
      # DAO::DocumentsDAO.instance.update(document_id, status: Constants::Documents::Status::SIGNED)
      p 'truck_info'
    end

    def status(params)
      p 'status'
    end

    def schedule(scheduling_date)
      p 'truck schedule'
    end
  end
end
