# -*- coding: utf-8 -*-

module Vnet::NodeApi
  class InterfaceNetworkAssoc < EventBase
    class << self
      private

      def dispatch_created_item_events(model)
        dispatch_event(INTERFACE_NETWORK_ASSOC_CREATED_ITEM, model.to_hash)

        Celluloid::Logger.info "XXXXXXXXXXXX InterfaceNetworkAssoc #{model.inspect}"
      end

      def dispatch_deleted_item_events(model)
        dispatch_event(INTERFACE_NETWORK_ASSOC_DELETED_ITEM, model.to_hash)

        Celluloid::Logger.info "YYYYYYYYYYYY InterfaceNetworkAssoc #{model.inspect}"
      end

    end
  end
end
