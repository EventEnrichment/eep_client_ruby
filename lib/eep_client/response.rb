class EepClient
  class Response
    OK = 'ok'
    MESSAGE = 'message'
    STATUS = 'status'
    ID = 'id'
    MESSAGES = 'messages'
    
    attr_reader :status
    
    def initialize(options = { })
      @status = options[STATUS]
      @message = options[MESSAGE]
      @id = options[ID]
      @messages = options[MESSAGES]
    end

    def self.new_instance(data)
      if data.has_key? OK
        OkResponse.new(data[OK])
      else
        ErrorResponse.new(data)
      end
    end

    def self.mock_event_ok
      OkResponse.new({ MESSAGE => 'event received', STATUS => 'unclassified', ID => 999 })
    end
    
    def self.mock_clear_ok
      OkResponse.new({ MESSAGE => 'event cleared', STATUS => 'unclassified', ID => 999 })
    end    
  end

  class OkResponse < Response
    attr_reader :message, :id

    def to_s
      "#{self.class.name} status: #@status, message: #@message, id: #@id"
    end
  end

  class ErrorResponse < Response
    attr_reader :messages
    def to_s
      "#{self.class.name} status: #@status, err_messages: #{@messages.join(', ')}"
    end
  end
end
