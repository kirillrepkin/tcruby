module Schema
  module V1

    class Balance
      def initialize(account)
        @account = account
      end
      def to_json
        {:user_id => @account.user.id, :sum => @account.sum, :currency => @account.currency}
      end
    end

    class Request
      def initialize(request)
        @request = request
      end
      def to_json
        { :id => @request.id, :sender_id => @request.sender_id,
          :recipient_id => @request.recipient_id,
          :sum => @request.sum, :currency => @request.currency}
      end
    end

    class Error
      def initialize(error)
        @error = error
      end
      def to_json
        {:message => @error.message, :class => @error.class, :time => Time.now.to_s, :trace_id => nil}
      end
    end

  end
end