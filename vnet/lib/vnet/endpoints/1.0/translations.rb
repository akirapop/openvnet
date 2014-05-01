# -*- coding: utf-8 -*-

#TODO: Write some FREAKING tests for this
Vnet::Endpoints::V10::VnetAPI.namespace '/translations' do
  include C::Translation

  def self.put_post_shared_params
    param_uuid M::Interface, :interface_uuid
    param :mode, :String, in: MODES
    param :passthrough, :Boolean
  end

  put_post_shared_params
  param_options :mode, required: true
  param_options :interface_uuid, required: true
  param_uuid M::Translation
  post do
    uuid_to_id(M::Interface, "interface_uuid", "interface_id")

    post_new(:Translation, accepted_params, required_params)
  end

  get do
    get_all(:Translation)
  end

  get '/:uuid' do
    get_by_uuid(:Translation)
  end

  delete '/:uuid' do
    delete_by_uuid(:Translation)
  end

  put_post_shared_params
  put '/:uuid' do
    uuid_to_id(M::Interface, "interface_uuid", "interface_id") if params["interface_uuid"]

    update_by_uuid(:Translation, put_post_shared_params)
  end

  param :ingress_ipv4_address, :String, transform: PARSE_IPV4, required: true
  param :egress_ipv4_address, :String, transform: PARSE_IPV4, required: true
  param :ingress_port_number, :Integer, transform: PARSE_PORT
  param :egress_port_number, :Integer, transform: PARSE_PORT
  param_uuid M::RouteLink, :route_link_uuid
  post '/:uuid/static_address' do
    translation = check_syntax_and_pop_uuid(M::Translation, params)

    route_link_id = if params['route_link_uuid']
      check_syntax_and_pop_uuid(M::RouteLink, params, 'route_link_uuid').id
    end

    if translation.mode != MODE_STATIC_ADDRESS
      raise(E::ArgumentError, "Translation mode must be '#{MODE_STATIC_ADDRESS}'.")
    end

    M::TranslationStaticAddress.create(
      translation_id: translation.id,
      route_link_id: route_link_id,
      ingress_ipv4_address: params["ingress_ipv4_address"],
      egress_ipv4_address: params["egress_ipv4_address"],
      ingress_port_number: params["ingress_port_number"],
      egress_port_number: params["egress_port_number"]
    )

    respond_with(R::Translation.translation_static_addresses(translation))
  end

  param :ingress_ipv4_address, :String, transform: PARSE_IPV4, required: true
  param :egress_ipv4_address, :String, transform: PARSE_IPV4, required: true
  param :ingress_port_number, :Integer, transform: PARSE_PORT
  param :egress_port_number, :Integer, transform: PARSE_PORT
  delete '/:uuid/static_address' do
    translation = check_syntax_and_pop_uuid(M::Translation, params)

    if translation.mode != MODE_STATIC_ADDRESS
      raise(E::ArgumentError, "Translation mode must be '#{MODE_STATIC_ADDRESS}'.")
    end

    M::TranslationStaticAddress.destroy(
      translation_id: translation.id,
      ingress_ipv4_address: params["ingress_ipv4_address"],
      egress_ipv4_address: params["egress_ipv4_address"],
      ingress_port_number: params["ingress_port_number"],
      egress_port_number: params["egress_port_number"])
    )

    respond_with(R::Translation.translation_static_addresses(translation))
  end

end
