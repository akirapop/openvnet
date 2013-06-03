# -*- coding: utf-8 -*-

require "sinatra"
require "sinatra/vnmgr_api_setup"

module Vnmgr::Endpoints::V10
  class VNetAPI < Sinatra::Base
    class << self
      attr_accessor :conf

      def load_conf(*files)
        @conf = Vnmgr::Configurations::Vnmgr.load(*files)
      end
    end

    include Vnmgr::Endpoints::V10::Helpers
    register Sinatra::VnmgrAPISetup

    M = Vnmgr::ModelWrappers
    E = Vnmgr::Endpoints::Errors
    R = Vnmgr::Endpoints::V10::Responses

    def parse_params(params,mask)
      params.keys.each_with_object({}) do |key, h|
        h[key] = params[key] if mask.member?(key)
      end
    end

    respond_to :json, :yml

    load_namespace('networks')
    load_namespace('vifs')
    load_namespace('dhcp_ranges')
    load_namespace('mac_ranges')
    load_namespace('mac_leases')
    load_namespace('routers')
    load_namespace('tunnels')
    load_namespace('dc_networks')
    load_namespace('datapaths')
    load_namespace('open_flow_controllers')
    load_namespace('ip_addresses')
    load_namespace('ip_leases')
    load_namespace('network_services')
  end
end