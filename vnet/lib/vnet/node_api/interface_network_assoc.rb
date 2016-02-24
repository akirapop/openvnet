# -*- coding: utf-8 -*-

module Vnet::NodeApi
  class InterfaceNetworkAssoc < EventBase
    class << self

      def attached_ip_lease(interface_id, network_id)
        transaction {
          if ip_lease_has_network(interface_id, network_id)
            default_create(interface_id: interface_id,
                           network_id: network_id)
          end
        }
      end

      def detached_ip_lease(interface_id, network_id)
        transaction {
          if !ip_lease_has_network(interface_id, network_id)
            default_destroy(interface_id: interface_id,
                            network_id: network_id)
          end
        }
      end

      private

      def ip_lease_has_network(interface_id, network_id)
        !model_class(:ip_lease).dataset.where(interface_id: interface_id).where_network_id(network_id).empty?
      end

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
