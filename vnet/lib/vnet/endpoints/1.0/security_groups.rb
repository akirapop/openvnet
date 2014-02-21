# -*- coding: utf-8 -*-

Vnet::Endpoints::V10::VnetAPI.namespace '/security_groups' do
  put_post_shared_params = [
    "display_name",
    "description",
    "rules"
  ]

  post do
    accepted_params = put_post_shared_params + ["uuid"]
    required_params = ["display_name"]

    #TODO: Check rules syntax. Possibly in the model and catch the exception
    #here to turn it into a proper api error.
    post_new(:SecurityGroup, accepted_params, required_params)
  end

  get do
    get_all :SecurityGroup
  end

  get '/:uuid' do
    get_by_uuid :SecurityGroup
  end

  delete '/:uuid' do
    delete_by_uuid :SecurityGroup
  end

  put '/:uuid' do
    update_by_uuid(:SecurityGroup, put_post_shared_params)
  end

  post '/:uuid/interfaces/:interface_uuid' do
    params = parse_params(@params, ['uuid', 'interface_uuid'])
    check_required_params(params, ['uuid', 'interface_uuid'])

    interface = check_syntax_and_get_id(M::Interface, params, 'interface_uuid', 'interface_id')
    security_group = check_syntax_and_get_id(M::SecurityGroup, params, 'uuid', 'security_group_id')

    M::InterfaceSecurityGroup.filter(:interface_id => interface.id,
      :security_group_id => security_group.id).empty? ||
    raise(E::RelationAlreadyExists, "#{interface.uuid} <=> #{security_group.uuid}")

    M::InterfaceSecurityGroup.create(params)
    respond_with(R::SecurityGroup.interfaces(security_group))
  end

  get '/:uuid/interfaces' do
    show_relations(:SecurityGroup, :interfaces)
  end

  delete '/:uuid/interfaces/:interface_uuid' do
    params = parse_params(@params, ['uuid', 'interface_uuid'])
    check_required_params(params, ['uuid', 'interface_uuid'])

    security_group = check_syntax_and_pop_uuid(M::SecurityGroup, params)
    interface = check_syntax_and_pop_uuid(M::Interface, params, 'interface_uuid')

    relations = M::InterfaceSecurityGroup.batch.filter(:interface_id => interface.id,
      :security_group_id => security_group.id).all.commit

    # We call the destroy class method so we go trough NodeApi and send an
    # update isolation event
    relations.each { |r| M::InterfaceSecurityGroup.destroy(r.id) }
    respond_with(R::SecurityGroup.interfaces(security_group))
  end
end
